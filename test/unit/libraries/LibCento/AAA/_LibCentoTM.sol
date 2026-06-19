// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibCentoArrange} from "./Arrange.sol";
import {LibCentoAssert} from "./Assert.sol";
import {LibCentoHarness} from "support/harnesses/LibCentoHarness.sol";

abstract contract LibCentoTM is LibCentoArrange, LibCentoAssert {

    function setUp() public virtual {
        lc_OnSetup();
    }

    //rewrite this for better customization
    //use transient storage?
    function lc_OnSetup() internal virtual {
        address target = lc_createHarnessTarget();
        h = LibCentoHarness(target);
    }

    function lc_createHarnessTarget() internal virtual returns(address) {}
}