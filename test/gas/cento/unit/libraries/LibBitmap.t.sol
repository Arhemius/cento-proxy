// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/builtins/Builtins.sol";
import {bitmap256} from "src/cento/libraries/LibBitmap.sol";
import {LibBitmapTM} from "test/unit/libraries/cento/LibBitmap/AAA/_LibBitmapTM.sol";
import {LibBitmapAdapter} from "support/adapters/LibBitmapAdapter.sol";
import {GasReportLogger} from "support/helpers/GasReportLogger.sol";

contract LibBitmapGasTest is LibBitmapTM, GasReportLogger {

    LibBitmapAdapter internal lb;

    function setUp() public {
        lb = new LibBitmapAdapter();
        setWidths(22, 10, 10);
    }

    function test_00_00_header() public view {
        table("LibBitmap");
    }

    function test_01_00_popFirstFilledSlot() public {
        label("popFirstFilledSlot");
        lb.popFirstFilledSlot(given_SingleBit(0));      tr_("0");
        lb.popFirstFilledSlot(given_SingleBit(64));     tr_("64");
        lb.popFirstFilledSlot(given_SingleBit(128));    tr_("128");
        lb.popFirstFilledSlot(given_SingleBit(255));    tr_("255");
                                                        hr();
    }

    function test_02_00_getFirstEmptySlot() public {
        label("getFirstEmptySlot");
        lb.getFirstEmptySlot(given_AllExcept(0));       tr_("0");
        lb.getFirstEmptySlot(given_AllExcept(64));      tr_("64");
        lb.getFirstEmptySlot(given_AllExcept(128));     tr_("128");
        lb.getFirstEmptySlot(given_AllExcept(255));     tr_("255");
                                                        hr();
    }

    function test_03_00_isSlotOccupied() public {
        label("isSlotOccupied");
        lb.isSlotOccupied(given_SingleBit(0), 0);       tr_("set  (0)");
        lb.isSlotOccupied(given_SingleBit(255), 255);   tr_("set  (255)");
        lb.isSlotOccupied(given_SingleBit(0), 255);     tr_("free (255)");
                                                        hr();
    }

    function test_04_00_fillSlotAt() public {
        label("fillSlotAt");
        lb.fillSlotAt(given_EmptyBitmap(), 0);          tr_("0");
        lb.fillSlotAt(given_EmptyBitmap(), 255);        tr_("255");
                                                        hr();
    }

    function test_05_00_clearSlotAt() public {
        label("clearSlotAt");
        lb.clearSlotAt(given_FullBitmap(), 0);          tr_("0");
        lb.clearSlotAt(given_FullBitmap(), 255);        tr_("255");
                                                        hr();
    }

    function test_06_00_countFilledSlots() public {
        label("countFilledSlots");
        lb.countFilledSlots(given_EmptyBitmap());       tr_("empty");
        lb.countFilledSlots(given_MultipleBits(
            U8_(abi.encode(0, 64, 128, 192))
        ));                                             tr_("sparse (4)");
        lb.countFilledSlots(given_FullBitmap());        tr_("full");
    }

    function test_99_99_footer() public view {
        table();
    }

    function testFuzz_countFilledSlots(bitmap256 bitmap) public view {
        lb.countFilledSlots(bitmap);
    }
}

//   [Gas]    ╭─ LibBitmap ────────────╮
//   [Gas]    │                        ├────────────┬────────────╮
//   [Gas]    │ popFirstFilledSlot     │ 0          │    443 gas │
//   [Gas]    │                        │ 64         │    494 gas │
//   [Gas]    │                        │ 128        │    527 gas │
//   [Gas]    │                        │ 255        │    541 gas │
//   [Gas]    ├────────────────────────┼────────────┼────────────┤
//   [Gas]    │ getFirstEmptySlot      │ 0          │    397 gas │
//   [Gas]    │                        │ 64         │    448 gas │
//   [Gas]    │                        │ 128        │    481 gas │
//   [Gas]    │                        │ 255        │    495 gas │
//   [Gas]    ├────────────────────────┼────────────┼────────────┤
//   [Gas]    │ isSlotOccupied         │ set  (0)   │    249 gas │
//   [Gas]    │                        │ set  (255) │    249 gas │
//   [Gas]    │                        │ free (255) │    249 gas │
//   [Gas]    ├────────────────────────┼────────────┼────────────┤
//   [Gas]    │ fillSlotAt             │ 0          │    267 gas │
//   [Gas]    │                        │ 255        │    267 gas │
//   [Gas]    ├────────────────────────┼────────────┼────────────┤
//   [Gas]    │ clearSlotAt            │ 0          │    355 gas │
//   [Gas]    │                        │ 255        │    355 gas │
//   [Gas]    ├────────────────────────┼────────────┼────────────┤
//   [Gas]    │ countFilledSlots       │ empty      │    276 gas │
//   [Gas]    │                        │ sparse (4) │    620 gas │
//   [Gas]    │                        │ full       │ 22,292 gas │
//   [Gas]    ╰────────────────────────┴────────────┴────────────╯