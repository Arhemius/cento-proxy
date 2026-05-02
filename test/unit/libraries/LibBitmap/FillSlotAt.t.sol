// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapAssert} from "./AAA/Assert.sol";
import {LibBitmap} from "../../../../src/libraries/LibBitmap.sol";

/**
 * @title FillSlotAt Tests
 * 
 * FUNCTION SPEC:
 * - Input: bitmap (uint256), index (uint8)
 * - Output: nextBitmap (uint256)
 * - Behavior: Sets bit at index
 * - Idempotent: Filling already-filled slot is no-op
 */
contract FillSlotAtTest is LibBitmapAssert {
    using LibBitmap for uint256;
    
    function test_Fill_EmptyBitmap_SetsBit() public pure {
        uint256 bitmap = given_EmptyBitmap();
        uint256 next = when_FillSlotAt(bitmap, 42);
        then_SlotOccupied(next, 42);
    }
    
    function test_Fill_Idempotent() public pure {
        uint256 bitmap = given_SingleBit(42);
        uint256 next = when_FillSlotAt(bitmap, 42);
        then_BitmapIs(next, bitmap);
    }
    
    function test_Fill_PreservesOtherBits() public pure {
        uint256 bitmap = given_SingleBit(10);
        uint256 next = when_FillSlotAt(bitmap, 20);
        then_SlotOccupied(next, 10);
        then_SlotOccupied(next, 20);
    }
    
    function test_Fill_AllIndices() public pure {
        uint256 bitmap = given_EmptyBitmap();
        for (uint16 i = 0; i < 256; i++) {
            bitmap = when_FillSlotAt(bitmap, _unsafeToUint8(i));
        }
        then_BitmapFull(bitmap);
    }
    
    function testFuzz_Oracle_Fill(uint256 bitmap, uint8 index) public pure {
        uint256 next = when_FillSlotAt(bitmap, index);
        then_MatchesOracle_FillSlotAt(bitmap, index, next);
    }
    
    // === Boundary Tests ===
    
    function test_Fill_BoundaryIndices() public pure {
        uint256 bitmap = given_EmptyBitmap();
        bitmap = when_FillSlotAt(bitmap, 0);
        then_SlotOccupied(bitmap, 0);
        bitmap = when_FillSlotAt(bitmap, 255);
        then_SlotOccupied(bitmap, 255);
        bitmap = when_FillSlotAt(bitmap, 64);
        then_SlotOccupied(bitmap, 64);
        bitmap = when_FillSlotAt(bitmap, 128);
        then_SlotOccupied(bitmap, 128);
        bitmap = when_FillSlotAt(bitmap, 192);
        then_SlotOccupied(bitmap, 192);
    }
    
    // === Transition Tests ===
    
    function test_Fill_Transition_FillClearFill() public pure {
        uint256 bitmap = given_EmptyBitmap();
        bitmap = when_FillSlotAt(bitmap, 42);
        then_SlotOccupied(bitmap, 42);
        bitmap = bitmap.clearSlotAt(42);
        then_SlotEmpty(bitmap, 42);
        bitmap = when_FillSlotAt(bitmap, 42);
        then_SlotOccupied(bitmap, 42);
    }
    
    function test_Fill_Transition_SequentialFillsPreserveOrder() public pure {
        uint256 bitmap = given_EmptyBitmap();
        uint8[] memory indices = new uint8[](5);
        indices[0] = 10;
        indices[1] = 50;
        indices[2] = 100;
        indices[3] = 200;
        indices[4] = 255;
        for (uint256 i = 0; i < indices.length; i++) {
            bitmap = when_FillSlotAt(bitmap, indices[i]);
        }
        for (uint256 i = 0; i < indices.length; i++) {
            then_SlotOccupied(bitmap, indices[i]);
        }
    }
}