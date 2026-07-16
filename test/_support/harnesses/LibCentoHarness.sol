// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {bitmap256} from "cento/types/bitmap256.sol";
import {CentoStorage} from "support/oracles/ReferenceCentoStorage.sol";

abstract contract LibCentoHarness {

    bytes32 private constant BASE_SLOT = 0x69f90de95fb99742e875407e8b95a22f11141a7a0ca101bc562658f163a85b00;

    function CS() internal pure returns (CentoStorage storage cs) {
        bytes32 position = BASE_SLOT;
        assembly { cs.slot := position }
    }


    function facetAt(uint8 i) external view returns (address) {
        return CS().facets[i];
    }

    function bitmap() public view returns (bitmap256) {
        return CS().indexBitmap;
    }

    function _supportsInterface(bytes4 id) external view returns (bool) {
        return CS().supportedInterfaces[id];
    }

    function getContractOwner() external view returns (address) {//???
        return CS().contractOwner;
    }

    function getFacetsAt(uint8[] memory i) external view returns (address[] memory out) {
        uint256 len = i.length;
        require(len != 0, "getFacetsAt: empty index array");
        out = new address[](len);
        CentoStorage storage cs = CS();
        for (uint256 k; k < len; ++k) {
            out[k] = cs.facets[i[k]];
        }
    }


    function setFacetAt(uint8 index, address facet) external {
        CS().facets[index] = facet;
    }

    function setBitmap(bitmap256 _bitmap) external {
        CS().indexBitmap = _bitmap;
    }

    function setInterface(bytes4 interfaceId, bool enabled) external {
        CS().supportedInterfaces[interfaceId] = enabled;
    }

    function setOwner(address owner) external {
        CS().contractOwner = owner;
    }


    function setFacetAtWithBitmap(uint8 index, address facet) external {
        CS().facets[index] = facet;
        CS().indexBitmap = CS().indexBitmap.fillSlotAt(index);
    }

    function removeFacetAtWithBitmap(uint8 index) external {
        CS().facets[index] = address(0);
        CS().indexBitmap = CS().indexBitmap.clearSlotAt(index);
    }

    function TestSlot(bytes32 slot) external view returns (bytes32 value) {
        assembly {
            value := sload(slot)
        }
    }
}