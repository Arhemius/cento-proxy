// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {CentoRouter} from "src/CentoRouter.sol";
import {Ownership} from "src/facets/Ownership.sol";
import {Observability} from "src/facets/Observability.sol";
import {FacetManager} from "src/facets/FacetManager.sol";
import {EnvHelpers} from "../_helper/EnvironmentHelpers.s.sol";

contract DeployCento is Script, EnvHelpers {
    struct DeploymentReceipt {
        string network;
        address router;
        address ownershipFacet;
        address observabilityFacet;
        address facetManagerFacet;
        address deployer;
        uint256 blockNumber;
        uint256 timestamp;
    }

    function run() public {
        string memory network = getNetworkName();
        address owner = getOwnerAddress(network);
        

        vm.startBroadcast();

        console.log("=== Cento Proxy Deployment ===\n");
        console.log("Owner: %s", owner);
        console.log("Network: %s\n", network);

        console.log("Deploying facets...");
        address ownershipFacet     = address(new Ownership());
        address observabilityFacet = address(new Observability());
        address facetManagerFacet  = address(new FacetManager());

        console.log("  Ownership: %s",      ownershipFacet     );
        console.log("  Observability: %s",  observabilityFacet );
        console.log("  FacetManager: %s\n", facetManagerFacet  );

        address[3] memory facets = [facetManagerFacet, observabilityFacet, ownershipFacet];

        console.log("Deploying CentoRouter...");
        CentoRouter router = new CentoRouter(owner, facets);
        console.log("  Router: %s\n", address(router));

        vm.stopBroadcast();


        DeploymentReceipt memory receipt = DeploymentReceipt({
            network: network,
            router: address(router),
            ownershipFacet: ownershipFacet,
            observabilityFacet: observabilityFacet,
            facetManagerFacet: facetManagerFacet,
            deployer: msg.sender,
            blockNumber: block.number,
            timestamp: block.timestamp
        });

        saveReceipt(receipt);
        setRouterAddress(network, address(router));

        console.log("=== Deployment Complete ===");
        console.log("Receipt: receipts/deployment_receipts/%s/%d.json", network, block.timestamp);
        console.log("Config: config/router.json");
    }

    function saveReceipt(DeploymentReceipt memory receipt) internal {
        string memory root = "receipt";
        string memory json = vm.serializeString (root, "network",            receipt.network            );
                    json = vm.serializeAddress  (root, "router",             receipt.router             );
                    json = vm.serializeAddress  (root, "ownershipFacet",     receipt.ownershipFacet     );
                    json = vm.serializeAddress  (root, "observabilityFacet", receipt.observabilityFacet );
                    json = vm.serializeAddress  (root, "facetManagerFacet",  receipt.facetManagerFacet  );
                    json = vm.serializeAddress  (root, "deployer",           receipt.deployer           );
                    json = vm.serializeUint     (root, "blockNumber",        receipt.blockNumber        );
                    json = vm.serializeUint     (root, "timestamp",          receipt.timestamp          );

        string memory path = string.concat(
            "receipts/deployment_receipts/", receipt.network, "/",
            vm.toString(receipt.timestamp), ".json"
        );
        vm.writeJson(json, path);
    }
}