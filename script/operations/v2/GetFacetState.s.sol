// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {EnvHelpers} from "../../_helper/EnvironmentHelpers.s.sol";
import {$CentoProxyV2} from "interaction/CentoV2.sol";

contract GetFacetState is Script, EnvHelpers {

    function run() external view {
        string memory network = getNetworkName();
        address router        = getRouterAddress(network);

        $CentoProxyV2 CentoProxy  = $CentoProxyV2.wrap(router);
        address[] memory facets = CentoProxy.getFacets();
        uint16 facetCount       = CentoProxy.getFacetCount();
        uint8 firstFreeSlot     = CentoProxy.getFirstFreeSlot();

        console.log("\n=== Facet State ===");
        console.log("Network:        ", network);
        console.log("Router:         ", router);
        console.log("Facet count:    ", facetCount);
        console.log("First free slot:", firstFreeSlot);
        console.log("Facets:");
        for (uint256 i = 0; i < facets.length; i++) {
            console.log(" [", i, "]", facets[i]);
        }
    }
}