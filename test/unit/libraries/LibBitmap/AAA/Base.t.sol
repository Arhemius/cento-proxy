// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "../../../../../lib/forge-std/src/Test.sol";

/**
 * @title LibBitmap Base Test
 * @notice Foundation for all LibBitmap tests
 */ 
abstract contract LibBitmapTest is Test {
    // Common test constants
    uint256 constant EMPTY = 0;
    uint256 constant FULL = type(uint256).max;
    
    // Boundary indices
    uint8 constant FIRST = 0;
    uint8 constant LAST = 255;
    uint8 constant BOUNDARY_64 = 64;
    uint8 constant BOUNDARY_128 = 128;
    uint8 constant BOUNDARY_192 = 192;

    function _unsafeToUint8(uint256 x) internal pure returns (uint8 r) {
        assembly {
            r := x
        }
    }

    function _toSelectorUnsafe(bytes memory x) internal pure returns (bytes4 r) {
        assembly {
            r := mload(add(x, 32))
        }
    }
}