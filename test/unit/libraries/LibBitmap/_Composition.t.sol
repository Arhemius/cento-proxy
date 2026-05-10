// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapAssert} from "./AAA/Assert.sol";
import {LibBitmapTestSetup} from "./AAA/Setup.sol";

/**
 * @title LibBitmap Composition Tests
 *
 * Tests cross-function interactions and complex scenarios
 */
contract LibBitmapCompositionTest is LibBitmapAssert {
    constructor() LibBitmapAssert(new LibBitmapTestSetup()) {}

    function test_Composition_FillAndPop_RoundTrip() public view {
        uint256 bitmap = given_EmptyBitmap();
        bitmap = when_FillSlotAt(bitmap, 5);
        bitmap = when_FillSlotAt(bitmap, 10);
        bitmap = when_FillSlotAt(bitmap, 15);

        (uint256 nextBitmap, uint8 index) = when_PopFirstFilledSlot(bitmap);
        then_IndexIs(index, 5);
        then_SlotEmpty(nextBitmap, 5);
        then_SlotOccupied(nextBitmap, 10);
        then_SlotOccupied(nextBitmap, 15);

        (nextBitmap, index) = when_PopFirstFilledSlot(nextBitmap);
        then_IndexIs(index, 10);
        then_SlotEmpty(nextBitmap, 5);
        then_SlotEmpty(nextBitmap, 10);
        then_SlotOccupied(nextBitmap, 15);

        (nextBitmap, index) = when_PopFirstFilledSlot(nextBitmap);
        then_IndexIs(index, 15);
        then_BitmapEmpty(nextBitmap);
    }

    function test_Composition_Sequential_FillClearFill() public view {
        uint256 bitmap = given_EmptyBitmap();
        bitmap = when_FillSlotAt(bitmap, 42);
        then_SlotOccupied(bitmap, 42);
        bitmap = when_ClearSlotAt(bitmap, 42);
        then_SlotEmpty(bitmap, 42);
        bitmap = when_FillSlotAt(bitmap, 42);
        then_SlotOccupied(bitmap, 42);
    }

    function test_Composition_CountConsistency() public view {
        uint256 bitmap = given_EmptyBitmap();
        bitmap = when_FillSlotAt(bitmap, 1);
        bitmap = when_FillSlotAt(bitmap, 100);
        bitmap = when_FillSlotAt(bitmap, 200);
        then_CountIs(when_CountFilledSlots(bitmap), 3);
        bitmap = when_ClearSlotAt(bitmap, 100);
        then_CountIs(when_CountFilledSlots(bitmap), 2);
        bitmap = when_FillSlotAt(bitmap, 50);
        then_CountIs(when_CountFilledSlots(bitmap), 3);
    }

    function test_Composition_GetFirstEmpty_AfterOperations() public view {
        uint256 bitmap = given_EmptyBitmap();
        for (uint8 i = 0; i < 5; i++) {
            bitmap = when_FillSlotAt(bitmap, i);
        }
        then_IndexIs(when_GetFirstEmptySlot(bitmap), 5);
        bitmap = when_ClearSlotAt(bitmap, 2);
        then_IndexIs(when_GetFirstEmptySlot(bitmap), 2);
    }

    function test_Composition_FullCycle() public view {
        uint256 bitmap = given_EmptyBitmap();
        for (uint16 i = 0; i < 256; i++) {
            bitmap = when_FillSlotAt(bitmap, _unsafeToUint8(i));
        }
        then_BitmapFull(bitmap);
        then_CountIs(when_CountFilledSlots(bitmap), 256);
        for (uint16 i = 0; i < 256; i++) {
            (uint256 nextBitmap, uint8 index) = when_PopFirstFilledSlot(bitmap);
            then_IndexIs(index, _unsafeToUint8(i));
            bitmap = nextBitmap;
        }
        then_BitmapEmpty(bitmap);
        then_CountIs(when_CountFilledSlots(bitmap), 0);
    }

    function testFuzz_Composition_RandomOperations(uint256 seed, uint8 operations) public view {
        uint256 bitmap = given_EmptyBitmap();
        uint8 ops = uint8(bound(operations, 1, 24));
        uint16 expectedCount = 0;
        uint8 previousPop;
        // STATE TRANSFORMATION PHASE
        for (uint8 i = 0; i < ops; i++) {
            uint8 index = uint8(uint256(keccak256(abi.encode(seed, i))) % 256);
            bool occupied = when_IsSlotOccupied(bitmap, index);
            uint16 countBefore = when_CountFilledSlots(bitmap);
            if (occupied) {
                bitmap = when_ClearSlotAt(bitmap, index);
                expectedCount--;
                then_SlotEmpty(bitmap, index);
                assertEq(when_CountFilledSlots(bitmap), countBefore - 1);
            } else {
                bitmap = when_FillSlotAt(bitmap, index);
                expectedCount++;
                then_SlotOccupied(bitmap, index);
                assertEq(when_CountFilledSlots(bitmap), countBefore + 1);
            }
            // single invariant check (kept minimal)
            assertEq(when_CountFilledSlots(bitmap), expectedCount);
        }
        // POP EXHAUSTION PHASE
        uint16 remaining = when_CountFilledSlots(bitmap);
        for (uint16 i = 0; i < remaining; i++) {
            uint16 countBefore = when_CountFilledSlots(bitmap);
            (uint256 nextBitmap, uint8 idx) = when_PopFirstFilledSlot(bitmap);
            assertEq(when_CountFilledSlots(nextBitmap), countBefore - 1);
            then_SlotOccupied(bitmap, idx);
            then_SlotEmpty(nextBitmap, idx);
            if (i != 0) assertGt(idx, previousPop);
            previousPop = idx;
            bitmap = nextBitmap;
        }
        // FINAL INVARIANT
        then_BitmapEmpty(bitmap);
    }
}