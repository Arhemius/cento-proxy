// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "../_ETL.sol";

struct B4s {
    bytes4[] data;
}

using B4Lib for B4s global;

library B4Lib {

    function from(bytes memory data) internal pure returns (B4s memory) {
        return B4s({ data: _decode(data) });
    }

    function _decode(bytes memory data) private pure returns (bytes4[] memory output) {
        uint256[] memory arr = T.word(data);
        output = new bytes4[](arr.length);
        for (uint256 i; i < arr.length; i++) {
            require(arr[i] <= type(uint32).max, "B4: bytes overflow");
            output[i] = bytes4(uint32(uint256(arr[i])));
        }
    }

    function out(B4s memory self) internal pure returns (bytes4[] memory output) {
        return self.data;
    }
}