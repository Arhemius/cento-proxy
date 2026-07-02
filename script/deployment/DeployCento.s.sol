// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {CentoRouter} from "cento/CentoRouter.sol";
import {Ownership} from "cento/facets/Ownership.sol";
import {Observability} from "cento/facets/Observability.sol";
import {FacetManager} from "cento/facets/FacetManager.sol";
import {EnvHelpers} from "../_helper/EnvironmentHelpers.s.sol";
import {$CentoProxyV1} from "interaction/CentoV1.sol";
import {Facet} from "cento/structs/Facet.sol";
import {DeploymentConfig} from "./DeploymentConfig.sol";

contract DeployCento is Script, EnvHelpers, DeploymentConfig {
    struct DeploymentReceipt {
        string network;
        address router;
        Facet[] installedFacets;
        bytes4[] addedInterfaces;
        address migrator;
        address deployer;
        uint256 blockNumber;
        uint256 timestamp;
    }

    function run() public {
        string memory network = getNetworkName();
        address owner = getOwnerAddress(network);
        
        vm.startBroadcast();

        console.log("\n  === Cento Proxy Deployment ===\n");
        console.log("Owner: %s", owner);
        console.log("Network: %s\n", network);
        console.log("Deploying facets...");

        (Facet[] memory setFacets,
        bytes4[] memory addInterfaces,
        address migrator, bytes memory migratorCalldata) = buildDeployment();

        address[3] memory facets = deployCoreFacets();

        console.log("  FacetManager: %s", facets[0]);
        console.log("  Ownership: %s",      facets[1]);
        console.log("  Observability: %s\n",  facets[2] );

        console.log("Deploying CentoRouter...");
        address router = deployRouter(owner, facets);
        console.log("  Router: %s\n", router);

        $CentoProxyV1 CentoProxy = $CentoProxyV1.wrap(router);
        console.log("\nExecuting atomic upgrade...");
        CentoProxy.atomicUpdate(
            setFacets,
            addInterfaces,
            new bytes4[](0),
            migrator,
            migratorCalldata
        );

        vm.stopBroadcast();

        Facet[] memory deployedFacets = concatFacets(facets, setFacets);
        DeploymentReceipt memory receipt = buildReceipt(network, router, deployedFacets);
        saveReceipt(receipt);
        setRouterAddress(network, router);

        console.log("=== Deployment Complete ===");
        console.log("Receipt: logs/receipts/deployment/%s/%d.json", network, block.timestamp);
        console.log("Config: logs/config/router.json");
    }

    function deployCoreFacets() internal returns (address[3] memory facets) {
        facets[0] = address(new FacetManager());
        facets[1] = address(new Ownership());
        facets[2] = address(new Observability());
    }

    function deployRouter(address owner, address[3] memory facets) internal returns (address router) {
        router = address(new CentoRouter(owner, facets));
    }

    function concatFacets(address[3] memory coreFacets, Facet[] memory setFacets) internal pure returns (Facet[] memory allFacets) {
        allFacets = new Facet[](setFacets.length + 3);
        allFacets[0] = Facet({index: 0, facet: coreFacets[0]});
        allFacets[1] = Facet({index: 1, facet: coreFacets[1]});
        allFacets[2] = Facet({index: 2, facet: coreFacets[2]});
        for(uint256 i = 0; i<setFacets.length; i++) {
            allFacets[i+3] = setFacets[i];
        }
    }

    function buildReceipt(
        string memory network,
        address router,
        Facet[] memory facets
    ) internal view returns (DeploymentReceipt memory receipt) {
        receipt.network = network;
        receipt.router = router;
        receipt.installedFacets = facets;
        receipt.addedInterfaces = new bytes4[](0);
        receipt.migrator = address(0);
        receipt.deployer = msg.sender;
        receipt.blockNumber = block.number;
        receipt.timestamp = block.timestamp;
    }

    function saveReceipt(DeploymentReceipt memory receipt) internal {
        string memory facets = serializeFacets(receipt.installedFacets);
        string memory interfaces = serializeInterfaces(receipt.addedInterfaces);

        string memory json = string.concat(
            "{",
                '"network":"',    receipt.network, '",',
                '"router":"',     vm.toString(receipt.router), '",',
                '"facets":',      facets, ',',
                '"interfaces":',  interfaces, ',',
                '"migrator":"',   vm.toString(receipt.migrator), '",',
                '"deployer":"',   vm.toString(receipt.deployer), '",',
                '"blockNumber":', vm.toString(receipt.blockNumber), ',',
                '"timestamp":',   vm.toString(receipt.timestamp),
            "}"
        );

        string memory path = string.concat( 
            "logs/receipts/deployment/", receipt.network, "/", 
            vm.toString(receipt.timestamp), ".json" 
        );

        vm.writeFile(path, json);
    }

}