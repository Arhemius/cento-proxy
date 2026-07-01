// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { B4s, B4Lib } from "./Bytes4ArrayLib.sol";

function B4(bytes memory data) pure returns (B4s memory) {
    return B4Lib.from(data);
}

function B4_(bytes memory data) pure returns (bytes4[] memory) {
    return B4(data).out();
}