// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CounterV1TestSetup} from "./_Setup.sol";
import "support/builtins/Builtins.sol";
import {CentoV1} from "interaction/CentoV1.sol";
import {LibCentoPureAssert} from "test/unit/libraries/cento/LibCento/AAA/PureAssert.sol";

contract CounterV1Test is CounterV1TestSetup, LibCentoPureAssert {

    function test_CounterObservability_DetectsFacetAt() public view {
        address counterV1 = CentoProxy.getFacetAt(CentoV1.COUNTER_V1);
        then_FacetAddressesMatch(counterV1, counterV1Facet);
    }

    function test_CounterRouter_CallsSuccessfully() public {
        CentoProxy.inc();
    }
}