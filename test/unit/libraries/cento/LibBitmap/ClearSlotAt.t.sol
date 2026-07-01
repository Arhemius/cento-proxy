// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapTestSetup} from "./AAA/Setup.sol";
import {bitmap256} from "cento/libraries/LibBitmap.sol";
import "support/builtins/Builtins.sol";

/**
 * @title ClearSlotAt Tests
 *
 * FUNCTION SPEC:
 * - Input: bitmap (bitmap256), index (uint8)
 * - Output: nextBitmap (bitmap256)
 * - Behavior: Clears bit at index
 * - Idempotent: Clearing already-empty slot is no-op
 */
contract ClearSlotAtTest is LibBitmapTestSetup {
    
    function test_Clear_FullBitmap_ClearsBit() public view {
        bitmap256 bitmap = given_FullBitmap();
        bitmap256 next = when_ClearSlotAt(bitmap, 42);
        then_SlotEmpty(next, 42);
    }
    
    function test_Clear_Idempotent() public view {
        bitmap256 bitmap = given_EmptyBitmap();
        bitmap256 next = when_ClearSlotAt(bitmap, 42);
        then_BitmapIs(next, bitmap);
    }
    
    function test_Clear_PreservesOtherBits() public view {
        uint8[] memory indices = U8_(abi.encode(10, 20));
        bitmap256 bitmap = given_MultipleBits(indices);
        bitmap256 next = when_ClearSlotAt(bitmap, 10);
        then_SlotEmpty(next, 10);
        then_SlotOccupied(next, 20);
    }
    
    function test_Clear_AllIndices() public view {
        bitmap256 bitmap = given_FullBitmap();
        for (uint16 i = 0; i < 256; i++) {
            bitmap = when_ClearSlotAt(bitmap, _unsafeToUint8(i));
        }
        then_BitmapEmpty(bitmap);
    }
    
    // === Transition Tests ===
    
    function test_Clear_Sequential_ClearsPreserveOrder() public view {
        bitmap256 bitmap = given_FullBitmap();
        uint8[] memory indices = U8_(abi.encode(10, 70, 150, 200, 255));
        for (uint256 i = 0; i < indices.length; i++) {
            bitmap = when_ClearSlotAt(bitmap, indices[i]);
        }
        for (uint256 i = 0; i < indices.length; i++) {
            then_SlotEmpty(bitmap, indices[i]);
        }
    }

    // === Interface Compliance (Fuzz Tests) ===
    
    function testFuzz_Clear_Complies(bitmap256 bitmap, uint8 index) public view {
        then_CompliesWith_ClearSlotAt(bitmap, index);
    }
}