// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

abstract contract EventStructs {

    // single event handling structs

    struct EmptyEvent {
        bytes4 selector;
    }

    struct DataEvent {
        bytes4 selector;
        bytes data;
    }

    struct IndexedEvent {
        bytes4 selector;
        bytes32[] topics;
    }

    // this struct is used both by context above and context below

    struct Event {
        bytes4 selector;
        bytes32[] topics;
        bytes data;
    }

    // what builder functions produce for event sequence case

    struct SourcedEvent {
        address emitter;
        bytes4 selector;
        bytes32[] topics;
        bytes data;
    }

    struct Trace {
        uint256 index;
        bytes4 selector;
        bytes32[] topics;
        bytes data;
    }

    struct SourcedTrace {
        address emitter;
        uint256 index;
        bytes4 selector;
        bytes32[] topics;
        bytes data;
    }

    // what loop functions work with (arrays of ... elements) and what builder functions they call

    // we will use this one for atomicUpdate
    struct Events {
        bytes4 selector;
        bytes32[][] topics;
        bytes[] data;
    }

    struct SourcedEvents {
        bytes4 selector;
        address[] emitter;
        bytes32[][] topics;
        bytes[] data;
    }

    struct Traces {
        bytes4 selector;
        uint256[] indices;
        bytes32[][] topics;
        bytes[] data;
    }

    struct SourcedTraces {
        bytes4 selector;
        address[] emitter;
        uint256[] indices;
        bytes32[][] topics;
        bytes[] data;
    }
}