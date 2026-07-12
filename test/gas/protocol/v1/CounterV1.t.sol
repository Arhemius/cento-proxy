// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {GasReportLogger} from "support/helpers/GasReportLogger.sol";
import {CounterV1} from "src/protocol/v1/CounterV1.sol";
import {CounterHarness} from "support/harnesses/CounterHarness.sol";

contract CounterV1GasTest is GasReportLogger, CounterHarness {

    CounterV1 internal CTR;
    address internal ctr;

    function setUp() public {
        CTR = new CounterV1();
        ctr = address(CTR);
        setWidths(12, 10, 10);
        vm.store(ctr, BASE_SLOT, bytes32(uint256(1)));
    }

    function test_00_00_header() public view {
        table("CounterV1");
    }

    function test_01_00_inc_first() public {
        CTR = new CounterV1();
        CTR.inc();  
        th("inc", "0 -> 1");
    }

    function test_01_00_inc_secondAndOnward() public {
        CTR.inc();  
        tr("inc", "n -> n+1");
    }

    function test_99_99_footer() public view {
        table();
    }
}

//   [Gas]    ╭─ CounterV1 ──╮
//   [Gas]    │              ├────────────┬────────────╮
//   [Gas]    │ inc          │ 1st        │ 22,491 gas │
//   [Gas]    │              │ 2nd+       │  5,591 gas │
//   [Gas]    ╰──────────────┴────────────┴────────────╯