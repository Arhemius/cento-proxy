// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapTest} from "./Base.t.sol";
import {ReferenceBitmap} from "../../../../_support/oracles/ReferenceBitmap.sol";

/**
 * @title LibBitmap Arrange Layer
 * @notice GIVEN clauses - state setup
 */
abstract contract LibBitmapArrange is LibBitmapTest {
    using ReferenceBitmap for ReferenceBitmap.Bitmap;
    
    // === Bitmap Builders ===
    
    function given_EmptyBitmap() internal pure returns (uint256) {
        return EMPTY;
    }
    
    function given_FullBitmap() internal pure returns (uint256) {
        return FULL;
    }
    
    function given_SingleBit(uint8 index) internal pure returns (uint256) {
        return uint256(1) << index;
    }
    
    function given_MultipleBits(uint8[] memory indices) internal pure returns (uint256 bitmap) {
        for (uint256 i = 0; i < indices.length; i++) {
            bitmap |= (uint256(1) << indices[i]);
        }
    }
    
    function given_Range(uint8 start, uint8 end) internal pure returns (uint256 bitmap) {
        assertLt(start, end, "Start index must be less than end index");
        for (uint16 i = start; i <= end; i++) {
            bitmap |= (uint256(1) << i);
        }
    }
    
    function given_AllExcept(uint8 excludedIndex) internal pure returns (uint256) {
        return FULL & ~(uint256(1) << excludedIndex);
    }
    
    // === Reference Oracle Setup ===
    
    function given_ReferenceBitmap(uint256 bitmap) internal pure returns (ReferenceBitmap.Bitmap memory) {
        return ReferenceBitmap.fromUint256(bitmap);
    }
}