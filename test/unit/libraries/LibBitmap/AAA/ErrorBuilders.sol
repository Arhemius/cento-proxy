// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapTest} from "./Base.t.sol";

abstract contract ErrorBuilders is LibBitmapTest {

    function NoFreeSlots() internal pure returns (Error memory) {
        return Error({
            selector: ERR_NO_FREE_SLOTS,
            data: ""
        });
    }
}