// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CounterV1Adapter} from "support/adapters/CounterV1Adapter.sol";
import {CounterV1Harness} from "support/harnesses/CounterV1Harness.sol";
import {CounterV1Act} from "./Act.sol";
import {CounterV1Assert} from "./Assert.sol";

abstract contract CounterV1TestSetup is CounterV1Act, CounterV1Assert {

    function setUp() public {
        c = new CounterV1Adapter();
        ch = CounterV1Harness(address(c));
    }

}