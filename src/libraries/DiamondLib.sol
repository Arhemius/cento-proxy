// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { FacetStorage } from "../structs/FacetStorage.sol";
import { Facet } from "../structs/Facet.sol";


//add enforcement of contract code upon addition, update, or restoration of facets
//add an immutable function, defined directly in diamond
//change emptySlot[] to bitmap
library DiamondLib {

    bytes32 constant BASE_SLOT = 0x69f90de95fb99742e875407e8b95a22f11141a7a0ca101bc562658f163a85b00;

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
        //require(fs.facets.length < 256, "Exceeded amount of supportable facets");
        if (fs.emptySlots.length > 0) {
            index = fs.emptySlots[fs.emptySlots.length - 1];
            fs.emptySlots.pop();
            fs.facets[index] = facet;
        } else {
            index = fs.facets.length;
            fs.facets.push(facet);
        }
        emit FacetAdded(index, facet);
    }

    function _setFacet(FacetStorage storage fs, uint256 index, address facet) internal {
        require(facet != address(0), "Invalid facet");
        address old = fs.facets[index];
        fs.facets[index] = facet;
        emit FacetUpdated(index, old, facet);
    }

    function updateFacet(FacetStorage storage fs, uint256 index, address newFacet) internal {
        require(index < fs.facets.length, "Out of bounds");
        require(fs.facets[index] != address(0), "Empty slot");
        _setFacet(fs, index, newFacet);
    }

    function removeFacet(FacetStorage storage fs, uint256 index) internal {
        require(index < fs.facets.length, "Out of bounds");
        require(fs.facets[index] != address(0), "Already empty");
        fs.facets[index] = address(0);
        fs.emptySlots.push(index);
        emit FacetRemoved(index);
    }

    function restoreFacet(FacetStorage storage fs, uint256 index, address facet) internal {
        _setFacet(fs, index, facet);
        uint256 len = fs.emptySlots.length;
        for (uint256 i = 0; i < len; i++) {
            if (fs.emptySlots[i] == index) {
                fs.emptySlots[i] = fs.emptySlots[len - 1];
                fs.emptySlots.pop();
                break;
            }
        }
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