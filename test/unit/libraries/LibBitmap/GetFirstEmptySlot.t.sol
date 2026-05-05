// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapAssert} from "./AAA/Assert.sol";
import {LibBitmapTestSetup} from "./AAA/Setup.sol";
import {IBitmap} from "../../../_support/interfaces/IBitmap.sol";
import "../../../_support/etl/_ETL.sol";


/**
 * @title GetFirstEmptySlot Tests
 *
 * FUNCTION SPEC:
 * - Input: bitmap (uint256)
 * - Output: index (uint8)
 * - Behavior: Returns index of lowest empty slot
 * - Reverts: NoFreeSlots if bitmap is full
 */
contract GetFirstEmptySlotTest is LibBitmapAssert, Ops {
    using T for bytes;
    constructor() LibBitmapAssert(new LibBitmapTestSetup()) {}

    // === Input: Empty Bitmap ===

    function test_Empty_EmptyBitmap_Returns0() public view {
        uint256 bitmap = given_EmptyBitmap();
        uint8 idx = when_GetFirstEmptySlot(bitmap);
        then_IndexIs(idx, 0);
    }

    // === Input: Partially Filled ===

    function test_Empty_OnlySlot0Filled_Returns1() public view {
        uint256 bitmap = given_SingleBit(0);
        uint8 idx = when_GetFirstEmptySlot(bitmap);
        then_IndexIs(idx, 1);
    }

    function test_Empty_MultipleFilled_ReturnsLowestEmpty() public view {
        uint8[] memory filledIndices = abi.encode(5, 10, 15).u8();
        uint256 bitmap = given_MultipleBits(filledIndices);
        uint8 idx = when_GetFirstEmptySlot(bitmap);
        then_IndexIs(idx, 0); // 0 is still empty
    }

    function test_Empty_AllExceptLast_Returns255() public view {
        uint256 bitmap = given_AllExcept(255);
        uint8 idx = when_GetFirstEmptySlot(bitmap);
        then_IndexIs(idx, 255);
    }

    // === Error: Full Bitmap ===

    function test_Empty_FullBitmap_ErrorCompliance() public {
        uint256 bitmap = given_FullBitmap();
        then_CompliesWith_Error(IBitmap.getFirstEmptySlot.selector, bitmap);
    }

    // === Interface Compliance (Fuzz Tests) ===

    function testFuzz_GetFirstEmptySlot_Complies(uint256 bitmap) public view {
        vm.assume(bitmap != type(uint256).max); // Skip full bitmap (would revert)
        then_CompliesWith_GetFirstEmptySlot(bitmap);
    }
}