// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {V2TestSetup} from "./setup/SetupV2.sol";

// just a test example
contract CounterV2LifecycleTest is V2TestSetup {

    function test_Counter_IncreasesAndDecreases() public {
        CentoProxy.inc();
        CentoProxy.dec();
    }

}