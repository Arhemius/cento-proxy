// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {CentoRouter} from "cento/CentoRouter.sol";
import {Ownership} from "cento/facets/Ownership.sol";
import {Observability} from "cento/facets/Observability.sol";
import {FacetManager} from "cento/facets/FacetManager.sol";
import {EnvHelpers} from "../_helper/EnvironmentHelpers.s.sol";
import {$CentoProxy} from "interaction/Cento.sol";
import {Facet} from "cento/structs/Facet.sol";
import "support/builtins/Builtins.sol";

contract DeployCento is Script, EnvHelpers {
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
        // custom facets are deployed here (wrap with broadcast)

        // ========== EDIT THESE PARAMETERS ==========
        Facet[] memory setFacets = FacetArr(abi.encode(
            // Example: 
            // 3, 0x1234567890123456789012345678901234567890, // 
            // Cento.TOKEN_V1, address(readFacet(TokenV1)) // addresses of deployed facets can be stored elsewhere (in json)
        ))._out();

        bytes4[] memory addInterfaces = B4_(abi.encode(
            // Example: 
            // 0xabcdef01,
            // type(IExample).interfaceId
        ));

        address migrator = address(0);

        bytes memory migratorCalldata = ""; // abi.encodeCall();

        // ==========================================


        string memory network = getNetworkName();
        address owner = getOwnerAddress(network);
        

        vm.startBroadcast();

        console.log("\n  === Cento Proxy Deployment ===\n");
        console.log("Owner: %s", owner);
        console.log("Network: %s\n", network);

        console.log("Deploying facets...");
        address facetManagerFacet  = address(new FacetManager());
        address ownershipFacet     = address(new Ownership());
        address observabilityFacet = address(new Observability());

        console.log("  FacetManager: %s", facetManagerFacet  );
        console.log("  Ownership: %s",      ownershipFacet     );
        console.log("  Observability: %s\n",  observabilityFacet );

        address[3] memory facets = [facetManagerFacet, ownershipFacet, observabilityFacet];

        console.log("Deploying CentoRouter...");
        CentoRouter router = new CentoRouter(owner, facets);
        console.log("  Router: %s\n", address(router));

        $CentoProxy CentoProxy = $CentoProxy.wrap(address(router));
        console.log("\nExecuting atomic upgrade...");
        CentoProxy.atomicUpdate(
            setFacets,
            addInterfaces,
            new bytes4[](0),
            migrator,
            migratorCalldata
        );

        vm.stopBroadcast();

        Facet[] memory deployedFacets = new Facet[](setFacets.length + 3);
        deployedFacets[0] = Facet({index: 0, facet: facetManagerFacet});
        deployedFacets[1] = Facet({index: 1, facet: ownershipFacet});
        deployedFacets[2] = Facet({index: 2, facet: observabilityFacet});
        for(uint256 i = 0; i<setFacets.length; i++) {
            deployedFacets[i+3] = setFacets[i];
        }


        DeploymentReceipt memory receipt = DeploymentReceipt({
            network: network,
            router: address(router),
            installedFacets: deployedFacets,
            addedInterfaces: addInterfaces,
            migrator: migrator,
            deployer: msg.sender,
            blockNumber: block.number,
            timestamp: block.timestamp
        });

        saveReceipt(receipt);
        setRouterAddress(network, address(router));

        console.log("=== Deployment Complete ===");
        console.log("Receipt: logs/receipts/deployment/%s/%d.json", network, block.timestamp);
        console.log("Config: logs/config/router.json");
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