// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CounterV2} from "src/protocol/v2/CounterV2.sol";
import {$CounterV2} from "support/harnesses/CounterV2Harness.sol";
import {CounterV2Arrange} from "./Arrange.sol";
import {CounterV2Act} from "./Act.sol";
import {CounterV2Assert} from "./Assert.sol";

abstract contract CounterV2TestSetup is CounterV2Arrange, CounterV2Act, CounterV2Assert {

    function lc_create() internal override {
        c = new CounterV2();
        ch = $CounterV2.wrap(address(c));
    }

}