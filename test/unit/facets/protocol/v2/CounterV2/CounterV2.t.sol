// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CounterV2TestSetup} from "./AAA/Setup.sol";

contract CounterV2Test is CounterV2TestSetup {

    function test_Inc_IncreasesCount() public {
        uint256 initialCount = ch.getCount();
        when_Inc();
        then_StorageCountIs(initialCount + 1);
    }
        
    function test_Dec_DecreasesCount() public {
        arrange_StorageCount(1);
        uint256 initialCount = ch.getCount();
        when_Dec(__);
        then_StorageCountIs(initialCount - 1);
    }

    function test_Dec_Panics() public {
        arrange_StorageCount(0);
        when_Dec(errors);
        then_MatchesError($Panic(0x11));
    }

}