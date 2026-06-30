// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapTestSetup} from "./AAA/Setup.sol";
import {bitmap256, u} from "cento/libraries/LibBitmap.sol";
import "support/etl/UintArray/Uint8Array.sol";

/**
 * @title PopFirstFilledSlot Tests
 * @notice Test LibBitmap.popFirstFilledSlot via interface compliance
 *
 * FUNCTION SPEC:
 * - Input: bitmap (bitmap256)
 * - Output: (nextBitmap bitmap256, index uint8)
 * - Behavior: Returns index of lowest set bit, clears that bit
 * - Reverts: If bitmap is 0 (no filled slots)
 */
contract PopFirstFilledSlotTest is LibBitmapTestSetup {

    // === Input: Single Bit ===

    function test_Pop_SingleBit_Index0() public view {
        bitmap256 bitmap = given_SingleBit(0);
        (bitmap256 next, uint8 idx) = when_PopFirstFilledSlot(bitmap);
        then_IndexIs(idx, 0);
        then_BitmapEmpty(next);
    }

    function test_Pop_SingleBit_AnyIndex() public view {
        bitmap256 bitmap = given_SingleBit(42);
        (bitmap256 next, uint8 idx) = when_PopFirstFilledSlot(bitmap);
        then_IndexIs(idx, 42);
        then_BitmapEmpty(next);
    }

    // === Input: Multiple Bits ===

    function test_Pop_MultipleBits_ReturnsLowest() public view {
        uint8[] memory indices = U8_(abi.encode(100, 50, 200));
        bitmap256 bitmap = given_MultipleBits(indices);
        (, uint8 idx) = when_PopFirstFilledSlot(bitmap);
        then_IndexIs(idx, 50);
    }

    function test_Pop_MultipleBits_ClearsOnlyLowest() public view {
        uint8[] memory indices = U8_(abi.encode(10, 20));
        bitmap256 bitmap = given_MultipleBits(indices);
        (bitmap256 next,) = when_PopFirstFilledSlot(bitmap);
        then_SlotEmpty(next, 10);
        then_SlotOccupied(next, 20);
    }

    // === Input: Full Bitmap ===

    function test_Pop_FullBitmap_Index0() public view {
        bitmap256 bitmap = given_FullBitmap();
        (, uint8 idx) = when_PopFirstFilledSlot(bitmap);
        then_IndexIs(idx, 0);
    }

    // === Boundary Tests ===

    function test_Pop_BoundaryIndices() public view {
        uint8[] memory indices = U8_(abi.encode(0, 64, 128, 192, 255));
        bitmap256 next = given_MultipleBits(indices);
        uint8 idx;
        for (uint256 step; step < indices.length; step++) {
            (next, idx) = when_PopFirstFilledSlot(next);
            then_IndexIs(idx, indices[step]);
            for (uint256 i; i < indices.length; i++) {
                if (i <= step) then_SlotEmpty(next, indices[i]);
                else then_SlotOccupied(next, indices[i]);
            }
        }
        then_BitmapEmpty(next);
    }

    // === Revert Cases ===

    function test_Pop_EmptyBitmap_ErrorCompliance() public {
        bitmap256 bitmap = given_EmptyBitmap();
        then_CompliesWith_Error(POPFIRST_FILLED_SLOT, bitmap);
    }

    // === Sequential Pops ===

    function test_Pop_Sequential_OrderedIndices() public view {
        uint8[] memory inputIndices = U8_(abi.encode(200, 10, 100));
        uint8[] memory expectedOrder = U8_(abi.encode(10, 100, 200));
        bitmap256 bitmap = given_MultipleBits(inputIndices);
        (uint8[] memory poppedIndices, bitmap256 finalBitmap) = when_PopMultiple(bitmap, 3);
        then_PopSequenceIs(poppedIndices, expectedOrder);
        then_BitmapEmpty(finalBitmap);
    }

    // === Interface Compliance (Fuzz Tests) ===

    function testFuzz_Pop_Complies(bitmap256 bitmap) public view {
        vm.assume(u(bitmap) != u(EMPTY_BITMAP));
        then_CompliesWith_PopFirstFilledSlot(bitmap);
    }
}