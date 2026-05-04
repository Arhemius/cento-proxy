// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapArrange} from "./Arrange.sol";
import {LibBitmap} from "../../../../../src/libraries/LibBitmap.sol";
import {ReferenceBitmap as RB} from "../../../../_support/oracles/ReferenceBitmap.sol";

/**
 * @title LibBitmap Act Layer
 * @notice WHEN clauses - function execution
 */
abstract contract LibBitmapAct is LibBitmapArrange {
    using LibBitmap for uint256;
    using RB for RB.Bitmap;
    
    // === Actions ===
    
    function when_PopFirstFilledSlot(uint256 bitmap) internal pure returns (uint256 nextBitmap, uint8 index) {
        return bitmap.popFirstFilledSlot();
    }
    
    function when_PopFirstFilledSlot_External(uint256 bitmap) external pure returns (uint256 nextBitmap, uint8 index) {
        return bitmap.popFirstFilledSlot();
    }

    function when_Oracle_PopFirstFilledSlot_External(uint256 bitmap) 
        external pure returns (RB.Bitmap memory self, uint8 index) {
        RB.Bitmap memory ref = given_ReferenceBitmap(bitmap);
        return ref.popFirstFilledSlot();
    }

    function when_Oracle_PopFirstFilledSlot_Fails(uint256 bitmap) internal returns (bool success, bytes memory data) {
        return address(this).call(
            abi.encodeWithSelector(
                this.when_Oracle_PopFirstFilledSlot_External.selector,
                bitmap
            )
        );
    }

    function when_PopMultiple(uint256 bitmap, uint16 count) internal pure returns (uint8[] memory indices, uint256 finalBitmap) {
        indices = new uint8[](count);
        finalBitmap = bitmap;
        for (uint16 i = 0; i < count; i++) {
            (uint256 nextBitmap, uint8 index) = finalBitmap.popFirstFilledSlot();
            indices[i] = index;
            finalBitmap = nextBitmap;
        }
    }
    
    function when_GetFirstEmptySlot(uint256 bitmap) internal pure returns (uint8 index) {
        return bitmap.getFirstEmptySlot();
    }

    function when_GetFirstEmptySlot_External(uint256 bitmap) external pure returns (uint8 index) {
        return bitmap.getFirstEmptySlot();
    }

    function when_Oracle_GetFirstEmptySlot_External(uint256 bitmap) 
        external pure returns (uint8 index) {
        RB.Bitmap memory ref = given_ReferenceBitmap(bitmap);
        return ref.getFirstEmptySlot();
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