// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {ErrorContext} from "./ErrorContext.sol";

abstract contract $Execute is Test, ErrorContext {

    // ---------------------------------------------------------------------
    // Record configuration
    // ---------------------------------------------------------------------

    uint8 internal constant __   = 0;
    uint8 internal constant events = 1 << 0;
    uint8 internal constant errors = 1 << 1;
    // uint8 internal constant gas = 1 << 2;

    // ---------------------------------------------------------------------
    // Configuration helpers
    // ---------------------------------------------------------------------

    function Record(uint8 config) internal {
        if (config & events != 0) {
            vm.recordLogs();
        }
    }

    function Errors(uint8 config) internal pure returns (bool) {
        return (config & errors) != 0;
    }

    // ---------------------------------------------------------------------
    // Error execution
    // ---------------------------------------------------------------------

    function Execute(address target, bytes memory calldata_) internal {
        delete Err;
        (bool ok, bytes memory out) = target.call(calldata_);
        if (ok) revert("Execute: expected revert");
        Err.captured = true;
        uint256 len = out.length;
        if (len == 0) return;
        if (len < 4) { 
            Err.data = out; 
            return; 
        } 
        bytes4 selector; assembly { 
            selector := mload(add(out, 0x20)) 
        }
        Err.selector = selector;
        if (len == 4) return;
        bytes memory data = new bytes(len - 4);
        assembly { 
            mcopy(
                add(data, 0x20), 
                add(out, 0x24), 
                sub(len, 4)
            ) 
        }
        Err.data = data;
    }
}