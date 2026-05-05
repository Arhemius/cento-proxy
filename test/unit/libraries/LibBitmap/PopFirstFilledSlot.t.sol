// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapAssert} from "./AAA/Assert.sol";
import {LibBitmapTestSetup} from "./AAA/Setup.sol";
import {IBitmap} from "../../../_support/interfaces/IBitmap.sol";
import "../../../_support/etl/_ETL.sol";

/**
 * @title PopFirstFilledSlot Tests
 * @notice Test LibBitmap.popFirstFilledSlot via interface compliance
 *
 * FUNCTION SPEC:
 * - Input: bitmap (uint256)
 * - Output: (nextBitmap uint256, index uint8)
 * - Behavior: Returns index of lowest set bit, clears that bit
 * - Reverts: If bitmap is 0 (no filled slots)
 */
contract PopFirstFilledSlotTest is LibBitmapAssert, Ops {
    using T for bytes;
    constructor() LibBitmapAssert(new LibBitmapTestSetup()) {}

    // === Input: Single Bit ===

    function test_Pop_SingleBit_Index0() public view {
        uint256 bitmap = given_SingleBit(0);
        (uint256 next, uint8 idx) = when_PopFirstFilledSlot(bitmap);
        then_IndexIs(idx, 0);
        then_BitmapEmpty(next);
    }

    function test_Pop_SingleBit_AnyIndex() public view {
        uint256 bitmap = given_SingleBit(42);
        (uint256 next, uint8 idx) = when_PopFirstFilledSlot(bitmap);
        then_IndexIs(idx, 42);
        then_BitmapEmpty(next);
    }

    // === Input: Multiple Bits ===

    function test_Pop_MultipleBits_ReturnsLowest() public view {
        uint8[] memory indices = abi.encode(100, 50, 200).u8();
        uint256 bitmap = given_MultipleBits(indices);
        (, uint8 idx) = when_PopFirstFilledSlot(bitmap);
        then_IndexIs(idx, 50);
    }

    function test_Pop_MultipleBits_ClearsOnlyLowest() public view {
        uint8[] memory indices = abi.encode(10, 20).u8();
        uint256 bitmap = given_MultipleBits(indices);
        (uint256 next,) = when_PopFirstFilledSlot(bitmap);
        then_SlotEmpty(next, 10);
        then_SlotOccupied(next, 20);
    }

    // === Input: Full Bitmap ===

    function test_Pop_FullBitmap_ReturnsIndex0() public view {
        uint256 bitmap = given_FullBitmap();
        (, uint8 idx) = when_PopFirstFilledSlot(bitmap);
        then_IndexIs(idx, 0);
    }

    // === Boundary Tests ===

    function test_Pop_BoundaryIndices() public view {
        uint8[] memory indices = abi.encode(0, 64, 128, 192, 255).u8();
        uint256 next = given_MultipleBits(indices);
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
        uint256 bitmap = given_EmptyBitmap();
        then_CompliesWith_Error(IBitmap.popFirstFilledSlot.selector, bitmap);
    }

    // === Sequential Pops ===

    function test_Pop_Sequential_OrderedIndices() public view {
        uint8[] memory inputIndices = abi.encode(200, 10, 100).u8();
        uint8[] memory expectedOrder = abi.encode(10, 100, 200).u8();
        uint256 bitmap = given_MultipleBits(inputIndices);
        (uint8[] memory poppedIndices, uint256 finalBitmap) = when_PopMultiple(bitmap, 3);
        then_PopSequenceIs(poppedIndices, expectedOrder);
        then_BitmapEmpty(finalBitmap);
    }

    function test_Pop_Transition_FillThenPopSequence() public view {
        uint256 bitmap = given_EmptyBitmap();
        bitmap = when_FillSlotAt(bitmap, 5);
        bitmap = when_FillSlotAt(bitmap, 10);
        bitmap = when_FillSlotAt(bitmap, 3);
        (uint256 next1, uint8 idx1) = when_PopFirstFilledSlot(bitmap);
        then_IndexIs(idx1, 3);
        (uint256 next2, uint8 idx2) = when_PopFirstFilledSlot(next1);
        then_IndexIs(idx2, 5);
        (uint256 next3, uint8 idx3) = when_PopFirstFilledSlot(next2);
        then_IndexIs(idx3, 10);
        then_BitmapEmpty(next3);
    }

    // === Interface Compliance (Fuzz Tests) ===

    function testFuzz_PopFirstFilledSlot_Complies(uint256 bitmap) public view {
        vm.assume(bitmap != 0);
        then_CompliesWith_PopFirstFilledSlot(bitmap);
    }
}

