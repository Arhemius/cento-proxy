// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibCento as lc} from "src/libraries/LibCento.sol";
import {bitmap256} from "src/libraries/LibBitmap.sol";
import {CentoStorage} from "src/structs/CentoStorage.sol";

abstract contract LibCentoHarness {

    function CS() internal pure returns (CentoStorage storage cs) {
        cs = lc._cs();
    }


    function facetAt(uint8 i) external view returns (address) {
        return CS().facets[i];
    }

    function bitmap() external view returns (bitmap256) {
        return CS().indexBitmap;
    }

    function supportsInterface(bytes4 id) external view returns (bool) {
        return CS().supportedInterfaces[id];
    }

    function getContractOwner() external view returns (address) {
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
}