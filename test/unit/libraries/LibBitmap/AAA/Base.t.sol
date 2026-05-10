// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "../../../../../lib/forge-std/src/Test.sol";
import {IBitmap} from "../../../../_support/interfaces/IBitmap.sol";

/**
 * @title LibBitmap Base Test
 * @notice Foundation for all LibBitmap tests
 */
abstract contract LibBitmapTest is Test {
    // Common test constants
    uint256 constant EMPTY = 0;
    uint256 constant FULL = type(uint256).max;
    bytes4 constant POPFIRST_FILLED_SLOT = IBitmap.popFirstFilledSlot.selector;
    bytes4 constant GET_FIRST_EMPTY_SLOT = IBitmap.getFirstEmptySlot.selector;

    // Interface implementations for testing
    IBitmap internal implementation;
    IBitmap internal oracle;

    constructor(IBitmap _implementation, IBitmap _oracle) {
        implementation = _implementation;
        oracle = _oracle;
    }

    function _unsafeToUint8(uint256 x) internal pure returns (uint8 r) {
        assembly {
            r := x
        }
    }

    function _unsafeToSelector(bytes memory x) internal pure returns (bytes4 r) {
        assembly {
            r := mload(add(x, 32))
        }
    }
}