// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { LibBitmap } from "../libraries/LibBitmap.sol";

/// @title bitmap256
/// @notice User-defined value type representing a 256-bit occupancy bitmap.
/// @dev Used throughout Cento to efficiently manage fixed-capacity slot allocation.
type bitmap256 is uint256;

using { LibBitmap.popFirstFilledSlot,
        LibBitmap.getFirstEmptySlot,
        LibBitmap.countFilledSlots,
        LibBitmap.isSlotOccupied,
        LibBitmap.fillSlotAt,
        LibBitmap.clearSlotAt               } for bitmap256 global;