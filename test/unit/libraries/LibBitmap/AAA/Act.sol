// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapTest} from "./Base.t.sol";
import {bitmap256} from "src/libraries/LibBitmap.sol";

/**
 * @title LibBitmap Act Layer
 * @notice WHEN clauses - function execution via interfaces
 */
abstract contract LibBitmapAct is LibBitmapTest {
    // === Core Functionality ===

    function when_PopFirstFilledSlot(bitmap256 bitmap) internal view returns (bitmap256 nextBitmap, uint8 index) {
        return implementation.popFirstFilledSlot(bitmap);
    }

    function when_GetFirstEmptySlot(bitmap256 bitmap) internal view returns (uint8 index) {
        return implementation.getFirstEmptySlot(bitmap);
    }

    function when_CountFilledSlots(bitmap256 bitmap) internal view returns (uint16 count) {
        return implementation.countFilledSlots(bitmap);
    }

    function when_IsSlotOccupied(bitmap256 bitmap, uint8 index) internal view returns (bool occupied) {
        return implementation.isSlotOccupied(bitmap, index);
    }

    function when_FillSlotAt(bitmap256 bitmap, uint8 index) internal view returns (bitmap256 nextBitmap) {
        return implementation.fillSlotAt(bitmap, index);
    }

    function when_ClearSlotAt(bitmap256 bitmap, uint8 index) internal view returns (bitmap256 nextBitmap) {
        return implementation.clearSlotAt(bitmap, index);
    }

    // === Multiple Invocations ===

    function when_PopMultiple(bitmap256 bitmap, uint16 count) internal view returns (uint8[] memory indices, bitmap256 finalBitmap) {
        indices = new uint8[](count);
        finalBitmap = bitmap;
        for (uint16 i = 0; i < count; i++) {
            (bitmap256 nextBitmap, uint8 index) = implementation.popFirstFilledSlot(finalBitmap);
            indices[i] = index;
            finalBitmap = nextBitmap;
        }
    }
}