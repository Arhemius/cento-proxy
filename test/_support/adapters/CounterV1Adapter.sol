// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CounterV1} from "src/protocol/v1/CounterV1.sol";
import {CounterV1Harness} from "support/harnesses/CounterV1Harness.sol";

contract CounterV1Adapter is CounterV1Harness, CounterV1 {}