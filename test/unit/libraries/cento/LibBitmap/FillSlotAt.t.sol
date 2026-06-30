// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapTestSetup} from "./AAA/Setup.sol";
import {bitmap256} from "cento/libraries/LibBitmap.sol";
import "support/etl/UintArray/Uint8Array.sol";

/**
 * @title FillSlotAt Tests
 *
 * FUNCTION SPEC:
 * - Input: bitmap (bitmap256), index (uint8)
 * - Output: nextBitmap (bitmap256)
 * - Behavior: Sets bit at index
 * - Idempotent: Filling already-filled slot is no-op
 */
contract FillSlotAtTest is LibBitmapTestSetup {

    function test_Fill_EmptyBitmap_SetsBit() public view {
        bitmap256 bitmap = given_EmptyBitmap();
        bitmap256 next = when_FillSlotAt(bitmap, 42);
        then_SlotOccupied(next, 42);
    }

    function test_Fill_Idempotent() public view {
        bitmap256 bitmap = given_SingleBit(42);
        bitmap256 next = when_FillSlotAt(bitmap, 42);
        then_BitmapIs(next, bitmap);
    }

    function test_Fill_PreservesOtherBits() public view {
        bitmap256 bitmap = given_SingleBit(10);
        bitmap256 next = when_FillSlotAt(bitmap, 20);
        then_SlotOccupied(next, 10);
        then_SlotOccupied(next, 20);
    }

    function test_Fill_AllIndices() public view {
        bitmap256 bitmap = given_EmptyBitmap();
        for (uint16 i = 0; i < 256; i++) {
            bitmap = when_FillSlotAt(bitmap, _unsafeToUint8(i));
        }
        then_BitmapFull(bitmap);
    }

    // === Transition Tests ===

    function test_Fill_Sequential_FillsPreserveOrder() public view {
        bitmap256 bitmap = given_EmptyBitmap();
        uint8[] memory indices = U8_(abi.encode(10, 70, 150, 200, 255));
        for (uint256 i = 0; i < indices.length; i++) {
            bitmap = when_FillSlotAt(bitmap, indices[i]);
            then_SlotOccupied(bitmap, indices[i]);
        }
    }

    // === Interface Compliance (Fuzz Tests) ===

    function testFuzz_Fill_Complies(bitmap256 bitmap, uint8 index) public view {
        then_CompliesWith_FillSlotAt(bitmap, index);
    }
}