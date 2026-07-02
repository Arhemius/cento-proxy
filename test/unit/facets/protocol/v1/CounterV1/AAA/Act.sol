// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CounterV1Test} from "./Base.t.sol";

abstract contract CounterV1Act is CounterV1Test {

    function when_Inc() internal {
        c.inc();
    }
}