// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CounterV2TestSetup} from "./_Setup.sol";
import "support/builtins/Builtins.sol";
import {CentoV2} from "interaction/CentoV2.sol";
import {LibCentoPureAssert} from "test/unit/libraries/cento/LibCento/AAA/PureAssert.sol";

contract CounterV2Test is CounterV2TestSetup, LibCentoPureAssert {

    function test_CounterObservability_DetectsFacetAt() public view {
        address counterV2 = CentoProxy.getFacetAt(CentoV2.COUNTER_V2);
        then_FacetAddressesMatch(counterV2, counterV2Facet);
    }

    function test_CounterRouter_CallsSuccessfully() public {
        CentoProxy.inc();
        CentoProxy.dec();
    }
}