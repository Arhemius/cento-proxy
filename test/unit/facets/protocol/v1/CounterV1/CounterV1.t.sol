// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CounterV1TestSetup} from "./AAA/Setup.sol";

contract CounterV1Test is CounterV1TestSetup {

    function test_Inc() public {
        uint256 initialCount = ch.getCount();
        when_Inc();
        then_StorageCountIs(initialCount + 1);
    }

}

