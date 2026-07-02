// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script}      from "forge-std/Script.sol";
import {console}     from "forge-std/console.sol";
import {EnvHelpers}  from "../../_helper/EnvironmentHelpers.s.sol";
import {$CentoProxyV2} from "interaction/CentoV2.sol";

contract TransferOwnership is Script, EnvHelpers {

    address newOwner = address(2);

    function run() external {
        string memory network = getNetworkName();
        address router        = getRouterAddress(network);
        address currentOwner  = getOwnerAddress(network);

        console.log("\n=== Ownership Transfer ===");
        console.log("Network:       ", network);
        console.log("Router:        ", router);
        console.log("Current owner: ", currentOwner);
        console.log("New owner:     ", newOwner);

        vm.startBroadcast(currentOwner);

        $CentoProxyV2 CentoProxy = $CentoProxyV2.wrap(router);
        CentoProxy.transferOwnership(newOwner);

        vm.stopBroadcast();

        setOwnerAddress(network, newOwner);
        console.log("\nlogs/config/owner.json updated.");
    }
}