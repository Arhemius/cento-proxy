// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CounterV2} from "src/protocol/v2/CounterV2.sol";
import {CounterHarness} from "support/harnesses/CounterHarness.sol";

contract CounterV2Adapter is CounterHarness, CounterV2 {}