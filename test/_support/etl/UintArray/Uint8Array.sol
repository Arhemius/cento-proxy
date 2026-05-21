// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "../_ETL.sol";

struct U8s {
    uint8[] data;
}

using U8Lib for U8s global;

library U8Lib {

    function from(bytes memory data) internal pure returns (U8s memory) {
        return U8s({ data: _decode(data) });
    }

    function _decode(bytes memory data) private pure returns (uint8[] memory output) {
        uint256[] memory arr = T.word(data);
        output = new uint8[](arr.length);
        for (uint256 i; i < arr.length; i++) {
            require(arr[i] <= type(uint8).max, "U8: overflow");
            output[i] = uint8(arr[i]);
        }
    }

    function out(U8s memory self) internal pure returns (uint8[] memory) {
        return self.data;
    }

}