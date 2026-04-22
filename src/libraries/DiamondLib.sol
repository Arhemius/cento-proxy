// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { FacetStorage } from "../structs/FacetStorage.sol";
import { Facet } from "../structs/Facet.sol";


//add enforcement of contract code upon addition, update, or restoration of facets
//add an immutable function, defined directly in diamond
//change facet[] to facet[](256)
library DiamondLib {

    bytes32 constant BASE_SLOT = 0x69f90de95fb99742e875407e8b95a22f11141a7a0ca101bc562658f163a85b00;
    bytes32 constant FACET_START = 0x9470400c7fdb8128f3aa363e8652b960f10660822a80861e4d57916224d30600;


    event FacetAdded(uint256 indexed index, address facet);
    event FacetRemoved(uint256 indexed index);
    event FacetUpdated(uint256 indexed index, address oldFacet, address newFacet);
    event InterfaceAdded(bytes4 interfaceType);
    event InterfaceRemoved(bytes4 interfaceType);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function loadBaseSlot() internal pure returns (FacetStorage storage fs) {
        bytes32 position = BASE_SLOT;
        assembly {
            fs.slot := position
        }
    }

    function addFacet(FacetStorage storage fs, address facet) internal returns (uint256 index) {
        require(facet != address(0), "Invalid facet");
        require(fs.facets.length < 256, "Exceeded amount of supportable facets");
        uint256 bitmap = fs.emptySlots;
        if (bitmap != 0) {
            uint256 lsb = bitmap & (~bitmap + 1); 
            assembly {
                let x := lsb
                let r := 0
                if iszero(and(x, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)) {
                    x := shr(128, x)
                    r := add(r, 128)
                }
                if iszero(and(x, 0xFFFFFFFFFFFFFFFF)) {
                    x := shr(64, x)
                    r := add(r, 64)
                }
                if iszero(and(x, 0xFFFFFFFF)) {
                    x := shr(32, x)
                    r := add(r, 32)
                }
                if iszero(and(x, 0xFFFF)) {
                    x := shr(16, x)
                    r := add(r, 16)
                }
                if iszero(and(x, 0xFF)) {
                    x := shr(8, x)
                    r := add(r, 8)
                }
                if iszero(and(x, 0xF)) {
                    x := shr(4, x)
                    r := add(r, 4)
                }
                if iszero(and(x, 0x3)) {
                    x := shr(2, x)
                    r := add(r, 2)
                }
                if iszero(and(x, 0x1)) {
                    r := add(r, 1)
                }
                index := r
            }
            require(index < 256, "Index overflow");
            uint256 mask = uint256(1) << index;
            require((fs.emptySlots & mask) != 0, "Slot not free");
            if (index < fs.facets.length) {
                fs.facets[index] = facet;
            } else if (index == fs.facets.length) {
                fs.facets.push(facet);
            } else {
                assembly {
                    sstore(BASE_SLOT, add(index, 1))
                    sstore(add(FACET_START, index), facet)
                }
            }
            fs.emptySlots &= ~mask;
        } else {
            index = fs.facets.length;
            fs.facets.push(facet);
        }
        emit FacetAdded(index, facet);
    }

    function _setFacet(FacetStorage storage fs, uint256 index, address facet) internal {
        address old = fs.facets[index];
        fs.facets[index] = facet;
        emit FacetUpdated(index, old, facet);
    }

    function updateFacet(FacetStorage storage fs, uint256 index, address newFacet) internal {
        require(newFacet != address(0), "Invalid facet");
        require(index < fs.facets.length, "Out of bounds");
        require(fs.facets[index] != address(0), "Empty slot");
        require((fs.emptySlots & (uint256(1) << index)) == 0, "Slot marked free");
        _setFacet(fs, index, newFacet);
    }

    function removeFacet(FacetStorage storage fs, uint256 index) internal {
        uint256 mask = uint256(1) << index;
        require(index < fs.facets.length, "Out of bounds");
        require(fs.facets[index] != address(0), "Already empty");
        require((fs.emptySlots & mask) == 0, "Already marked free");
        fs.facets[index] = address(0);
        fs.emptySlots |= mask;
        emit FacetRemoved(index);
    }

    function restoreFacet(FacetStorage storage fs, uint256 index, address facet) internal {
        require(index < 256, "Index overflow");
        require(facet != address(0), "Invalid facet");
        uint256 mask = uint256(1) << index;
        require(fs.facets[index] == address(0) || (fs.emptySlots & mask) != 0, "Inconsistent state");
        uint256 len = fs.facets.length;
        if (index >= len) {
            assembly {
                sstore(BASE_SLOT, add(index, 1))
                sstore(add(FACET_START, index), facet)
            }
        }
        else {
            _setFacet(fs, index, facet);
        }
        fs.emptySlots &= ~mask;
        // assert((fs.emptySlots & mask) == 0);
    }

    function addInterface(FacetStorage storage fs, bytes4 interfaceType) internal {
        fs.supportedInterfaces[interfaceType] = true;
        emit InterfaceAdded(interfaceType);
    }

    function removeInterface(FacetStorage storage fs, bytes4 interfaceType) internal {
        fs.supportedInterfaces[interfaceType] = false;
        emit InterfaceRemoved(interfaceType);
    }

    function atomicUpdate(
        uint256[] memory toRemove, 
        Facet[] memory toUpdate, 
        Facet[] memory toRestore,
        address[] memory toAdd, 
        bytes4[] memory addI,
        bytes4[] memory removeI
    ) internal {
        FacetStorage storage fs = loadBaseSlot();
        for (uint256 i = 0; i < toRemove.length; i++) removeFacet(fs, toRemove[i]);
        for (uint256 i = 0; i < toUpdate.length; i++) updateFacet(fs, toUpdate[i].index, toUpdate[i].facet);
        for (uint256 i = 0; i < toRestore.length; i++) restoreFacet(fs, toRestore[i].index, toRestore[i].facet);
        for (uint256 i = 0; i < toAdd.length; i++)    addFacet(fs, toAdd[i]);
        for (uint256 i = 0; i < addI.length; i++)     addInterface(fs, addI[i]);
        for (uint256 i = 0; i < removeI.length; i++)  removeInterface(fs, removeI[i]);
    }

    function contractOwner() internal view returns (address owner_) {
        FacetStorage storage fs = loadBaseSlot();
        owner_ = fs.contractOwner;
    }
    
    function enforceIsContractOwner() internal view {
        require(msg.sender == loadBaseSlot().contractOwner, "LibDiamond: Must be contract owner");
    }

    function setContractOwner(address _newOwner) internal {
        FacetStorage storage fs = loadBaseSlot();
        address previousOwner = fs.contractOwner;
        fs.contractOwner = _newOwner;
        emit OwnershipTransferred(previousOwner, _newOwner);
    }
}