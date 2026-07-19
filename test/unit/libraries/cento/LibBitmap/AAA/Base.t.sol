// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {IBitmap} from "support/interfaces/IBitmap.sol";
import {bitmap256} from "cento/types/bitmap256.sol";
import {$Execute} from "support/helpers/errors/_Execute.sol";

abstract contract LibBitmapTest is Test, $Execute {

    bitmap256 immutable EMPTY_BITMAP = bitmap256.wrap(0);
    bitmap256 immutable FULL_BITMAP = bitmap256.wrap(type(uint256).max);

    bytes4 constant POPFIRST_FILLED_SLOT = IBitmap.popFirstFilledSlot.selector;
    bytes4 constant GET_FIRST_EMPTY_SLOT = IBitmap.getFirstEmptySlot.selector;

    IBitmap internal implementation;
    IBitmap internal oracle;

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
}