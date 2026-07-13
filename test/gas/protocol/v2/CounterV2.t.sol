// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {GasReportLogger} from "support/helpers/GasReportLogger.sol";
import {CounterV2} from "src/protocol/v2/CounterV2.sol";
import {$CounterV2} from "support/harnesses/CounterV2Harness.sol";

contract CounterV2GasTest is GasReportLogger {

    CounterV2 internal CTR;
    $CounterV2 internal _ctr;
    address internal ctr;

    CounterV2 internal REMCTR;
    $CounterV2 internal _remctr;
    address internal remctr;

    function setUp() public {
        CTR = new CounterV2();
        _ctr = $CounterV2.wrap(address(CTR));
        _ctr.setCount(42);

        REMCTR = new CounterV2();
        _remctr = $CounterV2.wrap(address(REMCTR));
        _remctr.setCount(1);

        setWidths(12, 10, 10);
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
        REMCTR.dec();  
        tr("dec", "1 -> 0");
    }

    function test_99_99_footer() public view {
        table();
    }
}

// ======= Test in Isolation mode for deletion to give proper cost =======
// === As you can see, alternative approach to layout makes storage operations cheaper (roughly by 266 gas) ===

//   [Gas]    ╭─ CounterV2 ──╮
//   [Gas]    │              ├────────────┬────────────╮
//   [Gas]    │ inc          │ 0 -> 1     │ 43,322 gas │
//   [Gas]    │              │ n -> n+1   │ 26,222 gas │
//   [Gas]    ├──────────────┼────────────┼────────────┤
//   [Gas]    │ dec          │ n -> n-1   │ 26,243 gas │
//   [Gas]    │              │ 1 -> 0     │ 21,443 gas │
//   [Gas]    ╰──────────────┴────────────┴────────────╯

// Previous metrics (no-isolation):
//   [Gas]    ╭─ CounterV2 ──╮
//   [Gas]    │              ├────────────┬────────────╮
//   [Gas]    │ inc          │ 1st        │ 22,524 gas │
//   [Gas]    │              │ 2nd+       │  5,424 gas │
//   [Gas]    ├──────────────┼────────────┼────────────┤
//   [Gas]    │ dec          │ 1st+       │  5,445 gas │
//   [Gas]    │              │ last       │    645 gas │
//   [Gas]    ╰──────────────┴────────────┴────────────╯

// New metrics (no-isolation measures deletion improperly)
//   [Gas]    ╭─ CounterV2 ──╮
//   [Gas]    │              ├────────────┬────────────╮
//   [Gas]    │ inc          │ 0 -> 1     │ 22,258 gas │
//   [Gas]    │              │ n -> n+1   │  5,158 gas │
//   [Gas]    ├──────────────┼────────────┼────────────┤
//   [Gas]    │ dec          │ n -> n-1   │  5,179 gas │
//   [Gas]    │              │ 1 -> 0     │  5,179 gas │
//   [Gas]    ╰──────────────┴────────────┴────────────╯

// New layout gas improvement: 22,524 - 22,258 = 266 gas