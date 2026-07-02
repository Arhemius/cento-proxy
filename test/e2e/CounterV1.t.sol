// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {V1TestSetup} from "./setup/SetupV1.sol";

// just a test example
contract CounterV1LifecycleTest is V1TestSetup {

    function test_Counter_Increases() public {
        CentoProxy.inc();
    }
}