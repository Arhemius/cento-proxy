// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {bitmap256} from "cento/libraries/LibBitmap.sol";
import {LibCentoHarness} from "support/harnesses/LibCentoHarness.sol";
import {ErrorContext} from "support/helpers/errors/ErrorContext.sol";
import {ValidContract} from "./ValidContract.sol";

contract StorageMigrator is ValidContract {

    bytes32 public constant TEST_SLOT = keccak256("LibCento.Migrator.testSlot");

    error MigrationError();

    function writeValue(bytes memory data) external {
        uint256 value = abi.decode(data, (uint256));
        bytes32 slot = TEST_SLOT;
        assembly {
            sstore(slot, value)
        }
    }

    function observeBitmap() external {
        (bool ok, bytes memory ret) = address(this).staticcall(
            abi.encodeWithSelector(LibCentoHarness.bitmap.selector));
        require(ok, "Storage Migrator: staticcall failed");
        bitmap256 bitmap = abi.decode(ret, (bitmap256));
        bytes32 slot = TEST_SLOT;
        assembly {
            sstore(slot, bitmap)
        }
    }

    function revertCustom() external pure {
        revert MigrationError();
    }

    function revertError() external pure {
        revert("Migration failed");
    }

    function revertPanic() external pure {
        assert(false);
    }

    function revertEmpty() external pure {
        assembly { revert(0, 0) }
    }
}



abstract contract MigratorFactory is ErrorContext {

    bytes4 constant OBSERVE_BITMAP  = StorageMigrator.observeBitmap.selector;
    bytes4 constant WRITE_VALUE     = StorageMigrator.writeValue.selector;
    bytes4 constant REVERT_CUSTOM   = StorageMigrator.revertCustom.selector;
    bytes4 constant REVERT_ERROR    = StorageMigrator.revertError.selector;
    bytes4 constant REVERT_PANIC    = StorageMigrator.revertPanic.selector;
    bytes4 constant REVERT_EMPTY    = StorageMigrator.revertEmpty.selector;

    StorageMigrator internal Migrator;
    address  internal migrator;

    constructor() {
        Migrator = new StorageMigrator();
        migrator = address(Migrator);
    }

    function MigrationError() internal pure returns (Error memory) {
        return Error({
            selector: StorageMigrator.MigrationError.selector,
            data: ""
        });
    }
}