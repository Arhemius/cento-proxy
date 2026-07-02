// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CounterV1Adapter} from "support/adapters/CounterV1Adapter.sol";
import {CounterHarness} from "support/harnesses/CounterHarness.sol";
import {CounterV1Act} from "./Act.sol";
import {CounterV1Assert} from "./Assert.sol";

abstract contract CounterV1TestSetup is CounterV1Act, CounterV1Assert {

    function lc_create() internal virtual override {
        c = new CounterV1Adapter();
        target(address(c));
    }

    function lc_bind() internal virtual override {
        ch = CounterHarness(testTarget);
    }

}