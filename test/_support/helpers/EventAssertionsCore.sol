// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import "forge-std/Vm.sol";

abstract contract EventAssertionsCore is Test {
    
    bytes   internal constant ANY_DATA     = "";
    address internal constant ANY_EMITTER  = address(0);
    uint256 internal constant SINGLE_EVENT = type(uint256).max;
    uint256 internal constant NO_EVENT     = type(uint256).max - 1;

    function ANY_TOPIC() internal pure returns(bytes32[] memory) {
        return new bytes32[](0);
    }

    // ============ log getter functions =============

    function recordLogs() internal {
        vm.recordLogs();
    }

    function getLogs() internal view returns (Vm.Log[] memory) {
        return vm.getRecordedLogs();
    }

    function getLog() internal view returns (Vm.Log memory) {
        Vm.Log[] memory logs = vm.getRecordedLogs();
        require(logs.length == 1, "Expected exactly 1 log");
        return logs[0];
    }

    function getLog(uint256 i) internal view returns (Vm.Log memory) {
        return vm.getRecordedLogs()[i];
    }

    // =============================================================
    // Core matcher (internal engine)
    // =============================================================

    function _match(
        Vm.Log memory log, 
        uint256 i,
        address emitter, 
        bytes4 selector, 
        bytes32[] memory topics, 
        bytes memory data
    ) internal pure {
        _matchesEmitter (log, i, emitter);
        _matchesSelector(log, i, selector);
        _matchesTopics  (log, i, topics);
        _matchesData    (log, i, data);
    }


    function _matchesEmitter(Vm.Log memory log, uint256 i, address emitter) private pure {
        if (emitter == ANY_EMITTER) return;
        if (log.emitter != emitter) {
            Fail(i, string.concat("emitter mismatch.",
            " Expected: ",  vm.toString(emitter),
            " Actual: ",    vm.toString(log.emitter)));
        }
    }

    function _matchesSelector(Vm.Log memory log, uint256 i, bytes4 selector) private pure {
        if (log.topics.length == 0) {
            Fail(i, "missing event selector (topic0).");
        }
        if (bytes4(log.topics[0]) != selector) {
            Fail(i, string.concat("selector mismatch.",
            " Expected: ",  vm.toString(selector),
            " Actual: ",    vm.toString(bytes4(log.topics[0]))));
        }
    }

    function _matchesTopics(Vm.Log memory log, uint256 i, bytes32[] memory topics) private pure {
        if (topics.length == 0) return;
        if (log.topics.length - 1 != topics.length) {
            Fail(i, string.concat("indexed topic length mismatch.",
            " Expected: ",  vm.toString(topics.length),
            " Actual: ",    vm.toString(log.topics.length - 1)));
        }
        for (uint256 j; j < topics.length; j++) {
            if (log.topics[j + 1] != topics[j]) {
                Fail(i, string.concat("topic[", vm.toString(j), "] mismatch.",
                " Expected: ",  vm.toString(topics[j]),
                " Actual: ",    vm.toString(log.topics[j + 1])));
            }
        }
    }

    function _matchesData(Vm.Log memory log, uint256 i, bytes memory data) private pure {
        if (data.length == 0) return;
        if (keccak256(log.data) != keccak256(data)) {
            Fail(i, string.concat("data mismatch.",
            " Expected: ",  vm.toString(data),
            " Actual: ",    vm.toString(log.data)));
        }
    }

    function Fail(uint256 i, string memory reason) private pure {
        if (i == SINGLE_EVENT)  revert(string.concat("Event: ",                         reason));
                                revert(string.concat("Event[", vm.toString(i), "]: ",   reason));
    }
}