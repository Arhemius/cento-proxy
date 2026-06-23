// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { CentoStorage as CS } from "../structs/CentoStorage.sol";
import { Facet } from "../structs/Facet.sol";
import { bitmap256 } from "./LibBitmap.sol";
import "src/libraries/LibDebug.sol";

library LibCento {

    bytes32 constant BASE_SLOT = 0x69f90de95fb99742e875407e8b95a22f11141a7a0ca101bc562658f163a85b00;

    event InterfaceAdded(bytes4 interfaceType);
    event InterfaceRemoved(bytes4 interfaceType);
    event FacetAdded(uint8 indexed index, address facet);
    event FacetRemoved(uint8 indexed index, address old);
    event FacetUpdated(uint8 indexed index, address oldFacet, address newFacet);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event StorageMigrationSucceeded(address indexed migrator);

    error ZeroFacetForEmptySlot();
    error RouterAsFacetForbidden();
    error NotContractOwner(address caller);
    error NoCodeOrEOA(address target);
    error Is7702EOA(address account);
    error StorageMigrationFailed(address migrator);

    function _cs() internal pure returns (CS storage cs) {
        bytes32 position = BASE_SLOT;
        assembly { cs.slot := position }
    }

    function _setFacet(CS storage cs, uint8 index, address facet, bitmap256 bitmap) private returns (bitmap256) {
        bool occupied = bitmap.isSlotOccupied(index);
        if (!occupied && facet == address(0)) revert ZeroFacetForEmptySlot();
        if (facet == address(this)) revert RouterAsFacetForbidden();
        if (facet != address(0)) {
            _isNotEoa(facet);
            if (occupied) {
                address old = cs.facets[index];
                if (old == facet) return bitmap;
                emit FacetUpdated(index, old, facet);
            } else {
                bitmap = bitmap.fillSlotAt(index);
                emit FacetAdded(index, facet);
            }
        } else {
            bitmap = bitmap.clearSlotAt(index);
            emit FacetRemoved(index, cs.facets[index]);
        }
        cs.facets[index] = facet;
        return bitmap;
    }

    function _setInterface(CS storage cs, bytes4 interfaceType, bool enabled) private {
        cs.supportedInterfaces[interfaceType] = enabled;
        if (enabled) emit InterfaceAdded(interfaceType);
        else         emit InterfaceRemoved(interfaceType);
    }

    function atomicUpdate(
        Facet[]  memory setF, 
        bytes4[] memory addI,  bytes4[] memory remI,
        address     migrator,  bytes    memory _calldata
    ) internal {
        CS storage cs = _cs();
        uint16 i; bitmap256 bitmap = cs.indexBitmap;
        for (     ; i < setF.length; i++) bitmap = _setFacet(cs, setF[i].index, setF[i].facet, bitmap);
        for (i = 0; i < addI.length; i++)      _setInterface(cs, addI[i], true);
        for (i = 0; i < remI.length; i++)      _setInterface(cs, remI[i], false);
        cs.indexBitmap = bitmap;
        _storageMigration(migrator, _calldata);
    }

    function contractOwner() internal view returns (address owner_) {
        CS storage cs = _cs();
        owner_ = cs.contractOwner;
    }
    
    function enforceIsContractOwner() internal view {
        if (msg.sender != _cs().contractOwner) revert NotContractOwner(msg.sender);
    }

    function setContractOwner(address _newOwner) internal {
        CS storage cs = _cs();
        address previousOwner = cs.contractOwner;
        cs.contractOwner = _newOwner;
        emit OwnershipTransferred(previousOwner, _newOwner);
    }

    function __nonZeroAddress__(address a) private pure {
        if (Debug.ON) assert(a != address(0));
    }

    function _isNotEoa(address a) private view {
        __nonZeroAddress__(a);
        uint256 size;
        assembly { size := extcodesize(a) }
        if (size == 0) revert NoCodeOrEOA(a);
        bytes3 prefix;
        assembly ("memory-safe") {
            extcodecopy(a, 0x00, 0, 3)
            prefix := mload(0x00)
        }
        if (prefix == 0xef0100) revert Is7702EOA(a);
    }

    function _storageMigration(address migrator, bytes memory _calldata) private {
        if (migrator == address(0)) return;
        _isNotEoa(migrator);
        (bool success, bytes memory returndata) = migrator.delegatecall(_calldata);
        if (!success) {
            if (returndata.length > 0) assembly ("memory-safe") {
                revert(add(returndata, 32), mload(returndata))
            }
            revert StorageMigrationFailed(migrator);
        }
        emit StorageMigrationSucceeded(migrator);
    }
}