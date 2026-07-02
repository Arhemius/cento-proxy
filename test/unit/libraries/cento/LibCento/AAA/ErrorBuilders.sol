// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {ILibCento} from "support/interfaces/ILibCento.sol";
import {ErrorContext} from "support/helpers/errors/ErrorContext.sol";

abstract contract ErrorBuilders is ErrorContext {

    bytes4 constant ERR_IS_7702_EOA                 = ILibCento.Is7702EOA.selector;
    bytes4 constant ERR_NO_CODE_OR_EOA              = ILibCento.NoCodeOrEOA.selector;
    bytes4 constant ERR_NOT_CONTRACT_OWNER          = ILibCento.NotContractOwner.selector;
    bytes4 constant ERR_ZEROFACET_FOR_EMPTY_SLOT    = ILibCento.ZeroFacetForEmptySlot.selector;
    bytes4 constant ERR_STORAGE_MIGRATION_FAILED    = ILibCento.StorageMigrationFailed.selector;
    bytes4 constant ERR_ROUTER_AS_FACET_FORBIDDEN   = ILibCento.RouterAsFacetForbidden.selector;

    function ZeroFacetForEmptySlot() internal pure returns (Error memory) {
        return Error({
            selector: ERR_ZEROFACET_FOR_EMPTY_SLOT,
            data: ""
        });
    }

    function RouterAsFacetForbidden() internal pure returns (Error memory) {
        return Error({
            selector: ERR_ROUTER_AS_FACET_FORBIDDEN,
            data: ""
        });
    }

    function NotContractOwner(address caller) internal pure returns (Error memory) {
        return Error({
            selector: ERR_NOT_CONTRACT_OWNER,
            data: abi.encode(caller)
        });
    }

    function NoCodeOrEOA(address target) internal pure returns (Error memory) {
        return Error({
            selector: ERR_NO_CODE_OR_EOA,
            data: abi.encode(target)
        });
    }

    function Is7702EOA(address account) internal pure returns (Error memory) {
        return Error({
            selector: ERR_IS_7702_EOA,
            data: abi.encode(account)
        });
    }

    function StorageMigrationFailed(address migrator) internal pure returns (Error memory) {
        return Error({
            selector: ERR_STORAGE_MIGRATION_FAILED,
            data: abi.encode(migrator)
        });
    }
}