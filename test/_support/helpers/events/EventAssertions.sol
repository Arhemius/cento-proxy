// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "forge-std/Vm.sol";
import {EventBuiltins} from "./EventBuiltins.sol";
import {MultiEventAssertions} from "./MultiEventAssertions.sol";

abstract contract EventAssertions is MultiEventAssertions, EventBuiltins {

    // These objects are used in tests if you use flatten- functions

    function SKIP_EVENT() internal pure returns (Event memory) {
        return Event({
            selector: NO_SELECTOR, 
            topics:   ANY_TOPIC(), 
            data:     ANY_DATA
        });
    }

    function SKIP_SOURCED_EVENT() internal pure returns (SourcedEvent memory) {
        return SourcedEvent({
            emitter:  ANY_EMITTER,
            selector: NO_SELECTOR, 
            topics:   ANY_TOPIC(), 
            data:     ANY_DATA
        });
    }

    function SKIP_TRACE() internal pure returns (Trace memory) {
        return Trace({
            index:    0,
            selector: NO_SELECTOR, 
            topics:   ANY_TOPIC(), 
            data:     ANY_DATA
        });
    }

    function SKIP_SOURCED_TRACE() internal pure returns (SourcedTrace memory) {
        return SourcedTrace({
            emitter:  ANY_EMITTER,
            index:    0,
            selector: NO_SELECTOR, 
            topics:   ANY_TOPIC(), 
            data:     ANY_DATA
        });
    }

    function SKIP_EVENTS() internal pure returns (Events memory) {
        return Events({
            selector: NO_SELECTOR,
            topics:   EMPTY_TOPICS(),
            data:     EMPTY_DATA()
        });
    }

    function SKIP_SOURCED_EVENTS() internal pure returns (SourcedEvents memory) {
        return SourcedEvents({
            emitter:  new address[](0),
            selector: NO_SELECTOR, 
            topics:   EMPTY_TOPICS(),
            data:     EMPTY_DATA()
        });
    }

    function SKIP_TRACES() internal pure returns (Traces memory) {
        return Traces({
            indices:  new uint256[](0),
            selector: NO_SELECTOR, 
            topics:   EMPTY_TOPICS(), 
            data:     EMPTY_DATA()
        });
    }

    function SKIP_SOURCED_TRACES() internal pure returns (SourcedTraces memory) {
        return SourcedTraces({
            emitter:  new address[](0),
            indices:  new uint256[](0),
            selector: NO_SELECTOR, 
            topics:   EMPTY_TOPICS(), 
            data:     EMPTY_DATA()
        });
    }

    // ============================================================
    //                loop functions for builders 
    //               (4 functions, one per struct)
    //        usage implies you can't skip this event type
    //       for shallow structures - use flatten- functions
    //     !!! loop functions do not to accept empty arrays !!!
    //   if something in event sequence gets skipped - use Traces 
    // ============================================================

    function loop(Events[] memory specs) internal pure returns (Event[] memory out) {
        uint256 rows = specs.length;                                        checkRowsNotEmpty(rows, "Events");
        uint256 cols = max(specs[0].topics.length, specs[0].data.length);   checkColsNotEmpty(cols, "Events");
        string memory revertSource;
        out = new Event[](rows * cols);
        for (uint256 r; r < rows; r++) {
            revertSource = string.concat("Events[", vm.toString(r), "]"); 
            checkArrayLength("topics[]",  specs[r].topics.length,  cols, revertSource);
            checkArrayLength("data[]",    specs[r].data.length,    cols, revertSource);
        }
        uint256 k;
        for (uint256 c; c < cols; c++) {
            for (uint256 r; r < rows; r++) {
                revertSource = string.concat("Events[", vm.toString(r), "]"); 
                checkTopicsLength(specs[r].topics[c].length, string.concat(revertSource, "[", vm.toString(c), "]"));
                out[k++] = Event({
                    selector: specs[r].selector,
                    topics: specs[r].topics[c],
                    data: specs[r].data[c]
                });
            }
        }
    }

    function loop(SourcedEvents[] memory specs) internal pure returns (SourcedEvent[] memory out) {
        uint256 rows = specs.length;                                        checkRowsNotEmpty(rows, "SourcedEvents");
        uint256 cols = max(specs[0].topics.length, specs[0].data.length);   checkColsNotEmpty(cols, "SourcedEvents");
        string memory revertSource; 
        out = new SourcedEvent[](rows * cols);
        uint256 k;
        for (uint256 r; r < rows; r++) {
            revertSource = string.concat("SourcedEvents[", vm.toString(r), "]");
            checkArrayLength("emitter[]", specs[r].emitter.length, cols, revertSource);
            checkArrayLength("topics[]",  specs[r].topics.length,  cols, revertSource);
            checkArrayLength("data[]",    specs[r].data.length,    cols, revertSource);
        }
        for (uint256 c; c < cols; c++) {
            for (uint256 r; r < rows; r++) {
                revertSource = string.concat("SourcedEvents[", vm.toString(r), "]");
                checkTopicsLength(specs[r].topics[c].length, string.concat(revertSource, "[", vm.toString(c), "]"));
                out[k++] = SourcedEvent({
                    emitter: specs[r].emitter[c],
                    selector: specs[r].selector,
                    topics: specs[r].topics[c],
                    data: specs[r].data[c]
                });
            }
        }
    }

    function loop(Traces[] memory specs) internal pure returns (Trace[] memory out) {
        uint256 rows = specs.length;                                        checkRowsNotEmpty(rows, "Traces");
        uint256 cols = max(specs[0].topics.length, specs[0].data.length);   checkColsNotEmpty(cols, "Traces");
        string memory revertSource;
        uint256 skips;
        for (uint256 r; r < rows; r++) {
            revertSource = string.concat("Traces[", vm.toString(r), "]"); 
            checkArrayLength("indices[]", specs[r].indices.length, cols, revertSource);
            checkArrayLength("topics[]",  specs[r].topics.length,  cols, revertSource);
            checkArrayLength("data[]",    specs[r].data.length,    cols, revertSource);
            for (uint256 c; c < cols; c++) {
                if (specs[r].indices[c] == NO_EVENT) skips++;
            }
        }
        out = new Trace[](rows * cols - skips);
        uint256 k;
        for (uint256 c; c < cols; c++) {
            for (uint256 r; r < rows; r++) {
                if(specs[r].indices[c] == NO_EVENT) continue;
                revertSource = string.concat("Traces[", vm.toString(r), "]"); 
                checkTopicsLength(specs[r].topics[c].length, string.concat(revertSource, "[", vm.toString(c), "]"));
                out[k++] = Trace({
                    index: specs[r].indices[c],
                    selector: specs[r].selector,
                    topics: specs[r].topics[c],
                    data: specs[r].data[c]
                });
            }
        }
    }

    function loop(SourcedTraces[] memory specs) internal pure returns (SourcedTrace[] memory out) {
        uint256 rows = specs.length;                                        checkRowsNotEmpty(rows, "SourcedTraces");
        uint256 cols = max(specs[0].topics.length, specs[0].data.length);   checkColsNotEmpty(cols, "SourcedTraces");
        string memory revertSource;
        uint256 skips; 
        for (uint256 r; r < rows; r++) {
            revertSource = string.concat("SourcedTraces[", vm.toString(r), "]"); 
            checkArrayLength("emitter[]", specs[r].emitter.length, cols, revertSource);
            checkArrayLength("indices[]", specs[r].indices.length, cols, revertSource);
            checkArrayLength("topics[]",  specs[r].topics.length,  cols, revertSource);
            checkArrayLength("data[]",    specs[r].data.length,    cols, revertSource);
            for (uint256 c; c < cols; c++) {
                if (specs[r].indices[c] == NO_EVENT) skips++;
            }
        }
        out = new SourcedTrace[](rows * cols - skips);
        uint256 k;
        for (uint256 c; c < cols; c++) {
            for (uint256 r; r < rows; r++) {
                if(specs[r].indices[c] == NO_EVENT) continue;
                revertSource = string.concat("SourcedTraces[", vm.toString(r), "]");
                checkTopicsLength(specs[r].topics[c].length, string.concat(revertSource, "[", vm.toString(c), "]"));
                out[k++] = SourcedTrace({
                    emitter: specs[r].emitter[c],
                    index: specs[r].indices[c],
                    selector: specs[r].selector,
                    topics: specs[r].topics[c],
                    data: specs[r].data[c]
                });
            }
        }
    }

    // ============== Helper Functions ==============

    function checkArrayLength(string memory comparisonObject, uint256 actual, uint256 expected, string memory revertSource) 
        private pure {
        require(actual == expected,  string.concat(
            revertSource, ": ",
            comparisonObject, " length mismatch.", 
            " Expected: ",  vm.toString(expected),
            " Actual: ",    vm.toString(actual)
        ));
    }

    function checkTopicsLength(uint256 topicsLength, string memory revertSource) private pure {
        require(topicsLength <= 3, string.concat(revertSource, ": exceeded topic length."));
    }

    function checkRowsNotEmpty(uint256 rows, string memory revertSource) private pure {
        require(rows != 0, string.concat(revertSource, ": expected at least one event specification."));
    }

    function checkColsNotEmpty(uint256 cols, string memory revertSource) private pure {
        require(cols != 0, string.concat(revertSource, ": each event specification must contain at least one event."));
    }
        
    function max(uint256 a, uint256 b) private pure returns (uint256) {
        return a >= b ? a : b;
    }

    // ============================================================
    //              flatten- functions for builders 
    //          (8 functions, one per struct (Event(s)))
    //    do not support skips whithin loop types - use Traces
    // ============================================================

    function flatten(Event memory spec) internal pure returns (Event[] memory out) {
        if (spec.selector == NO_SELECTOR)   return new Event[](0);
                                            return EventArr_(abi.encode(spec));
    }

    function flatten(SourcedEvent memory spec) internal pure returns (SourcedEvent[] memory out) {
        if (spec.selector == NO_SELECTOR)   return new SourcedEvent[](0);
                                            return SourcedEventArr_(abi.encode(spec));
    }

    function flatten(Trace memory spec) internal pure returns (Trace[] memory out) {
        if (spec.selector == NO_SELECTOR)   return new Trace[](0);
                                            return TraceArr_(abi.encode(spec));
    }

    function flatten(SourcedTrace memory spec) internal pure returns (SourcedTrace[] memory out) {
        if (spec.selector == NO_SELECTOR)   return new SourcedTrace[](0);
                                            return SourcedTraceArr_(abi.encode(spec));
    }

    function flattenSequence(Events[] memory specs) internal pure returns (Event[] memory out){
        uint256 count; uint256 k;
        for (uint256 i; i < specs.length; ++i) {
            if (specs[i].selector != NO_SELECTOR) ++count;
        }
        if (count == 0) return new Event[](0);
        Events[] memory filtered = new Events[](count);
        for (uint256 i; i < specs.length; ++i) {
            if (specs[i].selector != NO_SELECTOR) filtered[k++] = specs[i];
        }
        return loop(filtered);
    }

    function flattenSequence(SourcedEvents[] memory specs) internal pure returns (SourcedEvent[] memory out){
        uint256 count; uint256 k;
        for (uint256 i; i < specs.length; ++i) {
            if (specs[i].selector != NO_SELECTOR) ++count;
        }
        if (count == 0) return new SourcedEvent[](0);
        SourcedEvents[] memory filtered = new SourcedEvents[](count);
        for (uint256 i; i < specs.length; ++i) {
            if (specs[i].selector != NO_SELECTOR) filtered[k++] = specs[i];
        }
        return loop(filtered);
    }

    function flattenSequence(Traces[] memory specs) internal pure returns (Trace[] memory out){
        uint256 count; uint256 k;
        for (uint256 i; i < specs.length; ++i) {
            if (specs[i].selector != NO_SELECTOR) ++count;
        }
        if (count == 0) return new Trace[](0);
        Traces[] memory filtered = new Traces[](count);
        for (uint256 i; i < specs.length; ++i) {
            if (specs[i].selector != NO_SELECTOR) filtered[k++] = specs[i];
        }
        return loop(filtered);
    }

    function flattenSequence(SourcedTraces[] memory specs) internal pure returns (SourcedTrace[] memory out){
        uint256 count; uint256 k;
        for (uint256 i; i < specs.length; ++i) {
            if (specs[i].selector != NO_SELECTOR) ++count;
        }
        if (count == 0) return new SourcedTrace[](0);
        SourcedTraces[] memory filtered = new SourcedTraces[](count);
        for (uint256 i; i < specs.length; ++i) {
            if (specs[i].selector != NO_SELECTOR) filtered[k++] = specs[i];
        }
        return loop(filtered);
    }
}