// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {EnvHelpers} from "../../_helper/EnvironmentHelpers.s.sol";
import {$CentoProxyV2} from "interaction/CentoV2.sol";
import {Facet} from "cento/structs/Facet.sol";

contract GetFacets is Script, EnvHelpers {

    string private constant OUTPUT_PATH = "logs/facets.json";

    function run() external {
        string memory network = getNetworkName();
        address router        = getRouterAddress(network);

        $CentoProxyV2 CentoProxy = $CentoProxyV2.wrap(router);
        Facet[] memory facets  = CentoProxy.getFacetEntries();

        console.log("\n=== Facet Entries ===");
        console.log("Network: ", network);
        console.log("Router:  ", router);
        console.log("Count:   ", facets.length);
        console.log("---");
        for (uint256 i = 0; i < facets.length; i++) {
            console.log("Index:", facets[i].index, " Facet:", facets[i].facet);
        }
        string memory _facets = serializeFacets(facets);
        string memory json = string.concat(
            "{",
                '"network":"', network, '",',
                '"router":"', vm.toString(router), '",',
                '"facets":', _facets,
            "}"
        );

        vm.writeFile(OUTPUT_PATH, json);
        console.log("\nlogs/facets.json updated.");
    }
}