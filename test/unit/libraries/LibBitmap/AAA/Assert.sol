// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapAct} from "./Act.sol";
import {LibBitmapTest} from "./Base.t.sol";
import {LibBitmapTestSetup} from "./Setup.sol";

/**
 * @title LibBitmap Assert Layer
 * @notice THEN clauses - interface compliance verification
 */
abstract contract LibBitmapAssert is LibBitmapAct {
    constructor(LibBitmapTestSetup setup) LibBitmapTest(setup.implementation(), setup.oracle()) {}
    // === Output Verification ===

    function then_IndexIs(uint8 actual, uint8 expected) internal pure {
        assertEq(actual, expected, "Index mismatch");
    }

    function then_BitmapIs(uint256 actual, uint256 expected) internal pure {
        assertEq(actual, expected, "Bitmap mismatch");
    }

    function then_PopSequenceIs(uint8[] memory actual, uint8[] memory expected) internal pure {
        assertEq(actual.length, expected.length, "Pop sequence length mismatch");
        for (uint256 i = 0; i < expected.length; i++) {
            assertEq(
                actual[i],
                expected[i],
                string.concat("Pop sequence mismatch at position ", vm.toString(i))
            );
        }
    }

    function then_CountIs(uint16 actual, uint16 expected) internal pure {
        assertEq(actual, expected, "Count mismatch");
    }

    function then_IsOccupied(bool actual, bool expected) internal pure {
        assertEq(actual, expected, "Occupancy mismatch");
    }

    // === State Verification ===

    function then_SlotOccupied(uint256 bitmap, uint8 index) internal view {
        assertTrue(implementation.isSlotOccupied(bitmap, index), "Slot should be occupied");
    }

    function then_SlotEmpty(uint256 bitmap, uint8 index) internal view {
        assertFalse(implementation.isSlotOccupied(bitmap, index), "Slot should be empty");
    }

    function then_BitmapEmpty(uint256 bitmap) internal pure {
        assertEq(bitmap, EMPTY, "Bitmap should be empty");
    }

    function then_BitmapFull(uint256 bitmap) internal pure {
        assertEq(bitmap, FULL, "Bitmap should be full");
    }

    // === Error Compliance (verify both implementations throw same error) ===

    function then_CompliesWith_Error(bytes4 selector, uint256 bitmap) internal {
        (bool implSuccess, bytes memory implData) = address(implementation).call(abi.encodeWithSelector(selector, bitmap));
        (bool refSuccess, bytes memory refData) = address(oracle).call(abi.encodeWithSelector(selector, bitmap));
        assertFalse(implSuccess, "Implementation should revert");
        assertFalse(refSuccess, "Oracle should revert");
        assertGe(implData.length, 4, "Implementation error data too short");
        assertGe(refData.length, 4, "Oracle error data too short");
        bytes4 implSelector = _unsafeToSelector(implData);
        bytes4 refSelector = _unsafeToSelector(refData);
        assertEq(implSelector, refSelector, "Error selectors must match");
    }

    // === Interface Compliance Verification ===

    function then_CompliesWith_PopFirstFilledSlot(uint256 bitmap) internal view {
        (uint256 implNext, uint8 implIdx) = implementation.popFirstFilledSlot(bitmap);
        (uint256 refNext, uint8 refIdx) = oracle.popFirstFilledSlot(bitmap);
        assertEq(implIdx, refIdx, "Interface compliance: index mismatch");
        assertEq(implNext, refNext, "Interface compliance: bitmap mismatch");
    }

    function then_CompliesWith_GetFirstEmptySlot(uint256 bitmap) internal view {
        uint8 implIdx = implementation.getFirstEmptySlot(bitmap);
        uint8 refIdx = oracle.getFirstEmptySlot(bitmap);
        assertEq(implIdx, refIdx, "Interface compliance: index mismatch");
    }

    function then_CompliesWith_CountFilledSlots(uint256 bitmap) internal view {
        uint16 implCount = implementation.countFilledSlots(bitmap);
        uint16 refCount = oracle.countFilledSlots(bitmap);
        assertEq(implCount, refCount, "Interface compliance: count mismatch");
    }

    function then_CompliesWith_IsSlotOccupied(uint256 bitmap, uint8 index) internal view {
        bool implOccupied = implementation.isSlotOccupied(bitmap, index);
        bool refOccupied = oracle.isSlotOccupied(bitmap, index);
        assertEq(implOccupied, refOccupied, "Interface compliance: occupancy mismatch");
    }

    function then_CompliesWith_FillSlotAt(uint256 bitmap, uint8 index) internal view {
        uint256 implNext = implementation.fillSlotAt(bitmap, index);
        uint256 refNext = oracle.fillSlotAt(bitmap, index);
        assertEq(implNext, refNext, "Interface compliance: bitmap mismatch");
    }

    function then_CompliesWith_ClearSlotAt(uint256 bitmap, uint8 index) internal view {
        uint256 implNext = implementation.clearSlotAt(bitmap, index);
        uint256 refNext = oracle.clearSlotAt(bitmap, index);
        assertEq(implNext, refNext, "Interface compliance: bitmap mismatch");
    }
}