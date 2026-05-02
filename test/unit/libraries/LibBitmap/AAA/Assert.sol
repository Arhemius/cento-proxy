// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapAct} from "./Act.sol";
import {LibBitmap} from "../../../../../src/libraries/LibBitmap.sol";
import {ReferenceBitmap} from "../../../../_support/oracles/ReferenceBitmap.sol";

/**
 * @title LibBitmap Assert Layer
 * @notice THEN clauses - verification
 */
abstract contract LibBitmapAssert is LibBitmapAct {
    using LibBitmap for uint256;
    using ReferenceBitmap for ReferenceBitmap.Bitmap;
    
    // === Output Verification ===
    
    function then_IndexIs(uint8 actual, uint8 expected) internal pure {
        assertEq(actual, expected, "Index mismatch");
    }
    
    function then_BitmapIs(uint256 actual, uint256 expected) internal pure {
        assertEq(actual, expected, "Bitmap mismatch");
    }
    
    function then_BitmapMatchesReference(uint256 actualBitmap, ReferenceBitmap.Bitmap memory expected) internal pure {
        for (uint16 i = 0; i < 256; i++) {
            bool actualSlot = ((actualBitmap >> i) & 1) != 0;
            assertEq(actualSlot, expected.slots[i], "Oracle: bitmap mismatch");
        }
    }
    
    function then_CountIs(uint16 actual, uint16 expected) internal pure {
        assertEq(actual, expected, "Count mismatch");
    }
    
    function then_IsOccupied(bool actual, bool expected) internal pure {
        assertEq(actual, expected, "Occupancy mismatch");
    }
    
    // === State Verification ===
    
    function then_SlotOccupied(uint256 bitmap, uint8 index) internal pure {
        assertTrue(bitmap.isSlotOccupied(index), "Slot should be occupied");
    }
    
    function then_SlotEmpty(uint256 bitmap, uint8 index) internal pure {
        assertFalse(bitmap.isSlotOccupied(index), "Slot should be empty");
    }
    
    function then_BitmapEmpty(uint256 bitmap) internal pure {
        assertEq(bitmap, EMPTY, "Bitmap should be empty");
    }
    
    function then_BitmapFull(uint256 bitmap) internal pure {
        assertEq(bitmap, FULL, "Bitmap should be full");
    }
    
    // === Error Verification ===
    
    function then_RevertsWithNoFreeSlots() internal {
        vm.expectRevert(LibBitmap.NoFreeSlots.selector);
    }
    
    // === Oracle Verification ===
    
    function then_MatchesOracle_PopFirstFilledSlot(uint256 bitmap, uint256 actualNextBitmap, uint8 actualIndex) internal pure {
        ReferenceBitmap.Bitmap memory ref = given_ReferenceBitmap(bitmap);
        (ReferenceBitmap.Bitmap memory refNext, uint8 refIndex) = ref.popFirstFilledSlot();
        assertEq(actualIndex, refIndex, "Oracle: index mismatch");
        then_BitmapMatchesReference(actualNextBitmap, refNext);
    }
    
    function then_MatchesOracle_GetFirstEmptySlot(uint256 bitmap, uint8 actualIndex) internal pure {
        ReferenceBitmap.Bitmap memory ref = given_ReferenceBitmap(bitmap);
        uint8 refIndex = ref.getFirstEmptySlot();
        assertEq(actualIndex, refIndex, "Oracle: index mismatch");
    }
    
    function then_MatchesOracle_CountFilledSlots(uint256 bitmap, uint16 actualCount) internal pure {
        ReferenceBitmap.Bitmap memory ref = given_ReferenceBitmap(bitmap);
        uint16 refCount = ref.countFilledSlots();
        assertEq(actualCount, refCount, "Oracle: count mismatch");
    }
    
    function then_MatchesOracle_IsSlotOccupied(uint256 bitmap, uint8 index, bool actualOccupied) internal pure {
        ReferenceBitmap.Bitmap memory ref = given_ReferenceBitmap(bitmap);
        bool refOccupied = ref.isSlotOccupied(index);
        assertEq(actualOccupied, refOccupied, "Oracle: occupancy mismatch");
    }
    
    function then_MatchesOracle_FillSlotAt(uint256 bitmap, uint8 index, uint256 actualNextBitmap) internal pure {
        ReferenceBitmap.Bitmap memory ref = given_ReferenceBitmap(bitmap);
        ReferenceBitmap.Bitmap memory refNext = ref.fillSlotAt(index);
        then_BitmapMatchesReference(actualNextBitmap, refNext);
    }
    
    function then_MatchesOracle_ClearSlotAt(uint256 bitmap, uint8 index, uint256 actualNextBitmap) internal pure {
        ReferenceBitmap.Bitmap memory ref = given_ReferenceBitmap(bitmap);
        ReferenceBitmap.Bitmap memory refNext = ref.clearSlotAt(index);
        then_BitmapMatchesReference(actualNextBitmap, refNext);
    }
} 