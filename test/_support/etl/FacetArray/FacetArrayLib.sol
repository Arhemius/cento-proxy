// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "../_ETL.sol";
import {Facet} from "src/structs/Facet.sol";

struct Facet_ {
    uint256 index;
    address facet;
}

struct Facets {
    Facet_[] data;
}

using FacetLib for Facets global;

library FacetLib {

    function from(bytes memory data) internal pure returns (Facets memory) {
        return Facets({ data: _decode(data) });
    }

    function _decode(bytes memory data) private pure returns (Facet_[] memory output) {
        uint256[] memory arr = T.word(data);
        require(arr.length % 2 == 0, "Facet: invalid encoding");
        uint256 n = arr.length / 2;
        output = new Facet_[](n);
        for (uint256 i; i < n; i++) {
            uint256 indexRaw = arr[2 * i];
            uint256 facetRaw = arr[2 * i + 1];
            require(indexRaw <= type(uint8).max, "Facet: index overflow");
            output[i] = Facet_({
                index: indexRaw,                                                // forge-lint: disable-next-line(unsafe-typecast)
                facet: address(uint160(facetRaw))
            });
        }
    }

    function out(Facets memory self) internal pure returns (Facet_[] memory) {
        return self.data;
    }

    function _out(Facets memory self) internal pure returns (Facet[] memory output) {
        uint256 len = self.data.length;
        output = new Facet[](len);
        for (uint256 i; i < len; ++i) {
            uint256 index = self.data[i].index;
            require(index <= type(uint8).max, "Facet index exceeds uint8");
            output[i] = Facet({                                                 // forge-lint: disable-next-line(unsafe-typecast)
                index: uint8(index),
                facet: self.data[i].facet
            });
        }
    }

    function indices(Facets memory self) internal pure returns (uint8[] memory output) {
        uint256 n = self.data.length;
        output = new uint8[](n);
        for (uint256 i; i < n; i++) {
            require(self.data[i].index <= type(uint8).max, "Facet: index overflow");
            output[i] = uint8(self.data[i].index);
        }
    }

    function facets(Facets memory self) internal pure returns (address[] memory output) {
        uint256 n = self.data.length;
        output = new address[](n);
        for (uint256 i; i < n; i++) {
            output[i] = self.data[i].facet;
        }
    }
}