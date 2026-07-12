// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {GasReportLogger} from "support/helpers/GasReportLogger.sol";
import {CounterV2} from "src/protocol/v2/CounterV2.sol";
import {CounterHarness} from "support/harnesses/CounterHarness.sol";

contract CounterV2GasTest is GasReportLogger, CounterHarness {

    CounterV2 internal CTR;
    address internal ctr;

    function setUp() public {
        CTR = new CounterV2();
        ctr = address(CTR);
        setWidths(12, 10, 10);
        vm.store(ctr, BASE_SLOT, bytes32(uint256(42)));
    }

    function test_00_00_header() public view {
        table("CounterV2");
    }

    function test_01_00_inc_first() public {
        CTR = new CounterV2();
        CTR.inc();  
        th("inc", "0 -> 1");
    }

    function test_01_00_inc_secondAndOnward() public {
        CTR.inc();  
        tr("inc", "n -> n+1");
        hr();
    }

    function test_02_00_dec_firstAndOnward() public {
        CTR.dec();  
        th("dec", "n -> n-1");
    }

    function test_02_01_dec_last() public {
        vm.store(ctr, BASE_SLOT, bytes32(uint256(1)));
        CTR.dec();  
        tr("dec", "1 -> 0");
    }

    function test_99_99_footer() public view {
        table();
    }
}

//   [Gas]    ╭─ CounterV2 ──╮
//   [Gas]    │              ├────────────┬────────────╮
//   [Gas]    │ inc          │ 1st        │ 22,524 gas │
//   [Gas]    │              │ 2nd+       │  5,424 gas │
//   [Gas]    ├──────────────┼────────────┼────────────┤
//   [Gas]    │ dec          │ 1st+       │  5,445 gas │
//   [Gas]    │              │ last       │    645 gas │
//   [Gas]    ╰──────────────┴────────────┴────────────╯