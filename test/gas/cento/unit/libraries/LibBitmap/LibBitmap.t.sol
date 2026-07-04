// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {bitmap256} from "src/cento/libraries/LibBitmap.sol";
import {LibBitmapTM} from "test/unit/libraries/cento/LibBitmap/AAA/_LibBitmapTM.sol";
import {LibBitmapAdapter} from "support/adapters/LibBitmapAdapter.sol";

/**
 * @title LibBitmapAdapter
 * @notice Contract adapter that implements IBitmap by delegating to LibBitmap library
 * @dev Enables interface-based testing of the LibBitmap library
 */
contract LibBitmapGasTest is LibBitmapTM {

    LibBitmapAdapter internal adapter;

    function setUp() public {
        adapter = new LibBitmapAdapter();
    }

    function test_popFirstFilledSlot() public {
        string memory target = "popFirstFilledSlot";
        adapter.popFirstFilledSlot(given_SingleBit(0));     vm.snapshotGasLastCall(target);
        adapter.popFirstFilledSlot(given_SingleBit(64));    vm.snapshotGasLastCall(target);
        adapter.popFirstFilledSlot(given_SingleBit(128));   vm.snapshotGasLastCall(target);
        adapter.popFirstFilledSlot(given_SingleBit(255));   vm.snapshotGasLastCall(target);
    }

    function test_getFirstEmptySlot() public {
        string memory target = "getFirstEmptySlot";
        adapter.getFirstEmptySlot(given_AllExcept(255));    vm.snapshotGasLastCall(target);
    }

    function testFuzz_countFilledSlots(bitmap256 bitmap) public {
        string memory target = "countFilledSlots";
        adapter.countFilledSlots(bitmap);                   vm.snapshotGasLastCall(target);
    }
}