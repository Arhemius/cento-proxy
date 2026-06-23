// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapTest} from "./Base.t.sol";
import {bitmap256, u} from "src/libraries/LibBitmap.sol";

abstract contract LibBitmapCompliance is LibBitmapTest {

    // === Error Compliance (verify both implementations throw same error) ===

    function then_CompliesWith_Error(bytes4 selector, bitmap256 bitmap) internal {
        assertEqCall(
            address(implementation), abi.encodeWithSelector(selector, bitmap),
            address(oracle), abi.encodeWithSelector(selector, bitmap)
        );
    }

    // === Interface Compliance Verification ===

    function then_CompliesWith_PopFirstFilledSlot(bitmap256 bitmap) internal view {
        (bitmap256 implNext, uint8 implIdx) = implementation.popFirstFilledSlot(bitmap);
        (bitmap256 refNext, uint8 refIdx) = oracle.popFirstFilledSlot(bitmap);
        assertEq(implIdx, refIdx, "Interface compliance: index mismatch");
        assertEq(u(implNext), u(refNext), "Interface compliance: bitmap mismatch");
    }

    function then_CompliesWith_GetFirstEmptySlot(bitmap256 bitmap) internal view {
        uint8 implIdx = implementation.getFirstEmptySlot(bitmap);
        uint8 refIdx = oracle.getFirstEmptySlot(bitmap);
        assertEq(implIdx, refIdx, "Interface compliance: index mismatch");
    }

    function then_CompliesWith_CountFilledSlots(bitmap256 bitmap) internal view {
        uint16 implCount = implementation.countFilledSlots(bitmap);
        uint16 refCount = oracle.countFilledSlots(bitmap);
        assertEq(implCount, refCount, "Interface compliance: count mismatch");
    }

    function then_CompliesWith_IsSlotOccupied(bitmap256 bitmap, uint8 index) internal view {
        bool implOccupied = implementation.isSlotOccupied(bitmap, index);
        bool refOccupied = oracle.isSlotOccupied(bitmap, index);
        assertEq(implOccupied, refOccupied, "Interface compliance: occupancy mismatch");
    }

    function then_CompliesWith_FillSlotAt(bitmap256 bitmap, uint8 index) internal view {
        bitmap256 implNext = implementation.fillSlotAt(bitmap, index);
        bitmap256 refNext = oracle.fillSlotAt(bitmap, index);
        assertEq(u(implNext), u(refNext), "Interface compliance: bitmap mismatch");
    }

    function then_CompliesWith_ClearSlotAt(bitmap256 bitmap, uint8 index) internal view {
        bitmap256 implNext = implementation.clearSlotAt(bitmap, index);
        bitmap256 refNext = oracle.clearSlotAt(bitmap, index);
        assertEq(u(implNext), u(refNext), "Interface compliance: bitmap mismatch");
    }

}