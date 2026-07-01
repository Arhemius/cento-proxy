// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { B32s, B32Lib } from "./Bytes32ArrayLib.sol";

function W(bytes memory data) pure returns (B32s memory) {
    return B32Lib.from(data);
}

function W_(bytes memory data) pure returns (bytes32[] memory) {
    return W(data).out();
}
