// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";

abstract contract BroadcastParser is Test {

    struct BroadcastEntry {
        uint256 transactionIndex;
        string transactionType;
        string contractName;
        address contractAddress;
        bytes32 transactionHash;
        bytes input;
        bytes32 calldataHash;
        uint256 gasUsed;
    }

    BroadcastEntry[] internal entries;

    // ---------------------------------------------------------------------
    // Loading
    // ---------------------------------------------------------------------

    function loadBroadcast(string memory path) internal {
        delete entries;
        string memory json = vm.readFile(path);
        uint256 i;
        while (_loadEntry(json, i)) i++;
    }

    function _loadEntry(string memory json, uint256 index) private returns (bool) {
        BroadcastEntry memory e;
        try vm.parseJsonString(json, _txPath(index, ".transactionType")
        ) returns (string memory transactionType) {
            e.transactionType = transactionType;
        } catch {
            return false;
        }
        e.transactionIndex  = index;
        e.contractName      = vm.parseJsonString (json, _txPath(index, ".contractName"));
        e.transactionHash   = vm.parseJsonBytes32(json, _txPath(index, ".hash"));
        e.input             = vm.parseJsonBytes  (json, _txPath(index, ".transaction.input"));
        e.calldataHash      = keccak256(e.input);
        if (keccak256(bytes(e.transactionType)) == keccak256(bytes("CREATE"))) {
            e.contractAddress = vm.parseJsonAddress(json, _receiptPath(index, ".contractAddress"));
        } else {
            e.contractAddress = vm.parseJsonAddress(json, _txPath(index, ".contractAddress"));
        }
        e.gasUsed           = vm.parseJsonUint   (json, _receiptPath(index, ".gasUsed"));
        entries.push(e);
        return true;
    }

    // ---------------------------------------------------------------------
    // Path helpers
    // ---------------------------------------------------------------------

    function _txPath(uint256 index, string memory suffix) private pure returns (string memory) {
        return string.concat(".transactions[", vm.toString(index),"]", suffix);
    }

    function _receiptPath(uint256 index, string memory suffix) private pure returns (string memory) {
        return string.concat(".receipts[", vm.toString(index), "]", suffix);
    }

    // ---------------------------------------------------------------------
    // General
    // ---------------------------------------------------------------------

    function entryCount() internal view returns (uint256) {
        return entries.length;
    }

    function byIndex(uint256 index) internal view returns (BroadcastEntry storage) {
        return entries[index];
    }

    // ---------------------------------------------------------------------
    // Deployment queries
    // ---------------------------------------------------------------------

    function byContract(string memory contractName) internal view returns (BroadcastEntry storage) {
        bytes32 target = keccak256(bytes(contractName));
        for (uint256 i; i < entries.length; i++) {
            if (keccak256(bytes(entries[i].contractName)) == target) {
                return entries[i];
            }
        }
        revert("BroadcastParser: contract");
    }

    function deploymentGas(string memory contractName) internal view returns (uint256) {
        BroadcastEntry storage e = byContract(contractName);
        require(keccak256(bytes(e.transactionType)) == keccak256(bytes("CREATE")));
        return e.gasUsed;
    }

    // ---------------------------------------------------------------------
    // Call queries
    // ---------------------------------------------------------------------

    function byCalldata(bytes memory data) internal view returns (BroadcastEntry storage) {
        bytes32 target = keccak256(data);
        for (uint256 i; i < entries.length; i++) {
            if (keccak256(entries[i].input) == target) {
                return entries[i];
            }
        }
        revert("BroadcastParser: calldata");
    }

    function callGas(bytes memory data) internal view returns (uint256) {
        BroadcastEntry storage e = byCalldata(data);
        require(keccak256(bytes(e.transactionType)) == keccak256(bytes("CALL")) ||
                keccak256(bytes(e.transactionType)) == keccak256(bytes("STATICCALL"))
        );
        return e.gasUsed;
    }

    // ---------------------------------------------------------------------
    // Convenience queries
    // ---------------------------------------------------------------------

    function byHash(bytes32 _hash) internal view returns (BroadcastEntry storage) {
        for (uint256 i; i < entries.length; i++) {
            if (entries[i].transactionHash == _hash) {
                return entries[i];
            }
        }
        revert("BroadcastParser: hash");
    }

    function byAddress(address target) internal view returns (BroadcastEntry storage) {
        for (uint256 i; i < entries.length; i++) {
            if (entries[i].contractAddress == target) {
                return entries[i];
            }
        }
        revert("BroadcastParser: address");
    }

    function bySelector(bytes4 selector) internal view returns (BroadcastEntry storage) {
        for (uint256 i; i < entries.length; i++) {
            if (entries[i].input.length >= 4 && 
                bytes4(entries[i].input) == selector) {
                return entries[i];
            }
        }
        revert("BroadcastParser: selector");
    }

    function callGas(bytes4 selector) internal view returns (uint256) {
        BroadcastEntry storage e = bySelector(selector);
        require(keccak256(bytes(e.transactionType)) == keccak256(bytes("CALL")) ||
                keccak256(bytes(e.transactionType)) == keccak256(bytes("STATICCALL"))
        );
        return e.gasUsed;
    }
}