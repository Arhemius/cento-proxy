// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/builtins/Builtins.sol";
import {Facet} from "cento/structs/Facet.sol";
import {IFacetManager} from "src/cento/interfaces/IFacetManager.sol";
import {EventAssertions} from "support/helpers/events/EventAssertions.sol";

abstract contract EventBuilders is EventAssertions {

    bytes4 constant EVT_ATOMIC_UPDATE = bytes4(IFacetManager.AtomicUpdate.selector);

    function AtomicUpdate(
        Facet[]  memory setF, 
        bytes4[] memory addI, bytes4[] memory remI, 
        address migrator, bytes memory _calldata) 
        internal pure returns (Event memory out) {
        out = Event({ 
            selector: EVT_ATOMIC_UPDATE, 
            topics: EMPTY_TOPIC(),
            data: abi.encode(setF, addI, remI, migrator, _calldata) 
        });
    }

}