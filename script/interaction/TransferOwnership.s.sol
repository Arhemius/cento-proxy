// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script}      from "forge-std/Script.sol";
import {console}     from "forge-std/console.sol";
import {EnvHelpers}  from "../_helper/EnvironmentHelpers.s.sol";
import {$CentoProxy} from "interaction/Cento.sol";

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

        $CentoProxy CentoProxy = $CentoProxy.wrap(router);
        CentoProxy.transferOwnership(newOwner);

        vm.stopBroadcast();

        setOwnerAddress(network, newOwner);
        console.log("\nconfig/owner.json updated.");
    }
}