// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapArrange} from "./Arrange.sol";
import {LibBitmap} from "../../../../../src/libraries/LibBitmap.sol";

/**
 * @title LibBitmap Act Layer
 * @notice WHEN clauses - function execution
 */
abstract contract LibBitmapAct is LibBitmapArrange {
    using LibBitmap for uint256;
    
    // === Actions ===
    
    function when_PopFirstFilledSlot(uint256 bitmap) internal pure returns (uint256 nextBitmap, uint8 index) {
        return bitmap.popFirstFilledSlot();
    }
    
    function when_PopFirstFilledSlot_External(uint256 bitmap) external pure returns (uint256 nextBitmap, uint8 index) {
        if (bitmap == 0) revert LibBitmap.NoFreeSlots();
        return bitmap.popFirstFilledSlot();
    }
    
    function when_GetFirstEmptySlot(uint256 bitmap) internal pure returns (uint8 index) {
        return bitmap.getFirstEmptySlot();
    }

    function when_GetFirstEmptySlot_External(uint256 bitmap) external pure returns (uint8 index) {
        return bitmap.getFirstEmptySlot();
    }
    
    function when_CountFilledSlots(uint256 bitmap) internal pure returns (uint16 count) {
        return bitmap.countFilledSlots();
    }
    
    function when_IsSlotOccupied(uint256 bitmap, uint8 index) internal pure returns (bool occupied) {
        return bitmap.isSlotOccupied(index);
    }
    
    function when_FillSlotAt(uint256 bitmap, uint8 index) internal pure returns (uint256 nextBitmap) {
        return bitmap.fillSlotAt(index);
    }
    
    function when_ClearSlotAt(uint256 bitmap, uint8 index) internal pure returns (uint256 nextBitmap) {
        return bitmap.clearSlotAt(index);
    }
}