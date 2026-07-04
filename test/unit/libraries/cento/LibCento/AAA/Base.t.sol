// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibCentoAdapter} from "support/adapters/LibCentoAdapter.sol";
import {LibCentoHarness} from "support/harnesses/LibCentoHarness.sol";
import {LibBitmapTM} from "../../LibBitmap/AAA/_LibBitmapTM.sol";

abstract contract LibCentoTest is LibBitmapTM {

    LibCentoAdapter internal lc;
    LibCentoHarness internal h;

    // ===== Helper functions =====

    function toBytes32Array(uint8[] memory _arr) internal pure returns (bytes32[] memory arr) {
        assembly { arr := _arr }
    }

}