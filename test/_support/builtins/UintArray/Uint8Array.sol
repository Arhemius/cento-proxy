// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { U8s, U8Lib } from "./Uint8ArrayLib.sol";

function U8(bytes memory data) pure returns (U8s memory) {
    return U8Lib.from(data);
}

function U8_(bytes memory data) pure returns (uint8[] memory) {
    return U8(data).out();
}