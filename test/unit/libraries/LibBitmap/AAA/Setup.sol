// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapAdapter} from "../../../../_support/adapters/LibBitmapAdapter.sol";
import {ReferenceBitmap} from "../../../../_support/oracles/ReferenceBitmap.sol";
import {IBitmap} from "../../../../_support/interfaces/IBitmap.sol";

/**
 * @title LibBitmap Test Setup
 * @notice Initializes implementation and reference contracts for testing
 */
contract LibBitmapTestSetup {
    IBitmap public implementation;
    IBitmap public oracle;

    constructor() {
        implementation = new LibBitmapAdapter();
        oracle = new ReferenceBitmap();
    }
}