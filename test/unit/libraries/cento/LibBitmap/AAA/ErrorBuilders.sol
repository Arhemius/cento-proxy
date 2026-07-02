// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {IBitmap} from "support/interfaces/IBitmap.sol";
import {ErrorContext} from "support/helpers/errors/ErrorContext.sol";

abstract contract ErrorBuilders is ErrorContext {

    bytes4 constant ERR_NO_FREE_SLOTS = IBitmap.NoFreeSlots.selector;

    function NoFreeSlots() internal pure returns (Error memory) {
        return Error({
            selector: ERR_NO_FREE_SLOTS,
            data: ""
        });
    }
}