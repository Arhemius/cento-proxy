// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapAssert} from "./AAA/Assert.sol";
import {LibBitmapTestSetup} from "./AAA/Setup.sol";
import "../../../_support/etl/_ETL.sol";

/**
 * @title ClearSlotAt Tests
 *
 * FUNCTION SPEC:
 * - Input: bitmap (uint256), index (uint8)
 * - Output: nextBitmap (uint256)
 * - Behavior: Clears bit at index
 * - Idempotent: Clearing already-empty slot is no-op
 */
contract ClearSlotAtTest is LibBitmapAssert, Ops {
    using T for bytes;
    constructor() LibBitmapAssert(new LibBitmapTestSetup()) {}
    
    function test_Clear_FullBitmap_ClearsBit() public view {
        uint256 bitmap = given_FullBitmap();
        uint256 next = when_ClearSlotAt(bitmap, 42);
        then_SlotEmpty(next, 42);
    }
    
    function test_Clear_Idempotent() public view {
        uint256 bitmap = given_EmptyBitmap();
        uint256 next = when_ClearSlotAt(bitmap, 42);
        then_BitmapIs(next, bitmap);
    }
    
    function test_Clear_PreservesOtherBits() public view {
        uint8[] memory indices = abi.encode(10, 20).u8();
        uint256 bitmap = given_MultipleBits(indices);
        uint256 next = when_ClearSlotAt(bitmap, 10);
        then_SlotEmpty(next, 10);
        then_SlotOccupied(next, 20);
    }
    
    function test_Clear_AllIndices() public view {
        uint256 bitmap = given_FullBitmap();
        for (uint16 i = 0; i < 256; i++) {
            bitmap = when_ClearSlotAt(bitmap, _unsafeToUint8(i));
        }
        then_BitmapEmpty(bitmap);
    }
    
    // === Boundary Tests ===
    
    function test_Clear_BoundaryIndices() public view {
        uint256 bitmap = given_FullBitmap();
        bitmap = when_ClearSlotAt(bitmap, 0);
        then_SlotEmpty(bitmap, 0);
        bitmap = when_ClearSlotAt(bitmap, 255);
        then_SlotEmpty(bitmap, 255);
        bitmap = when_ClearSlotAt(bitmap, 64);
        then_SlotEmpty(bitmap, 64);
        bitmap = when_ClearSlotAt(bitmap, 128);
        then_SlotEmpty(bitmap, 128);
        bitmap = when_ClearSlotAt(bitmap, 192);
        then_SlotEmpty(bitmap, 192);
    }
    
    // === Transition Tests ===
    
    function test_Clear_Sequential_ClearFillClear() public view {
        uint256 bitmap = given_FullBitmap();
        bitmap = when_ClearSlotAt(bitmap, 42);
        then_SlotEmpty(bitmap, 42);
        bitmap = when_FillSlotAt(bitmap, 42);
        then_SlotOccupied(bitmap, 42);
        bitmap = when_ClearSlotAt(bitmap, 42);
        then_SlotEmpty(bitmap, 42);
    }
    
    function test_Clear_Sequential_ClearsPreserveOrder() public view {
        uint256 bitmap = given_FullBitmap();
        uint8[] memory indices = abi.encode(10, 50, 100, 200, 255).u8();
        for (uint256 i = 0; i < indices.length; i++) {
            bitmap = when_ClearSlotAt(bitmap, indices[i]);
        }
        for (uint256 i = 0; i < indices.length; i++) {
            then_SlotEmpty(bitmap, indices[i]);
        }
    }

    // === Interface Compliance (Fuzz Tests) ===
    
    function testFuzz_Clear_Complies(uint256 bitmap, uint8 index) public view {
        then_CompliesWith_ClearSlotAt(bitmap, index);
    }
}