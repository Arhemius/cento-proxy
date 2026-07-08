// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

abstract contract GasReportLogger is Test {

    /*//////////////////////////////////////////////////////////////////////////
                                   LAYOUT
    //////////////////////////////////////////////////////////////////////////*/

    uint8 internal FN_WIDTH;
    uint8 internal CASE_WIDTH;
    uint8 internal GAS_WIDTH;

    constructor () {
        setWidths(26, 12, 14);
    }

    function setWidths(uint8 fn, uint8 mode, uint8 gas) internal {
        FN_WIDTH = fn;
        CASE_WIDTH = mode;
        GAS_WIDTH = gas;
    }

    string  internal constant PREFIX = "[Gas]    ";

    string  private _label;
    string  private _functionName;

    /*//////////////////////////////////////////////////////////////////////////
                                  PUBLIC API
    //////////////////////////////////////////////////////////////////////////*/

    function table(string memory title) internal view {
        console.log(PREFIX);
        console.log(string.concat(PREFIX, _top(title)));
    }

    function label(string memory functionName) internal {
        _label = functionName;
        _functionName = functionName;
    }
        
    function th(string memory functionName) internal {
        th(functionName, "");
    }

    function th(string memory functionName, string memory mode) internal {
        label(functionName);
        tr_(mode);
    }

    function tr(string memory functionName) internal {
        tr(functionName, "");
    }

    function tr(string memory functionName, string memory mode) internal {
        _label = functionName;
        tr_(mode);
    }

    function tr_(string memory mode) internal {
        console.log(string.concat(
            PREFIX,
            unicode"│ ",  _padRight(_functionName, FN_WIDTH),
            unicode" │ ", _padRight(mode, CASE_WIDTH),
            unicode" │ ", _padLeft(string.concat(_formatGas(vm.snapshotGasLastCall(_label, mode)), " gas"), GAS_WIDTH),
            unicode" │"
        ));
        _functionName = "";
    }

    function hr() internal view {
        console.log(string.concat(PREFIX, _middle()));
    }

    function table() internal view {
        console.log(string.concat(PREFIX, _bottom()));
        console.log(PREFIX);
    }

    /*//////////////////////////////////////////////////////////////////////////
                                 BORDERS
    //////////////////////////////////////////////////////////////////////////*/

    function _top(string memory title) private view returns (string memory) {
        return string.concat(
            unicode"╭─ ", title, " ", _repeat(unicode"─", FN_WIDTH - bytes(title).length - 1), unicode"╮\n  ", 
            // here we'll add contract size and deployment cost?
            PREFIX,
            unicode"│ ", _repeat(" ", FN_WIDTH),
            unicode" ├", _repeat(unicode"─", CASE_WIDTH + 2),
            unicode"┬",  _repeat(unicode"─", GAS_WIDTH + 2),
            unicode"╮"
        );
    }

    function _middle() private view returns (string memory) {
        return string.concat(
            unicode"├", _repeat(unicode"─", FN_WIDTH + 2),
            unicode"┼", _repeat(unicode"─", CASE_WIDTH + 2),
            unicode"┼", _repeat(unicode"─", GAS_WIDTH + 2),
            unicode"┤"
        );
    }

    function _bottom() private view returns (string memory) {
        return string.concat(
            unicode"╰", _repeat(unicode"─", FN_WIDTH + 2),
            unicode"┴", _repeat(unicode"─", CASE_WIDTH + 2),
            unicode"┴", _repeat(unicode"─", GAS_WIDTH + 2),
            unicode"╯"
        );
    }

    /*//////////////////////////////////////////////////////////////////////////
                                 HELPERS
    //////////////////////////////////////////////////////////////////////////*/

    function _padRight(string memory value, uint256 width) private pure returns (string memory) {
        bytes memory str = bytes(value);
        if (str.length >= width) return value;
        return string.concat(value, _repeat(" ", width - str.length));
    }

    function _padLeft(string memory value, uint256 width) private pure returns (string memory) {
        bytes memory str = bytes(value);
        if (str.length >= width) return value;
        return string.concat(_repeat(" ", width - str.length), value);
    }

    function _repeat(string memory symbol, uint256 count) private pure returns (string memory) {
        bytes memory s = bytes(symbol);
        bytes memory out = new bytes(s.length * count);
        uint256 k;
        for (uint256 i; i < count; ++i) {
            for (uint256 j; j < s.length; ++j) {
                out[k++] = s[j];
            }
        }
        return string(out);
    }

    function _formatGas(uint256 value) private pure returns (string memory) {
        bytes memory input = bytes(vm.toString(value));
        uint256 len = input.length;
        if (len <= 3) return string(input);
        uint256 commas = (len - 1) / 3;
        bytes memory output = new bytes(len + commas);
        uint256 i = len;
        uint256 j = output.length;
        uint256 copied;
        while (i > 0) {
            output[--j] = input[--i];
            ++copied;
            if (copied == 3 && i > 0) {
                output[--j] = ",";
                copied = 0;
            }
        }
        return string(output);
    }
}