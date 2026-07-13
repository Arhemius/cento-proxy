// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {CounterV2} from "src/protocol/v2/CounterV2.sol";
import {$CounterV2} from "support/harnesses/CounterV2Harness.sol";
import {LibCentoTM} from "test/unit/libraries/cento/LibCento/AAA/_LibCentoTM.sol";

abstract contract CounterV2Test is Test, LibCentoTM {

    CounterV2  internal c;
    $CounterV2 internal ch;

}