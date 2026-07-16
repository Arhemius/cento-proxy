// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapTest} from "./Base.t.sol";
import {bitmap256} from "cento/types/bitmap256.sol";
import {ErrorBuilders} from "./ErrorBuilders.sol";

abstract contract LibBitmapAssert is LibBitmapTest, ErrorBuilders {

    // === Output Verification ===

    function then_IndexIs(uint8 actual, uint8 expected) internal pure {
        assertEq(actual, expected, "Index mismatch");
    }

    function then_BitmapIs(bitmap256 actual, bitmap256 expected) internal pure {
        assertEq(bitmap256.unwrap(actual), bitmap256.unwrap(expected), "Bitmap mismatch");
    }

    function then_PopSequenceIs(uint8[] memory actual, uint8[] memory expected) internal pure {
        assertEq(actual.length, expected.length, "Pop sequence length mismatch");
        for (uint256 i = 0; i < expected.length; i++) {
            assertEq(
                actual[i],
                expected[i],
                string.concat("Pop sequence mismatch at position ", vm.toString(i))
            );
        }
    }

    function then_CountIs(uint16 actual, uint16 expected) internal pure {
        assertEq(actual, expected, "Count mismatch");
    }

    function then_IsOccupied(bool actual, bool expected) internal pure {
        assertEq(actual, expected, "Occupancy mismatch");
    }

    // === State Verification ===

    function then_SlotOccupied(bitmap256 bitmap, uint8 index) internal pure {
        assertTrue(bitmap.isSlotOccupied(index), "Slot should be occupied");
    }

    function then_SlotEmpty(bitmap256 bitmap, uint8 index) internal pure {
        assertFalse(bitmap.isSlotOccupied(index), "Slot should be empty");
    }

    function then_BitmapEmpty(bitmap256 bitmap) internal view {
        assertEq(bitmap256.unwrap(bitmap), bitmap256.unwrap(EMPTY_BITMAP), "Bitmap should be empty");
    }

    function then_BitmapFull(bitmap256 bitmap) internal view {
        assertEq(bitmap256.unwrap(bitmap), bitmap256.unwrap(FULL_BITMAP), "Bitmap should be full");
    }
}