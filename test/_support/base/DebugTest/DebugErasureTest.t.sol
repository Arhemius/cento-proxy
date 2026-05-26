// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { LibBitmapAdapter } from "../../adapters/LibBitmapAdapter.sol";
import { LibBitmapDebugAdapter } from "../../adapters/LibBitmapDebugAdapter.sol";
import { DebugErasureAssert } from "./Assert.t.sol";

contract DebugErasureTest is DebugErasureAssert {

    function test_DebugModifiersAreErased() public {
        if (_shouldSkipDebugErasure()) return;
        LibBitmapAdapter plain = new LibBitmapAdapter();
        LibBitmapDebugAdapter instrumented = new LibBitmapDebugAdapter();
        then_DebugModifiersAreErased(address(plain), address(instrumented));
    }
}

