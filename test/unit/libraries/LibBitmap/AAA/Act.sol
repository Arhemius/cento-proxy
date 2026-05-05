// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapArrange} from "./Arrange.sol";

/**
 * @title LibBitmap Act Layer
 * @notice WHEN clauses - function execution via interfaces
 */
abstract contract LibBitmapAct is LibBitmapArrange {
    // === Core Functionality ===

    function when_PopFirstFilledSlot(uint256 bitmap) internal view returns (uint256 nextBitmap, uint8 index) {
        return implementation.popFirstFilledSlot(bitmap);
    }

    function when_GetFirstEmptySlot(uint256 bitmap) internal view returns (uint8 index) {
        return implementation.getFirstEmptySlot(bitmap);
    }

    function when_CountFilledSlots(uint256 bitmap) internal view returns (uint16 count) {
        return implementation.countFilledSlots(bitmap);
    }

    function when_IsSlotOccupied(uint256 bitmap, uint8 index) internal view returns (bool occupied) {
        return implementation.isSlotOccupied(bitmap, index);
    }

    function when_FillSlotAt(uint256 bitmap, uint8 index) internal view returns (uint256 nextBitmap) {
        return implementation.fillSlotAt(bitmap, index);
    }

    function when_ClearSlotAt(uint256 bitmap, uint8 index) internal view returns (uint256 nextBitmap) {
        return implementation.clearSlotAt(bitmap, index);
    }

    // === Multiple Invocations ===

    function when_PopMultiple(uint256 bitmap, uint16 count) internal view returns (uint8[] memory indices, uint256 finalBitmap) {
        indices = new uint8[](count);
        finalBitmap = bitmap;
        for (uint16 i = 0; i < count; i++) {
            (uint256 nextBitmap, uint8 index) = implementation.popFirstFilledSlot(finalBitmap);
            indices[i] = index;
            finalBitmap = nextBitmap;
        }
    }
}