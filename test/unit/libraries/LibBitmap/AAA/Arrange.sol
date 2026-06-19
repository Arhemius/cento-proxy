// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapTest} from "./Base.t.sol";
import {bitmap256, u, w} from "src/libraries/LibBitmap.sol";

/**
 * @title LibBitmap Arrange Layer
 * @notice GIVEN clauses - pure bitmap state preparation
 */
abstract contract LibBitmapArrange is LibBitmapTest {
    // === Bitmap Builders ===

    function given_EmptyBitmap() internal view returns (bitmap256) {
        return EMPTY_BITMAP;
    }

    function given_FullBitmap() internal view returns (bitmap256) {
        return FULL_BITMAP;
    }

    function given_SingleBit(uint8 index) internal pure returns (bitmap256) {
        return w(uint256(1) << index);
    }

    function given_MultipleBits(uint8[] memory indices) internal pure returns (bitmap256 bitmap) {
        uint256 _bitmap;
        for (uint256 i = 0; i < indices.length; i++) {
            _bitmap |= (uint256(1) << indices[i]);
        }
        bitmap = w(_bitmap);
    }

    function given_Range(uint8 start, uint8 end) internal pure returns (bitmap256 bitmap) {
        assertLt(start, end, "Start index must be less than end index");
        uint256 _bitmap;
        for (uint16 i = start; i <= end; i++) {
            _bitmap |= (uint256(1) << i);
        }
        bitmap = w(_bitmap);
    }

    function given_AllExcept(uint8 excludedIndex) internal view returns (bitmap256) {
        return w(u(FULL_BITMAP) & ~(uint256(1) << excludedIndex));
    }
}