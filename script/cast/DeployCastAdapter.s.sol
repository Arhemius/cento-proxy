// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script}      from "forge-std/Script.sol";
import {console}     from "forge-std/console.sol";
import {EnvHelpers}  from "../_helper/EnvironmentHelpers.s.sol";
import {CastAdapter} from "./CastAdapter.sol";

contract DeployCastAdapter is Script, EnvHelpers {

    string private constant CONFIG_PATH = "logs/config/cast_adapter.json";

    function run() external {
        string memory network = getNetworkName();
        address router        = getRouterAddress(network);
        address deployer      = getOwnerAddress(network);

        console.log("\n=== Deploy CastAdapter ===");
        console.log("Network:", network);
        console.log("Router: ", router);

        vm.startBroadcast(deployer);

        CastAdapter adapter = new CastAdapter(router);

        vm.stopBroadcast();

        console.log("CastAdapter:", address(adapter));

        _ensureFileExists(CONFIG_PATH);
        vm.writeJson(vm.toString(address(adapter)), CONFIG_PATH, string.concat(".", network));
        console.log("\nlogs/config/cast_adapter.json updated.");
    }
}