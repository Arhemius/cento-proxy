// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "forge-std/Vm.sol";
import {EventStructs} from "./EventStructs.sol";
import {EventAssertionsCore} from "./EventAssertionsCore.sol";

abstract contract SingleEventAssertions is EventAssertionsCore, EventStructs {

    // ===================================================================
    // 16 public entrypoints for single event handling; Indexed invariants
    // ===================================================================

    // we can pass a certain log at specific index from multiple

    function then_MatchesEventAt(Vm.Log memory log, uint256 index, EmptyEvent memory e) internal pure {
        _match(log, index, ANY_EMITTER, e.selector, ANY_TOPIC(), ANY_DATA);
    }

    function then_MatchesEventAt(Vm.Log memory log, uint256 index, DataEvent memory e) internal pure {
        _match(log, index, ANY_EMITTER, e.selector, ANY_TOPIC(), e.data);
    }

    function then_MatchesEventAt(Vm.Log memory log, uint256 index, IndexedEvent memory e) internal pure {
        _match(log, index, ANY_EMITTER, e.selector, e.topics, ANY_DATA);
    }

    function then_MatchesEventAt(Vm.Log memory log, uint256 index, Event memory e) internal pure {
        _match(log, index, ANY_EMITTER, e.selector, e.topics, e.data);
    }

    // ---------------- emitter variants ----------------

    // we can also specify emitter for precision

    function then_MatchesEventAt(Vm.Log memory log, uint256 index, address emitter, EmptyEvent memory e) internal pure {
        _match(log, index, emitter, e.selector, ANY_TOPIC(), ANY_DATA);
    }

    function then_MatchesEventAt(Vm.Log memory log, uint256 index, address emitter, DataEvent memory e) internal pure {
        _match(log, index, emitter, e.selector, ANY_TOPIC(), e.data);
    }

    function then_MatchesEventAt(Vm.Log memory log, uint256 index, address emitter, IndexedEvent memory e) internal pure {
        _match(log, index, emitter, e.selector, e.topics, ANY_DATA);
    }

    function then_MatchesEventAt(Vm.Log memory log, uint256 index, address emitter, Event memory e) internal pure {
        _match(log, index, emitter, e.selector, e.topics, e.data);
    }

    // ============ single event invariants =============

    // we can check the case where we expect only one emission

    function then_MatchesEvent(EmptyEvent memory e) internal view {
        Vm.Log memory log = getLog();
        then_MatchesEventAt(log, SINGLE_EVENT, e);
    }

    function then_MatchesEvent(DataEvent memory e) internal view {
        Vm.Log memory log = getLog();
        then_MatchesEventAt(log, SINGLE_EVENT, e);
    }

    function then_MatchesEvent(IndexedEvent memory e) internal view {
        Vm.Log memory log = getLog();
        then_MatchesEventAt(log, SINGLE_EVENT, e);
    }

    function then_MatchesEvent(Event memory e) internal view {
        Vm.Log memory log = getLog();
        then_MatchesEventAt(log, SINGLE_EVENT, e);
    }

    // ---------------- emitter variants ----------------

    // and also specify emitter for precision

    function then_MatchesEvent(address emitter, EmptyEvent memory e) internal view {
        Vm.Log memory log = getLog();
        then_MatchesEventAt(log, SINGLE_EVENT, emitter, e);
    }

    function then_MatchesEvent(address emitter, DataEvent memory e) internal view {
        Vm.Log memory log = getLog();
        then_MatchesEventAt(log, SINGLE_EVENT, emitter, e);
    }

    function then_MatchesEvent(address emitter, IndexedEvent memory e) internal view {
        Vm.Log memory log = getLog();
        then_MatchesEventAt(log, SINGLE_EVENT, emitter, e);
    }

    function then_MatchesEvent(address emitter, Event memory e) internal view {
        Vm.Log memory log = getLog();
        then_MatchesEventAt(log, SINGLE_EVENT, emitter, e);
    }

    // =======================================================================
    // this function is applicable for both single- and multi-event assertions
    // =======================================================================

    function then_NoEvents() internal view {
        Vm.Log[] memory logs = getLogs();
        if (logs.length != 0) revert(string.concat(
            "Expected no events, got ", vm.toString(logs.length)
        ));
    }
}

// then_MatchesEventAt(logs[i], i, address(lc), IndexedEvent({
//     selector: EVT_OWNERSHIP_TRANSFERRED,
//     topics:   W_(abi.encode(previousOwner, newOwner))
// }));

// recordLogs(); when_setContractOwner(owner); 
// then_MatchesEvent(address(lc), IndexedEvent({ 
//     selector: EVT_OWNERSHIP_TRANSFERRED, 
//     topics: W_(abi.encode(previousOwner, newOwner)) 
// }));

// recordLogs(); when_setContractOwner(owner); 
// then_MatchesEvent(IndexedEvent({ 
//     selector: EVT_OWNERSHIP_TRANSFERRED, 
//     topics: W_(abi.encode(previousOwner, newOwner)) 
// }));

// when_setContractOwner(owner); 
// then_MatchesEvent(IndexedEvent({ 
//     selector: lc.OwnershipTransferred.selector, 
//     topics: W_(abi.encode(previousOwner, newOwner)) 
// }));

// data: abi.encode(previousOwner, newOwner) - no W_ needed, since it's just bytes memory

// recordLogs(); when_setContractOwner(owner); 
// then_MatchesEvent(address(lc), ownershipTransferred(previousOwner, newOwner));

// recordLogs(); when_setContractOwner(owner); 
// then_MatchesEvent(ownershipTransferred(previousOwner, newOwner));

// when_setContractOwner(owner); 
// then_MatchesEvent(ownershipTransferred(previousOwner, newOwner));