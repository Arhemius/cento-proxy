// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapAct} from "./Act.sol";
import {LibBitmapTM} from "./_LibBitmapTM.sol";
import {IBitmap} from "support/interfaces/IBitmap.sol";
import {LibBitmapAdapter} from "support/adapters/LibBitmapAdapter.sol";
import {ReferenceBitmap} from "support/oracles/ReferenceBitmap.sol";

abstract contract LibBitmapTestSetup is LibBitmapTM, LibBitmapAct {

    function lb_createImplementation() internal override returns (IBitmap) {
        return new LibBitmapAdapter();
    }

    function lb_createOracle() internal override returns (IBitmap) {
        return new ReferenceBitmap();
    }
}