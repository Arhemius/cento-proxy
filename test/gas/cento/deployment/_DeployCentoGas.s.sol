// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {FacetManager} from "src/cento/facets/FacetManager.sol";
import {Ownership} from "src/cento/facets/Ownership.sol";
import {Observability} from "src/cento/facets/Observability.sol";
import {CentoRouter} from "src/cento/CentoRouter.sol";

contract DeployCentoGasTest is Script {

    function run() public {
        address owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

        vm.startBroadcast();
        new CentoRouter(owner, [
            address(new FacetManager()), 
            address(new Ownership()), 
            address(new Observability())
        ]);
        vm.stopBroadcast();
    }
}