// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/etl/FacetArray/FacetArray.sol";
import "support/etl/BytesNArray/Bytes32Array.sol";
import {LibCentoTest} from "./Base.t.sol";
import {EventAssertions} from "support/helpers/EventAssertions.sol";
import {Facet} from "src/structs/Facet.sol";

abstract contract EventBuilders is EventAssertions, LibCentoTest {

    function FacetAdded(uint8 index, address facet) internal pure returns (Event memory out) {
        out = Event({
            selector: EVT_FACET_ADDED,
            topics: W_(abi.encode(index)),
            data: abi.encode(facet)
        });
    }

    function FacetUpdated(uint8 index, address facet, address oldFacet) internal pure returns (Event memory out) {
        out = Event({
            selector: EVT_FACET_UPDATED,
            topics: W_(abi.encode(index)),
            data: abi.encode(oldFacet, facet)
        });
    }

    function FacetRemoved(uint8 index, address oldFacet) internal pure returns (Event memory out) {
        out = Event({
            selector: EVT_FACET_REMOVED,
            topics: W_(abi.encode(index)),
            data: abi.encode(oldFacet)
        });
    }

    function InterfaceAdded(bytes4 selector) internal pure returns (DataEvent memory out) {
        out = DataEvent({
            selector: EVT_INTERFACE_ADDED,
            data: abi.encode(selector)
        });
    }

    function InterfaceRemoved(bytes4 selector) internal pure returns (DataEvent memory out) {
        out = DataEvent({
            selector: EVT_INTERFACE_REMOVED,
            data: abi.encode(selector)
        });
    }

    function OwnershipTransferred(address previousOwner, address newOwner) internal pure returns (IndexedEvent memory out) {
        out = IndexedEvent({ 
            selector: EVT_OWNERSHIP_TRANSFERRED, 
            topics: W_(abi.encode(previousOwner, newOwner)) 
        });
    }

    function StorageMigrationSucceeded(address migrator) internal pure returns (Event memory out) {
        out = Event({
            selector: EVT_STORAGE_MIGRATION_SUCCEEDED,
            topics: W_(abi.encode(migrator)),
            data: ANY_DATA
        });
    }


    function FacetsAdded(Facet_[] memory addF) internal pure returns (Event[] memory out) {
        out = flattenSequence(EventsArr_(abi.encode($FacetsAdded(addF))));
    }

    function FacetsUpdated(Facet_[] memory updF, address[] memory oldFacets) internal pure returns (Event[] memory out) {
        out = flattenSequence(EventsArr_(abi.encode($FacetsUpdated(updF, oldFacets))));
    }
        
    function FacetsRemoved(Facet_[] memory remF, address[] memory oldFacets) internal pure returns (Event[] memory out) {
        out = flattenSequence(EventsArr_(abi.encode($FacetsRemoved(remF, oldFacets))));
    }

    function InterfacesAdded(bytes4[] memory addI) internal pure returns (Event[] memory out) {
        out = flattenSequence(EventsArr_(abi.encode($InterfacesAdded(addI))));
    }

    function InterfacesRemoved(bytes4[] memory remI) internal pure returns (Event[] memory out) {
        out = flattenSequence(EventsArr_(abi.encode($InterfacesRemoved(remI))));
    }


    function AtomicUpdate(
        Events memory removedFacets,
        Events memory updatedFacets,
        Events memory addedFacets,
        Events memory interfacesAdded,
        Events memory interfacesRemoved,
        Event  memory storageMigrationSucceeded
    ) internal pure returns (Event[] memory out) {
        Event[] memory a = flattenSequence(EventsArr_(abi.encode(removedFacets)));
        Event[] memory b = flattenSequence(EventsArr_(abi.encode(updatedFacets)));
        Event[] memory c = flattenSequence(EventsArr_(abi.encode(addedFacets)));
        Event[] memory d = flattenSequence(EventsArr_(abi.encode(interfacesAdded)));
        Event[] memory e = flattenSequence(EventsArr_(abi.encode(interfacesRemoved)));
        Event[] memory f = flatten                              (storageMigrationSucceeded);
        
        uint256 len = a.length + b.length + c.length + d.length + e.length + f.length;
        out = new Event[](len); uint256 k;
        for (uint256 i; i < a.length; i++) out[k++] = a[i];
        for (uint256 i; i < b.length; i++) out[k++] = b[i];
        for (uint256 i; i < c.length; i++) out[k++] = c[i];
        for (uint256 i; i < d.length; i++) out[k++] = d[i];
        for (uint256 i; i < e.length; i++) out[k++] = e[i];
        for (uint256 i; i < f.length; i++) out[k++] = f[i];
    }
    
    function $FacetsRemoved(Facet_[] memory remF, address[] memory oldFacets) internal pure returns (Events memory out) {
        require(remF.length != 0 && oldFacets.length != 0, "FacetsRemoved: arrays should not be empty");
        require(remF.length == oldFacets.length, "FacetsRemoved: arrays should have identical length");
        bytes32[][] memory topics = Topics_(toBytes32Array(Facets({data: remF}).indices()));
        bytes[]     memory data = new bytes[](remF.length);
        for(uint256 i; i < data.length; ++i){
            data[i] = abi.encode(oldFacets[i]);
        } out = Events({
            selector: EVT_FACET_REMOVED,
            topics: topics,
            data: data
        });
    }

    function $FacetsUpdated(Facet_[] memory updF, address[] memory oldFacets) internal pure returns (Events memory out) {
        require(updF.length != 0 && oldFacets.length != 0, "FacetsUpdated: arrays should not be empty");
        require(updF.length == oldFacets.length, "FacetsUpdated: arrays should have identical length");
        Facets      memory $facets = Facets({data: updF});
        bytes32[][] memory topics = Topics_(toBytes32Array($facets.indices()));
        address[]   memory facets = $facets.facets();
        bytes[]     memory data = new bytes[](updF.length);
        for(uint256 i; i < data.length; ++i){
            data[i] = abi.encode(oldFacets[i], facets[i]);
        } out = Events({
            selector: EVT_FACET_UPDATED,
            topics: topics,
            data: data
        });
    }

    function $FacetsAdded(Facet_[] memory addF) internal pure returns (Events memory out) {
        require(addF.length != 0, "FacetsAdded: arrays should not be empty");
        Facets      memory $facets = Facets({data: addF});
        bytes32[][] memory topics = Topics_(toBytes32Array($facets.indices()));
        address[]   memory facets = $facets.facets();
        bytes[]     memory data = new bytes[](addF.length);
        for(uint256 i; i < data.length; ++i){
            data[i] = abi.encode(facets[i]);
        } out = Events({
            selector: EVT_FACET_ADDED,
            topics: topics,
            data: data
        });
    }

    function $InterfacesAdded(bytes4[] memory addI) internal pure returns (Events memory out) {
        require(addI.length != 0, "InterfacesAdded: arrays should not be empty");
        bytes[] memory data = new bytes[](addI.length);
        for(uint256 i; i < data.length; ++i){
            data[i] = abi.encode(addI[i]);
        } out = Events({
            selector: EVT_INTERFACE_ADDED,
            topics: EMPTY_TOPICS(data.length),
            data: data
        });
    }

    function $InterfacesRemoved(bytes4[] memory remI) internal pure returns (Events memory out) {
        require(remI.length != 0, "InterfacesRemoved: arrays should not be empty");
        bytes[] memory data = new bytes[](remI.length);
        for(uint256 i; i < data.length; ++i){
            data[i] = abi.encode(remI[i]);
        } out = Events({
            selector: EVT_INTERFACE_REMOVED,
            topics: EMPTY_TOPICS(data.length),
            data: data
        });
    }
}


// How the builder should be built if no sequence builder is present:

// function FacetsRemoved(Facet_[] memory remF, address[] memory oldFacets) internal pure returns (Event[] memory out) {
//     require(remF.length != 0 && oldFacets.length != 0, "FacetsRemoved: arrays should not be empty");
//     require(remF.length == oldFacets.length, "FacetsRemoved: arrays should have identical length");
//     out = new Event[](remF.length);
//     for(uint256 i; i < out.length; ++i){
//         out[i] = Event({
//             selector: EVT_FACET_REMOVED,
//             topics: Topic_(bytes32(remF[i].index)),
//             data: abi.encode(oldFacets[i])
//         });
//     }
// }