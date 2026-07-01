// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapTestSetup} from "./AAA/Setup.sol";
import {bitmap256, u} from "cento/libraries/LibBitmap.sol";
import "support/builtins/Builtins.sol";

/**
 * @title GetFirstEmptySlot Tests
 *
 * FUNCTION SPEC:
 * - Input: bitmap (bitmap256)
 * - Output: index (uint8)
 * - Behavior: Returns index of lowest empty slot
 * - Reverts: NoFreeSlots if bitmap is full
 */
contract GetFirstEmptySlotTest is LibBitmapTestSetup {

    // === Input: Empty Bitmap ===

    function test_Get_EmptyBitmap_Returns0() public view {
        bitmap256 bitmap = given_EmptyBitmap();
        uint8 idx = when_GetFirstEmptySlot(bitmap);
        then_IndexIs(idx, 0);
    }

    // === Input: Partially Filled ===

    function test_Get_OnlySlot0Filled_Returns1() public view {
        bitmap256 bitmap = given_SingleBit(0);
        uint8 idx = when_GetFirstEmptySlot(bitmap);
        then_IndexIs(idx, 1);
    }

    function test_Get_MultipleFilled_ReturnsLowestEmpty() public view {
        uint8[] memory filledIndices = U8_(abi.encode(5, 10, 15));
        bitmap256 bitmap = given_MultipleBits(filledIndices);
        uint8 idx = when_GetFirstEmptySlot(bitmap);
        then_IndexIs(idx, 0); // 0 is still empty
    }

    function test_Get_AllExceptLast_Returns255() public view {
        bitmap256 bitmap = given_AllExcept(255);
        uint8 idx = when_GetFirstEmptySlot(bitmap);
        then_IndexIs(idx, 255);
    }

    // === Error: Full Bitmap ===

    function test_Get_FullBitmap_ErrorCompliance() public {
        bitmap256 bitmap = given_FullBitmap();
        then_CompliesWith_Error(GET_FIRST_EMPTY_SLOT, bitmap);
    }

    // === Interface Compliance (Fuzz Tests) ===

    function testFuzz_Get_Complies(bitmap256 bitmap) public view {
        vm.assume(u(bitmap) != u(FULL_BITMAP)); // Skip full bitmap (would revert)
        then_CompliesWith_GetFirstEmptySlot(bitmap);
    }
}