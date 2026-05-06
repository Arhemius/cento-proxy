// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapAssert} from "./AAA/Assert.sol";
import {LibBitmapTestSetup} from "./AAA/Setup.sol";
import "../../../_support/etl/_ETL.sol";

/**
 * @title FillSlotAt Tests
 *
 * FUNCTION SPEC:
 * - Input: bitmap (uint256), index (uint8)
 * - Output: nextBitmap (uint256)
 * - Behavior: Sets bit at index
 * - Idempotent: Filling already-filled slot is no-op
 */
contract FillSlotAtTest is LibBitmapAssert, Ops {
    using T for bytes;
    constructor() LibBitmapAssert(new LibBitmapTestSetup()) {}

    function test_Fill_EmptyBitmap_SetsBit() public view {
        uint256 bitmap = given_EmptyBitmap();
        uint256 next = when_FillSlotAt(bitmap, 42);
        then_SlotOccupied(next, 42);
    }

    function test_Fill_Idempotent() public view {
        uint256 bitmap = given_SingleBit(42);
        uint256 next = when_FillSlotAt(bitmap, 42);
        then_BitmapIs(next, bitmap);
    }

    function test_Fill_PreservesOtherBits() public view {
        uint256 bitmap = given_SingleBit(10);
        uint256 next = when_FillSlotAt(bitmap, 20);
        then_SlotOccupied(next, 10);
        then_SlotOccupied(next, 20);
    }

    function test_Fill_AllIndices() public view {
        uint256 bitmap = given_EmptyBitmap();
        for (uint16 i = 0; i < 256; i++) {
            bitmap = when_FillSlotAt(bitmap, _unsafeToUint8(i));
        }
        then_BitmapFull(bitmap);
    }

    // === Boundary Tests ===

    function test_Fill_BoundaryIndices() public view {
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

    function test_Fill_Sequential_FillClearFill() public view {
        uint256 bitmap = given_EmptyBitmap();
        bitmap = when_FillSlotAt(bitmap, 42);
        then_SlotOccupied(bitmap, 42);
        bitmap = when_ClearSlotAt(bitmap, 42);
        then_SlotEmpty(bitmap, 42);
        bitmap = when_FillSlotAt(bitmap, 42);
        then_SlotOccupied(bitmap, 42);
    }

    function test_Fill_Sequential_FillsPreserveOrder() public view {
        uint256 bitmap = given_EmptyBitmap();
        uint8[] memory indices = abi.encode(10, 50, 100, 200, 255).u8();
        for (uint256 i = 0; i < indices.length; i++) {
            bitmap = when_FillSlotAt(bitmap, indices[i]);
        }
        for (uint256 i = 0; i < indices.length; i++) {
            then_SlotOccupied(bitmap, indices[i]);
        }
    }

    // === Interface Compliance (Fuzz Tests) ===

    function testFuzz_Fill_Complies(uint256 bitmap, uint8 index) public view {
        then_CompliesWith_FillSlotAt(bitmap, index);
    }
}