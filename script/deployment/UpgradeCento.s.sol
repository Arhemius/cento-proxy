// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {$CentoProxyV2} from "interaction/CentoV2.sol";
import {Facet} from "cento/structs/Facet.sol";
import {EnvHelpers} from "../_helper/EnvironmentHelpers.s.sol";
import {UpgradeConfig} from "./UpgradeConfig.sol";

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
contract UpgradeCento is Script, EnvHelpers, UpgradeConfig {

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
        string memory network = getNetworkName();
        address owner  = getOwnerAddress(network);
        address router = getRouterAddress(network);
        require(router != address(0), "Router not found in config");

        vm.startBroadcast(owner);

        console.log("=== Cento Proxy Upgrade ===\n");
        console.log("Router: %s", router);
        console.log("Network: %s", network);
        console.log("Owner: %s\n", owner);

        (Facet[] memory setFacets,
        bytes4[] memory addInterfaces,
        bytes4[] memory removeInterfaces,
        address migrator, bytes memory migratorCalldata) = buildUpgrade();

        $CentoProxyV2 CentoProxy = $CentoProxyV2.wrap(router);
        console.log("\nExecuting atomic upgrade...");
        CentoProxy.atomicUpdate(
            setFacets,
            addInterfaces,
            removeInterfaces,
            migrator,
            migratorCalldata
        );

        vm.stopBroadcast();

        UpgradeReceipt memory receipt = buildReceipt(
            network,
            router,
            setFacets,
            addInterfaces,
            removeInterfaces,
            migrator,
            owner
        );

        saveReceipt(receipt);

        console.log("\n=== Upgrade Complete ===");
        console.log("Receipt: logs/receipts/upgrade/%s/%d.json", network, block.timestamp);
    }

    function buildReceipt(
        string memory network,
        address router,
        Facet[] memory facets,
        bytes4[] memory interfacesToAdd,
        bytes4[] memory interfacesToRemove,
        address migrator,
        address executor
    ) internal view returns (UpgradeReceipt memory receipt) {
        receipt.network = network;
        receipt.router = router;
        receipt.setFacets = facets;
        receipt.interfacesToAdd = interfacesToAdd;
        receipt.interfacesToRemove = interfacesToRemove;
        receipt.migrator = migrator;
        receipt.executor = executor;
        receipt.blockNumber = block.number;
        receipt.timestamp = block.timestamp;
    }

    function saveReceipt(UpgradeReceipt memory receipt) internal {
        string memory facetChanges = serializeFacets(receipt.setFacets);
        string memory addedInterfaces = serializeInterfaces(receipt.interfacesToAdd);
        string memory removedInterfaces = serializeInterfaces(receipt.interfacesToRemove);

        string memory json = string.concat(
            "{",
                '"network":"',    receipt.network, '",',
                '"router":"',     vm.toString(receipt.router), '",',
                '"migrator":"',   vm.toString(receipt.migrator), '",',
                '"executor":"',   vm.toString(receipt.executor), '",',
                '"blockNumber":', vm.toString(receipt.blockNumber), ',',
                '"timestamp":',   vm.toString(receipt.timestamp), ',',
                '"facets":',      facetChanges, ',',
                '"addedInterfaces":',  addedInterfaces, ',',
                '"removedInterfaces":',  removedInterfaces,
            "}"
        );

        string memory path = string.concat(
            "logs/receipts/upgrade/", receipt.network, "/",
            vm.toString(receipt.timestamp), ".json"
        );

        vm.writeFile(path, json);
    }
}