// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { FacetStorage } from "../structs/FacetStorage.sol";
import { Facet } from "../structs/Facet.sol";

library DiamondLib {

    bytes32 constant BASE_SLOT = 0x69f90de95fb99742e875407e8b95a22f11141a7a0ca101bc562658f163a85b00;

    event InterfaceAdded(bytes4 interfaceType);
    event InterfaceRemoved(bytes4 interfaceType);
    event FacetAdded(uint256 indexed index, address facet);
    event FacetRemoved(uint256 indexed index, address old);
    event FacetUpdated(uint256 indexed index, address oldFacet, address newFacet);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function loadBaseSlot() internal pure returns (FacetStorage storage fs) {
        bytes32 position = BASE_SLOT;
        assembly {
            fs.slot := position
        }
    }

    function setFacet(FacetStorage storage fs, uint8 index, address facet) internal {
        uint256 mask = uint256(1) << index;
        bool occupied = (fs.indexBitmap & mask) != 0;
        require(occupied || facet != address(0), "Invalid transition");
        require(facet != address(this), "Cannot register router as facet");
        address old = fs.facets[index];
        if (facet != address(0)) {
            require(old != facet, "Can't replace facet with same facet");
            isNotEoa(facet);
            fs.facets[index] = facet;
            if (occupied) {
                emit FacetUpdated(index, old, facet);
            } else {
                fs.indexBitmap |= mask;
                emit FacetAdded(index, facet);
            }
        } else if (occupied) {
            fs.indexBitmap &= ~mask;
            fs.facets[index] = address(0);
            emit FacetRemoved(index, old);
        }
    }

    function setInterface(FacetStorage storage fs, bytes4 interfaceType, bool enabled) internal {
        fs.supportedInterfaces[interfaceType] = enabled;
        if (enabled) emit InterfaceAdded(interfaceType);
        else  emit InterfaceRemoved(interfaceType);
    }

    function atomicUpdate(Facet[] memory setF, bytes4[] memory addI, bytes4[] memory removeI) internal {
        FacetStorage storage fs = loadBaseSlot();
        for (uint256 i = 0; i < setF.length; i++)     setFacet(fs, setF[i].index, setF[i].facet);
        for (uint256 i = 0; i < addI.length; i++)     setInterface(fs, addI[i], true);
        for (uint256 i = 0; i < removeI.length; i++)  setInterface(fs, removeI[i], false);
    }

    function contractOwner() internal view returns (address owner_) {
        FacetStorage storage fs = loadBaseSlot();
        owner_ = fs.contractOwner;
    }
    
    function enforceIsContractOwner() internal view {
        require(msg.sender == loadBaseSlot().contractOwner, "Must be contract owner");
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
        require(size > 0, "No code / EOA");
        bytes3 prefix;
        assembly {
            extcodecopy(a, prefix, 0, 3)
        }
        require(prefix != 0xef0100, "Facet is an EIP-7702 EOA");
    }
}