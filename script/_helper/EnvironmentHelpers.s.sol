// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {Facet} from "cento/structs/Facet.sol";

abstract contract EnvHelpers is Script {

    using stdJson for string;

    string private constant OWNER_CONFIG_PATH  = "logs/config/owner.json";
    string private constant ROUTER_CONFIG_PATH = "logs/config/router.json";

    // -------------------------------------------------------------------------
    // Network
    // -------------------------------------------------------------------------

    function getNetworkName() internal view returns (string memory) {
        if (block.chainid == 1)        return "mainnet";
        if (block.chainid == 11155111) return "sepolia";
        if (block.chainid == 5)        return "goerli";
        if (block.chainid == 31337)    return "anvil";
        return "unknown";
    }

    // -------------------------------------------------------------------------
    // Owner
    // -------------------------------------------------------------------------

    function getOwnerAddress(string memory networkName) internal view returns (address) {
        try vm.readFile(OWNER_CONFIG_PATH) returns (string memory configJson) {
            string memory key = string.concat(".", networkName);
            if (configJson.keyExists(key)) {
                return configJson.readAddress(key);
            }
        } catch {}

        if (block.chainid == 31337) return 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

        revert(string.concat("No owner configured for network: ", networkName));
    }

    function setOwnerAddress(string memory networkName, address owner) internal {
        require(owner != address(0), "setOwnerAddress: zero address");

        _ensureFileExists(OWNER_CONFIG_PATH);
        vm.writeJson(vm.toString(owner), OWNER_CONFIG_PATH, string.concat(".", networkName));
    }

    // -------------------------------------------------------------------------
    // Router
    // -------------------------------------------------------------------------

    function getRouterAddress(string memory networkName) internal view returns (address) {
        try vm.readFile(ROUTER_CONFIG_PATH) returns (string memory configJson) {
            string memory key = string.concat(".", networkName);
            if (configJson.keyExists(key)) {
                return configJson.readAddress(key);
            }
        } catch {}

        return address(0);
    }

    function setRouterAddress(string memory networkName, address router) internal {
        require(router != address(0), "setRouterAddress: zero address");

        _ensureFileExists(ROUTER_CONFIG_PATH);
        vm.writeJson(vm.toString(router), ROUTER_CONFIG_PATH, string.concat(".", networkName));
    }

    // -------------------------------------------------------------------------
    // Json
    // -------------------------------------------------------------------------

    function serializeFacets(Facet[] memory facets) internal pure returns (string memory json) {
        json = "[";
        for (uint256 i; i < facets.length; i++) {
            if (i != 0) json = string.concat(json, ",");
            json = string.concat(
                json,
                '{"index":',  vm.toString(facets[i].index),
                ',"facet":"', vm.toString(facets[i].facet), '"}'
            );
        }
        json = string.concat(json, "]");
    }

    function serializeInterfaces(bytes4[] memory interfaces) internal pure returns (string memory json) {
        json = "[";
        for (uint256 i; i < interfaces.length; i++) {
            if (i != 0) json = string.concat(json, ",");
            json = string.concat(
                json, '"', vm.toString(interfaces[i]), '"'
            );
        }
        json = string.concat(json, "]");
    }

    // -------------------------------------------------------------------------
    // Internal
    // -------------------------------------------------------------------------

    function _ensureFileExists(string memory path) internal {
        try vm.readFile(path) {} catch {
            vm.writeFile(path, "{}");
        }
    }
}