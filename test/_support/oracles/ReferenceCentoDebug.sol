// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {ILibCento} from "support/interfaces/ILibCento.sol";
import { CentoStorage as CS } from "cento/structs/CentoStorage.sol";
import { bitmap256 } from "cento/libraries/LibBitmap.sol";

contract ReferenceCentoDebug is ILibCento {

    bytes32 private constant BASE_SLOT = 0x69f90de95fb99742e875407e8b95a22f11141a7a0ca101bc562658f163a85b00;

    function _cs() internal pure returns (CS storage cs) {
        bytes32 position = BASE_SLOT;
        assembly { cs.slot := position }
    }

    function setFacet(uint8 index, address facet, bitmap256 bitmap) external returns (bitmap256) {
        CS storage cs = _cs();
        bool occupied = bitmap.isSlotOccupied(index);
        if (!occupied && facet == address(0)) revert ZeroFacetForEmptySlot();
        if (facet == address(this)) revert RouterAsFacetForbidden();
        if (facet != address(0)) {
            _isNotEoa(facet);
            if (occupied) {
                if (cs.facets[index] == facet) return bitmap;
            } else bitmap = bitmap.fillSlotAt(index);
        } else bitmap = bitmap.clearSlotAt(index);
        cs.facets[index] = facet;
        return bitmap;
    }

    function contractOwner() external view returns (address owner_) {
        CS storage cs = _cs();
        owner_ = cs.contractOwner;
    }
    
    function enforceIsContractOwner() external view {
        if (msg.sender != _cs().contractOwner) revert NotContractOwner(msg.sender);
    }

    function setContractOwner(address _newOwner) external {
        CS storage cs = _cs();
        address previousOwner = cs.contractOwner;
        cs.contractOwner = _newOwner;
        emit OwnershipTransferred(previousOwner, _newOwner);
    }

    function _isNotEoa(address a) private view {
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

    function storageMigration(address migrator, bytes memory _calldata) external {
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