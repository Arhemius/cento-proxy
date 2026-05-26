// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "../../../../../lib/forge-std/src/Test.sol";
import {IBitmap} from "../../../../_support/interfaces/IBitmap.sol";
import {LibBitmapTestSetup} from "./Setup.sol";

/**
 * @title LibBitmap Base Test
 * @notice Foundation for all LibBitmap tests
 */
abstract contract LibBitmapTest is Test, LibBitmapTestSetup {
    // Common test constants
    uint256 constant EMPTY = 0;
    uint256 constant FULL = type(uint256).max;
    bytes4 constant POPFIRST_FILLED_SLOT = IBitmap.popFirstFilledSlot.selector;
    bytes4 constant GET_FIRST_EMPTY_SLOT = IBitmap.getFirstEmptySlot.selector;

    function _unsafeToUint8(uint256 x) internal pure returns (uint8 r) {
        assembly {
            r := x
        }
    }

    function _unsafeToSelector(bytes memory x) internal pure returns (bytes4 r) {
        assembly {
            r := mload(add(x, 32))
        }
    }

    // function map(
    //     bytes memory data,
    //     function(uint256, bytes memory, uint256) internal pure returns (uint256) fn,
    //     bytes memory args
    // ) internal pure returns (bytes memory) {}


    // function map (
    //     bytes memory data, 
    //     function(uint256, bytes memory, uint256) internal pure returns (uint256) fn,
    //     bytes memory args,
    //     function(
    //         bytes memory, 
    //         function(uint256, bytes memory, uint256) internal pure returns (uint256), 
    //         bytes memory
    //     ) internal pure returns (bytes memory) transform
    // ) {}
    
        // uint256[] memory arr = word(data);
        // for (uint i; i < arr.length; i++) {
        //     arr[i] = fn(arr[i], args, i);
        // }
        // return fromWord(arr);
    // }
}