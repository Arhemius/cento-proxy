// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibCentoArrange} from "./Arrange.sol";
import {LibCentoAssert} from "./Assert.sol";
import {LibCentoHarness} from "support/harnesses/LibCentoHarness.sol";

abstract contract LibCentoTM is LibCentoArrange, LibCentoAssert {

    address internal testTarget;

    function setUp() public virtual {
        lc_create();
        lc_bind();
        lc_setup();
    }

    // ---------------------------------------------------------------------
    // Phase 1: construct system under test
    // ---------------------------------------------------------------------

    function lc_create() internal virtual {}

    function target(address _target) internal {
        testTarget = _target;
    }

    // ---------------------------------------------------------------------
    // Phase 2: connect test harness to system
    // ---------------------------------------------------------------------

    function lc_bind() internal virtual {
        h = LibCentoHarness(testTarget);
    }

    // ---------------------------------------------------------------------
    // Phase 3: scenario initialization (use this in tests)
    // ---------------------------------------------------------------------

    function lc_setup() internal virtual {}
}