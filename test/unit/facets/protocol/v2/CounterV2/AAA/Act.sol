// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CounterV2Test} from "./Base.t.sol";

abstract contract CounterV2Act is CounterV2Test {

    function when_Inc() internal {
        c.inc();
    }

    function when_Dec(uint8 config) internal {
        if (Errors(config)) {
            Execute(address(c), abi.encodeWithSelector(c.dec.selector));
        } else {
            c.dec();
        }
    }
}