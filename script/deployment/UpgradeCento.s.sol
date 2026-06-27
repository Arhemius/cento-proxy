// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {$CentoProxy} from "interaction/Cento.sol";
import {Facet} from "src/structs/Facet.sol";
import "support/etl/FacetArray/FacetArray.sol";
import "support/etl/BytesNArray/Bytes4Array.sol";
import {EnvHelpers} from "../_helper/EnvironmentHelpers.s.sol";

/**
 * @title UpgradeCento
 * @notice Upgrades facets in deployed Cento Proxy via atomic update
 *
 * INSTRUCTIONS:
 * 1. Edit the upgrade parameters below
 * 2. Run: forge script script/UpgradeCento.s.sol --rpc-url $RPC_URL --broadcast
 *
 * Parameters:
 *   - setFacets: array of (index, facet_address) pairs to update
 *   - interfacesToAdd: ERC interface IDs to add support for (bytes4 array)
 *   - interfacesToRemove: ERC interface IDs to remove support for (bytes4 array)
 *   - migrator: address of state migration contract (address(0) if none)
 *   - migratorCalldata: calldata to send to migrator (empty bytes if none)
 */
contract UpgradeCento is Script, EnvHelpers {

    struct UpgradeReceipt {
        string network;
        address router;
        Facet[] setFacets;
        bytes4[] interfacesToAdd;
        bytes4[] interfacesToRemove;
        address migrator;
        address executor;
        uint256 blockNumber;
        uint256 timestamp;
    }

    function run() public {
        // ========== EDIT THESE PARAMETERS ==========
        Facet[] memory setFacets = FacetArr(abi.encode(
            // Example: 
            // 3, 0x1234567890123456789012345678901234567890,
            // Cento.TOKEN_V1, address(readFacet(TokenV1)) // addresses of deployed facets can be stored elsewhere (in json)
        ))._out();

        bytes4[] memory addInterfaces = B4_(abi.encode(
            // Example: 
            // 0xabcdef01,
            // type(IExample).interfaceId
        ));

        bytes4[] memory removeInterfaces = B4_(abi.encode(
            // Same as above
        ));

        address migrator = address(0);

        bytes memory migratorCalldata = ""; // abi.encodeCall();

        // ==========================================

        
        string memory network = getNetworkName();
        address owner  = getOwnerAddress(network);
        address router = getRouterAddress(network);
        require(router != address(0), "Router not found in config");

        console.log("=== Cento Proxy Upgrade ===\n");
        console.log("Router: %s", router);
        console.log("Network: %s", network);
        console.log("Owner: %s\n", owner);

        vm.startBroadcast(owner);

        $CentoProxy CentoProxy = $CentoProxy.wrap(router);
        console.log("\nExecuting atomic upgrade...");
        CentoProxy.atomicUpdate(
            setFacets,
            addInterfaces,
            removeInterfaces,
            migrator,
            migratorCalldata
        );

        vm.stopBroadcast();

        UpgradeReceipt memory receipt = UpgradeReceipt({
            network: network,
            router: router,
            setFacets: setFacets,
            interfacesToAdd: addInterfaces,
            interfacesToRemove: removeInterfaces,
            migrator: migrator,
            executor: owner,
            blockNumber: block.number,
            timestamp: block.timestamp
        });

        saveReceipt(receipt);

        console.log("\n=== Upgrade Complete ===");
        console.log("Receipt: receipts/upgrade_receipts/%s/%d.json", network, block.timestamp);
    }

    function saveReceipt(UpgradeReceipt memory receipt) internal {
        string memory root = "receipt";
        string memory json = vm.serializeString (root, "network",     receipt.network     );
                    json = vm.serializeAddress  (root, "router",      receipt.router      );
                    json = vm.serializeAddress  (root, "migrator",    receipt.migrator    );
                    json = vm.serializeAddress  (root, "executor",    receipt.executor    );
                    json = vm.serializeUint     (root, "blockNumber", receipt.blockNumber );
                    json = vm.serializeUint     (root, "timestamp",   receipt.timestamp   );

        json = vm.serializeJsonType (root, "facets", "tuple(uint8 index,address facet)[]",
            abi.encode(receipt.setFacets)
        );
        json = vm.serializeJsonType(root, "interfacesToAdd", "bytes4[]",
            abi.encode(receipt.interfacesToAdd)
        );
        json = vm.serializeJsonType(root, "interfacesToRemove", "bytes4[]",
            abi.encode(receipt.interfacesToRemove)
        );
        string memory path = string.concat(
            "receipts/upgrade_receipts/", receipt.network, "/",
            vm.toString(receipt.timestamp), ".json"
        );
        vm.writeJson(json, path);
    }
}
