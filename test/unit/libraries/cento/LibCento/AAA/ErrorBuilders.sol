// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibCentoTest} from "./Base.t.sol";

abstract contract ErrorBuilders is LibCentoTest {

    function ZeroFacetForEmptySlot() internal pure returns (Error memory) {
        return Error({
            selector: ERR_ZEROFACET_FOR_EMPTY_SLOT,
            data: NO_DATA()
        });
    }

    function RouterAsFacetForbidden() internal pure returns (Error memory) {
        return Error({
            selector: ERR_ROUTER_AS_FACET_FORBIDDEN,
            data: NO_DATA()
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