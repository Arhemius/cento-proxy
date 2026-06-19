// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapArrange} from "./Arrange.sol";
import {LibBitmapAssert} from "./Assert.sol";
import {IBitmap} from "support/interfaces/IBitmap.sol";


abstract contract LibBitmapTM is LibBitmapArrange, LibBitmapAssert {

    constructor() {
        lb_OnConstruct();
    }

    function lb_OnConstruct() internal virtual {
        implementation = lb_createImplementation();
        oracle = lb_createOracle();
    }

    function lb_createImplementation() internal virtual returns (IBitmap) {}

    function lb_createOracle() internal virtual returns (IBitmap) {}
}