// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {LibCentoTM} from "test/unit/libraries/LibCento/AAA/_LibCentoTM.sol";
import {CentoRouterAdapter} from "support/adapters/CentoRouterAdapter.sol";
import {$CentoProxy} from "interaction/Cento.sol";

abstract contract CentoRouterTest is Test, LibCentoTM {

    bytes4  internal ERR_FACET_NOT_FOUND = bytes4(keccak256("FacetNotFound(uint8)"));

    address internal facetManager;
    address internal observability;
    address internal ownership;

    CentoRouterAdapter internal cr;
    $CentoProxy internal CentoProxy;

}