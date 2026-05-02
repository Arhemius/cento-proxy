// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapAssert} from "./AAA/Assert.sol";
import {LibBitmap} from "../../../../src/libraries/LibBitmap.sol";

/**
 * @title PopFirstFilledSlot Tests
 * @notice Test LibBitmap.popFirstFilledSlot
 * 
 * FUNCTION SPEC:
 * - Input: bitmap (uint256)
 * - Output: (nextBitmap uint256, index uint8)
 * - Behavior: Returns index of lowest set bit, clears that bit
 * - Reverts: If bitmap is 0 (no filled slots)
 */
contract PopFirstFilledSlotTest is LibBitmapAssert {
    using LibBitmap for uint256;
    
    // === Input: Single Bit ===
    
    function test_Pop_SingleBit_Index0() public pure {
        uint256 bitmap = given_SingleBit(0);
        (uint256 next, uint8 idx) = when_PopFirstFilledSlot(bitmap);
        then_IndexIs(idx, 0);
        then_BitmapEmpty(next);
    }
    
    function test_Pop_SingleBit_Index64() public pure {
        uint256 bitmap = given_SingleBit(64);
        (uint256 next, uint8 idx) = when_PopFirstFilledSlot(bitmap);
        then_IndexIs(idx, 64);
        then_BitmapEmpty(next);
    }
    
    function test_Pop_SingleBit_Index128() public pure {
        uint256 bitmap = given_SingleBit(128);
        (uint256 next, uint8 idx) = when_PopFirstFilledSlot(bitmap);
        then_IndexIs(idx, 128);
        then_BitmapEmpty(next);
    }
    
    function test_Pop_SingleBit_Index192() public pure {
        uint256 bitmap = given_SingleBit(192);
        (uint256 next, uint8 idx) = when_PopFirstFilledSlot(bitmap);
        then_IndexIs(idx, 192);
        then_BitmapEmpty(next);
    }
    
    function test_Pop_SingleBit_Index255() public pure {
        uint256 bitmap = given_SingleBit(255);
        (uint256 next, uint8 idx) = when_PopFirstFilledSlot(bitmap);
        then_IndexIs(idx, 255);
        then_BitmapEmpty(next);
    }
    
    // === Input: Multiple Bits ===
    
    function test_Pop_MultipleBits_ReturnsLowest() public pure {
        uint8[] memory indices = new uint8[](3);
        indices[0] = 100;
        indices[1] = 50;  // Lowest
        indices[2] = 200;
        uint256 bitmap = given_MultipleBits(indices);
        (, uint8 idx) = when_PopFirstFilledSlot(bitmap);
        then_IndexIs(idx, 50);
    }
    
    function test_Pop_MultipleBits_ClearsOnlyLowest() public pure {
        uint8[] memory indices = new uint8[](2);
        indices[0] = 10;
        indices[1] = 20;
        uint256 bitmap = given_MultipleBits(indices);
        // vm.startSnapshotGas("PopFirstFilledSlot");
        (uint256 next,) = when_PopFirstFilledSlot(bitmap);
        // uint256 gas = vm.stopSnapshotGas(); gas = gas;
        then_SlotEmpty(next, 10);
        then_SlotOccupied(next, 20);
    }
    
    // === Input: Full Bitmap ===
    
    function test_Pop_FullBitmap_ReturnsIndex0() public pure {
        uint256 bitmap = given_FullBitmap();
        (, uint8 idx) = when_PopFirstFilledSlot(bitmap);
        then_IndexIs(idx, 0);
    }
    
    // === Revert Cases ===
    // NOTE: popFirstFilledSlot has a precondition: bitmap must be non-zero
    // Tested via external wrapper with explicit guard
    
    function test_Pop_EmptyBitmap_Reverts() public {
        uint256 bitmap = given_EmptyBitmap();
        then_RevertsWithNoFreeSlots();
        this.when_PopFirstFilledSlot_External(bitmap);
    }

    function test_Oracle_Pop_EmptyBitmap_Reverts() public {
        uint256 bitmap = given_EmptyBitmap();
        (bool success, bytes memory data) = when_Oracle_PopFirstFilledSlot_Fails(bitmap);
        then_RevertsWithNoFreeSlots_Call(success, data);
    }
    
    // === Sequential Pops ===
    
    function test_Pop_Sequential_OrderedIndices() public pure {
        uint8[] memory inputIndices = new uint8[](3);
        inputIndices[0] = 200;
        inputIndices[1] = 10;
        inputIndices[2] = 100;
        uint8[] memory expectedOrder = new uint8[](3);
        expectedOrder[0] = 10;
        expectedOrder[1] = 100;
        expectedOrder[2] = 200;
        uint256 bitmap = given_MultipleBits(inputIndices);
        (uint8[] memory poppedIndices, uint256 finalBitmap) = when_PopMultiple(bitmap, 3);
        then_PopSequenceIs(poppedIndices, expectedOrder);
        then_BitmapEmpty(finalBitmap);
    }
    
    function test_Pop_Transition_FillThenPopSequence() public pure {
        uint256 bitmap = given_EmptyBitmap();
        // Fill some slots
        bitmap = bitmap.fillSlotAt(5);
        bitmap = bitmap.fillSlotAt(10);
        bitmap = bitmap.fillSlotAt(3); // Will be popped first
        // Pop in order: 3, 5, 10
        (uint256 next1, uint8 idx1) = when_PopFirstFilledSlot(bitmap);
        then_IndexIs(idx1, 3);
        (uint256 next2, uint8 idx2) = when_PopFirstFilledSlot(next1);
        then_IndexIs(idx2, 5);
        (uint256 next3, uint8 idx3) = when_PopFirstFilledSlot(next2);
        then_IndexIs(idx3, 10);
        then_BitmapEmpty(next3);
    }
    
    // === Oracle Verification ===
    
    function test_Oracle_Pop_SingleBit_AllIndices() public pure {
        for (uint16 i = 0; i < 256; i++) {
            uint256 bitmap = given_SingleBit(_unsafeToUint8(i));
            (uint256 next, uint8 idx) = when_PopFirstFilledSlot(bitmap);
            then_MatchesOracle_PopFirstFilledSlot(bitmap, next, idx);
        }
    }
    
    function test_Oracle_Pop_Range() public pure {
        uint256 bitmap = given_Range(50, 150);
        (uint256 next, uint8 idx) = when_PopFirstFilledSlot(bitmap);
        then_MatchesOracle_PopFirstFilledSlot(bitmap, next, idx);
    }
    
    function testFuzz_Oracle_Pop(uint256 bitmap) public pure {
        vm.assume(bitmap != 0);
        (uint256 next, uint8 idx) = when_PopFirstFilledSlot(bitmap);
        then_MatchesOracle_PopFirstFilledSlot(bitmap, next, idx);
    }
}