// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {EnvHelpers} from "../../_helper/EnvironmentHelpers.s.sol";
import {$CentoProxyV2} from "interaction/CentoV2.sol";

contract GetOwner is Script, EnvHelpers {

    function run() external view {
        string memory network = getNetworkName();
        address router        = getRouterAddress(network);

        $CentoProxyV2 CentoProxy = $CentoProxyV2.wrap(router);
        address currentOwner = CentoProxy.owner();

        console.log("\n=== Owner ===");
        console.log("Network:", network);
        console.log("Router: ", router);
        console.log("Owner:  ", currentOwner);
    }
}