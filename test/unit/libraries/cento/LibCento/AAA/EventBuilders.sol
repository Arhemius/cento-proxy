// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/builtins/Builtins.sol";
import {ILibCento} from "support/interfaces/ILibCento.sol";
import {EventAssertions} from "support/helpers/events/EventAssertions.sol";

abstract contract EventBuilders is EventAssertions {

    bytes4 constant EVT_OWNERSHIP_TRANSFERRED       = bytes4(ILibCento.OwnershipTransferred.selector);
    bytes4 constant EVT_STORAGE_MIGRATION_SUCCEEDED = bytes4(ILibCento.StorageMigrationSucceeded.selector);

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

}