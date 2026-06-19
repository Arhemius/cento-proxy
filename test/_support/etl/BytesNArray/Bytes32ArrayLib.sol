// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "../_ETL.sol";

struct B32s {
    bytes32[] data;
}

using B32Lib for B32s global;

library B32Lib {

    function from(bytes memory data) internal pure returns (B32s memory) {
        return B32s({ data: _decode(data) });
    }

    function _decode(bytes memory data) private pure returns (bytes32[] memory output) {
        uint256[] memory arr = T.word(data);
        output = new bytes32[](arr.length);
        for (uint256 i; i < arr.length; i++) {
            output[i] = bytes32(arr[i]);
        }
    }

    function out(B32s memory self) internal pure returns (bytes32[] memory) {
        return self.data;
    }
}