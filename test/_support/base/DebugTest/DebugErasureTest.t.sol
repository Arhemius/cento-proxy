// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { DebugErasureAssert } from "./Assert.t.sol";
import { console } from "forge-std/console.sol";
import { LibBitmapAdapter } from "support/adapters/LibBitmapAdapter.sol";
import { ReferenceBitmapDebug } from "support/oracles/ReferenceBitmapDebug.sol";
import { LibCentoAdapter } from "support/adapters/LibCentoAdapter.sol";
import { ReferenceCentoDebug } from "support/oracles/ReferenceCentoDebug.sol";


contract DebugErasureTest is DebugErasureAssert {

    function test_DebugModifiersAreErased() public {
        if (_shouldSkipDebugErasure()) return;

        console.log("\n  === LibBitmap ===");
        LibBitmapAdapter plainBitmap = new LibBitmapAdapter();
        ReferenceBitmapDebug instrumentedBitmap = new ReferenceBitmapDebug();
        then_DebugModifiersAreErased(address(plainBitmap), address(instrumentedBitmap));

        console.log("\n  === LibCento ===");
        LibCentoAdapter plainCento = new LibCentoAdapter();
        ReferenceCentoDebug instrumentedCento = new ReferenceCentoDebug();
        then_DebugModifiersAreErased(address(plainCento), address(instrumentedCento));
    }
}

