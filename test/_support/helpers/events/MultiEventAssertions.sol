// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "forge-std/Vm.sol";
import {SingleEventAssertions} from "./SingleEventAssertions.sol";

abstract contract MultiEventAssertions is SingleEventAssertions {

    function then_MatchesEvents(Event[] memory events) internal view {
        Vm.Log[] memory logs = getLogs();
        if (logs.length != events.length) {
            Fail_LengthMismatch(events.length, logs.length);
        }
        for (uint256 i; i < events.length; ++i) {
            then_MatchesEventAt(logs[i], i, events[i]);
        }
    }

    // we will use this one for atomicUpdate
    function then_MatchesEvents(address emitter, Event[] memory events) internal view {
        Vm.Log[] memory logs = getLogs();
        if (logs.length != events.length) {
            Fail_LengthMismatch(events.length, logs.length);
        }
        for (uint256 i; i < events.length; ++i) {
            then_MatchesEventAt(logs[i], i, emitter, events[i]);
        }
    }

    function then_MatchesEvents(SourcedEvent[] memory events) internal view {
        Vm.Log[] memory logs = getLogs();
        if (logs.length != events.length) {
            Fail_LengthMismatch(events.length, logs.length);
        }
        for (uint256 i; i < events.length; ++i) {
            then_MatchesEventAt(logs[i], i, events[i].emitter, Event({
                selector: events[i].selector,
                topics: events[i].topics,
                data: events[i].data
            }));
        }
    }

    function then_MatchesTrace(Trace[] memory trace) internal view {
        Vm.Log[] memory logs = getLogs();
        for (uint256 i; i < trace.length; ++i) {
            if (trace[i].index == NO_EVENT) continue;
            if (trace[i].index >= logs.length) Fail_OOB(i);
            then_MatchesEventAt(logs[trace[i].index], trace[i].index, Event({
                selector: trace[i].selector,
                topics: trace[i].topics,
                data: trace[i].data
            }));
        }
    }

    function then_MatchesTrace(address emitter, Trace[] memory trace) internal view {
        Vm.Log[] memory logs = getLogs();
        for (uint256 i; i < trace.length; ++i) {
            if (trace[i].index == NO_EVENT) continue;
            if (trace[i].index >= logs.length) Fail_OOB(i);
            then_MatchesEventAt(logs[trace[i].index], trace[i].index, emitter, Event({
                selector: trace[i].selector,
                topics: trace[i].topics,
                data: trace[i].data
            }));
        }
    }

    function then_MatchesTrace(SourcedTrace[] memory trace) internal view {
        Vm.Log[] memory logs = getLogs();
        for (uint256 i; i < trace.length; ++i) {
            if (trace[i].index == NO_EVENT) continue;
            if (trace[i].index >= logs.length) Fail_OOB(i);
            then_MatchesEventAt(logs[trace[i].index], trace[i].index, trace[i].emitter, Event({
                selector: trace[i].selector,
                topics: trace[i].topics,
                data: trace[i].data
            }));
        }
    }

    function Fail_LengthMismatch(uint256 eventsLength, uint256 logsLength) private pure {
        revert(string.concat(
            "Event sequence length mismatch:  expected ",   vm.toString(eventsLength),
                                                ", got ",   vm.toString(logsLength)
        ));
    }

    function Fail_OOB(uint256 index) private pure {
        revert(string.concat(
            "Trace[", vm.toString(index), "]: log index out of bounds"
        ));
    }
}

// further checks are about checking that some event sequence exists and repeats n times
// and we should later add getters like getFirstEventEmissionIndex, getFirstEventSequenceEmissionIndex, and stuff like that
// we should be able to check only events we care about and not care about other events in-between, or some events whithin the
// sequence. For example, we may check sequence existance, where it starts with these events, ends with these, and so on.
// but that's a much much later concern, if I get funded
// we can also make some special check where we only validate the order