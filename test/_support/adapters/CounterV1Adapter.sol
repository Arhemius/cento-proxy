// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CounterV1} from "src/protocol/v1/CounterV1.sol";
import {CounterHarness} from "support/harnesses/CounterHarness.sol";

contract CounterV1Adapter is CounterHarness, CounterV1 {}