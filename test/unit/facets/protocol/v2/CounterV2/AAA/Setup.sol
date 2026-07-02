// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CounterV2Adapter} from "support/adapters/CounterV2Adapter.sol";
import {CounterHarness} from "support/harnesses/CounterHarness.sol";
import {CounterV2Arrange} from "./Arrange.sol";
import {CounterV2Act} from "./Act.sol";
import {CounterV2Assert} from "./Assert.sol";

abstract contract CounterV2TestSetup is CounterV2Arrange, CounterV2Act, CounterV2Assert {

    function lc_create() internal virtual override {
        c = new CounterV2Adapter();
        target(address(c));
    }

    function lc_bind() internal virtual override {
        ch = CounterHarness(testTarget);
    }

}