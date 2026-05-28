// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapAdapter} from "support/adapters/LibBitmapAdapter.sol";
import {ReferenceBitmap} from "support/oracles/ReferenceBitmap.sol";
import {IBitmap} from "support/interfaces/IBitmap.sol";

/**
 * @title LibBitmap Test Setup
 * @notice Initializes implementation and reference contracts for testing
 */
contract LibBitmapTestSetup {
    IBitmap internal immutable implementation;
    IBitmap internal immutable oracle;

    constructor() {
        implementation = new LibBitmapAdapter();
        oracle = new ReferenceBitmap();
    }
}