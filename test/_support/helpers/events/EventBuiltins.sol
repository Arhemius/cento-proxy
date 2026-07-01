// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {EventStructs} from "./EventStructs.sol";

abstract contract EventBuiltins is EventStructs {

    function EventArr_(bytes memory data) internal pure returns (Event[] memory) {
        return abi.decode(Arr_(abi.encode(data)), (Event[]));
    }

    function SourcedEventArr_(bytes memory data) internal pure returns (SourcedEvent[] memory) {
        return abi.decode(Arr_(abi.encode(data)), (SourcedEvent[]));
    }

    function TraceArr_(bytes memory data) internal pure returns (Trace[] memory) {
        return abi.decode(Arr_(abi.encode(data)), (Trace[]));
    }

    function SourcedTraceArr_(bytes memory data) internal pure returns (SourcedTrace[] memory) {
        return abi.decode(Arr_(abi.encode(data)), (SourcedTrace[]));
    }


    function EventsArr_(bytes memory data) internal pure returns (Events[] memory) {
        return abi.decode(Arr_(abi.encode(data)), (Events[]));
    }

    function SourcedEventsArr_(bytes memory data) internal pure returns (SourcedEvents[] memory) {
        return abi.decode(Arr_(abi.encode(data)), (SourcedEvents[]));
    }

    function TracesArr_(bytes memory data) internal pure returns (Traces[] memory) {
        return abi.decode(Arr_(abi.encode(data)), (Traces[]));
    }

    function SourcedTracesArr_(bytes memory data) internal pure returns (SourcedTraces[] memory) {
        return abi.decode(Arr_(abi.encode(data)), (SourcedTraces[]));
    }

    // works only for structs with dynamic fields
    function Arr_(bytes memory data) private pure returns (bytes memory) {
        assembly {
            if lt(mload(data), 0x60) { revert(0, 0) }
            let innerLen := mload(add(data, 0x40))
            let firstOffset := mload(add(data, 0x60))
            if or(
                iszero(firstOffset), 
                or( mod(firstOffset, 0x20), 
                    iszero(lt(firstOffset, innerLen)))
            ) { revert(0, 0) }
            mstore(add(data, 0x40), div(firstOffset, 0x20))
        }
        return data;
    }

    function EMPTY_TOPICS() internal pure returns (bytes32[][] memory out) {
        out = new bytes32[][](0);
    }

    function EMPTY_TOPICS(uint256 n) internal pure returns (bytes32[][] memory out) {
        out = new bytes32[][](n);
        for (uint256 i; i < n; ++i) {
            out[i] = new bytes32[](0);
        }
    }

    function Topics_(bytes32[] memory t0) internal pure returns (bytes32[][] memory out) {
        out = new bytes32[][](t0.length);
        for (uint256 i; i < t0.length; ++i) {
            out[i] = new bytes32[](1);
            out[i][0] = t0[i];
        }
    }

    function Topics_(bytes32[] memory t0, bytes32[] memory t1) internal pure returns (bytes32[][] memory out) {
        require(t0.length == t1.length, "Topics_: array length mismatch");
        out = new bytes32[][](t0.length);
        for (uint256 i; i < t0.length; ++i) {
            out[i] = new bytes32[](2);
            out[i][0] = t0[i];
            out[i][1] = t1[i];
        }
    }

    function Topics_(bytes32[] memory t0, bytes32[] memory t1, bytes32[] memory t2) internal pure returns (bytes32[][] memory out) {
        require(t0.length == t1.length && t1.length == t2.length, "Topics_: array length mismatch");
        out = new bytes32[][](t0.length);
        for (uint256 i; i < t0.length; ++i) {
            out[i] = new bytes32[](3);
            out[i][0] = t0[i];
            out[i][1] = t1[i];
            out[i][2] = t2[i];
        }
    }

    function EMPTY_TOPIC() internal pure returns (bytes32[] memory out) {
        out = new bytes32[](0);
    }

    function Topic_(bytes32 t0) internal pure returns (bytes32[] memory out) {
        out = new bytes32[](1);
        out[0] = t0;
    }

    function Topic_(bytes32 t0, bytes32 t1) internal pure returns (bytes32[] memory out) {
        out = new bytes32[](2);
        out[0] = t0;
        out[1] = t1;
    }

    function Topic_(bytes32 t0, bytes32 t1, bytes32 t2) internal pure returns (bytes32[] memory out) {
        out = new bytes32[](3);
        out[0] = t0;
        out[1] = t1;
        out[2] = t2;
    }

    function EMPTY_DATA(uint256 n) internal pure returns (bytes[] memory out) {
        out = new bytes[](n);
        for (uint256 i; i < n; ++i) {
            out[i] = "";
        }
    }

    function EMPTY_DATA() internal pure returns (bytes[] memory out) {
        out = new bytes[](0);
    }
}