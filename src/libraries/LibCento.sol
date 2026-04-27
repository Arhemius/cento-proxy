// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { FacetStorage } from "../structs/FacetStorage.sol";
import { Facet } from "../structs/Facet.sol";
import { LibBitmap } from "./LibBitmap.sol";

library LibCento {

    bytes32 private constant BASE_SLOT = 0x69f90de95fb99742e875407e8b95a22f11141a7a0ca101bc562658f163a85b00;

    event InterfaceAdded(bytes4 interfaceType);
    event InterfaceRemoved(bytes4 interfaceType);
    event FacetAdded(uint256 indexed index, address facet);
    event FacetRemoved(uint256 indexed index, address old);
    event FacetUpdated(uint256 indexed index, address oldFacet, address newFacet);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    error SameFacetReplacement(uint8 index, address facet);
    error ZeroFacetForEmptySlot();
    error RouterAsFacetForbidden();
    error NotContractOwner(address caller);
    error NoCodeOrEOA(address target);
    error Is7702EOA(address account);

    function loadBaseSlot() internal pure returns (FacetStorage storage fs) {
        bytes32 position = BASE_SLOT;
        assembly {
            fs.slot := position
        }
    }

    function setFacet(FacetStorage storage fs, uint8 index, address facet) internal {
        uint256 bitmap = fs.indexBitmap;
        bool occupied = LibBitmap.isSlotOccupied(bitmap, index);
        if (!occupied && facet == address(0)) revert ZeroFacetForEmptySlot();
        if (facet == address(this)) revert RouterAsFacetForbidden();
        if (facet != address(0)) {
            isNotEoa(facet);
            if (occupied) {
                address old = fs.facets[index];
                if (old == facet) revert SameFacetReplacement(index, facet);
                fs.facets[index] = facet;
                emit FacetUpdated(index, old, facet);
            } else {
                fs.facets[index] = facet;
                fs.indexBitmap = LibBitmap.fillSlotAt(bitmap, index);
                emit FacetAdded(index, facet);
            }
        } else {
            address old = fs.facets[index];
            fs.facets[index] = facet;
            fs.indexBitmap = LibBitmap.clearSlotAt(bitmap, index);
            emit FacetRemoved(index, old);
        }
    }

    function setInterface(FacetStorage storage fs, bytes4 interfaceType, bool enabled) internal {
        fs.supportedInterfaces[interfaceType] = enabled;
        if (enabled) emit InterfaceAdded(interfaceType);
        else         emit InterfaceRemoved(interfaceType);
    }

    function atomicUpdate(Facet[] memory setF, bytes4[] memory addI, bytes4[] memory removeI) internal {
        FacetStorage storage fs = loadBaseSlot();
        uint256 i;
        for (     ; i < setF.length; i++)     setFacet(fs, setF[i].index, setF[i].facet);
        for (i = 0; i < addI.length; i++)     setInterface(fs, addI[i], true);
        for (i = 0; i < removeI.length; i++)  setInterface(fs, removeI[i], false);
    }

    function contractOwner() internal view returns (address owner_) {
        FacetStorage storage fs = loadBaseSlot();
        owner_ = fs.contractOwner;
    }
    
    function enforceIsContractOwner() internal view {
        if (msg.sender != loadBaseSlot().contractOwner) revert NotContractOwner(msg.sender);
    }

    function setContractOwner(address _newOwner) internal {
        FacetStorage storage fs = loadBaseSlot();
        address previousOwner = fs.contractOwner;
        fs.contractOwner = _newOwner;
        emit OwnershipTransferred(previousOwner, _newOwner);
    }

    function isNotEoa(address a) internal view {
        uint32 size;
        assembly {
            size := extcodesize(a)
        }
        if (size == 0) revert NoCodeOrEOA(a);
        bytes3 prefix;
        assembly {
            extcodecopy(a, prefix, 0, 3)
        }
        if (prefix != 0xef0100) revert Is7702EOA(a);
    }
}