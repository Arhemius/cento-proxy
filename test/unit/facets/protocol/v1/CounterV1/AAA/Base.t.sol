// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {CounterV1Adapter} from "support/adapters/CounterV1Adapter.sol";
import {CounterV1Harness} from "support/harnesses/CounterV1Harness.sol";
import {LibCentoTM} from "test/unit/libraries/cento/LibCento/AAA/_LibCentoTM.sol";

abstract contract CounterV1Test is Test, LibCentoTM {

    CounterV1Adapter internal c;
    CounterV1Harness internal ch;

}