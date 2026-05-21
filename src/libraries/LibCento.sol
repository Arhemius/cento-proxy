// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { CentoStorage as CS } from "../structs/CentoStorage.sol";
import { Facet } from "../structs/Facet.sol";
import { LibBitmap as lb } from "./LibBitmap.sol";

library LibCento {
    using lb for uint256;

    bytes32 private constant BASE_SLOT = 0x69f90de95fb99742e875407e8b95a22f11141a7a0ca101bc562658f163a85b00;

    event InterfaceAdded(bytes4 interfaceType);
    event InterfaceRemoved(bytes4 interfaceType);
    event FacetAdded(uint8 indexed index, address facet);
    event FacetRemoved(uint8 indexed index, address old);
    event FacetUpdated(uint8 indexed index, address oldFacet, address newFacet);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    error ZeroFacetForEmptySlot();
    error RouterAsFacetForbidden();
    error NotContractOwner(address caller);
    error NoCodeOrEOA(address target);
    error Is7702EOA(address account);

    function _cs() internal pure returns (CS storage cs) {
        bytes32 position = BASE_SLOT;
        assembly { cs.slot := position }
    }

    function _setFacet(CS storage cs, uint8 index, address facet, uint256 bitmap) private returns (uint256) {
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
                bitmap.fillSlotAt(index);
                emit FacetAdded(index, facet);
            }
        } else {
            bitmap.clearSlotAt(index);
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

    function atomicUpdate(Facet[] memory setF, bytes4[] memory addI, bytes4[] memory remI) internal {
        CS storage cs = _cs();
        uint16 i; uint256 bitmap = cs.indexBitmap;
        for (     ; i < setF.length; i++) bitmap = _setFacet(cs, setF[i].index, setF[i].facet, bitmap);
        for (i = 0; i < addI.length; i++) _setInterface(cs, addI[i], true);
        for (i = 0; i < remI.length; i++) _setInterface(cs, remI[i], false);
        cs.indexBitmap = bitmap;
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

    function _isNotEoa(address a) private view {
        uint32 size;
        assembly { size := extcodesize(a) }
        if (size == 0) revert NoCodeOrEOA(a);
        bytes3 prefix;
        assembly { extcodecopy(a, prefix, 0, 3) }
        if (prefix != 0xef0100) revert Is7702EOA(a);
    }
}