// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract StorageMigrator {

    bytes32 internal constant TEST_SLOT = keccak256("test.slot");

    error MigrationError(uint256 value);

    function writeValue(bytes memory data) external {
        uint256 value = abi.decode(data, (uint256));
        bytes32 slot = TEST_SLOT;
        assembly {
            sstore(slot, value)
        }
    }

    function revertCustom(uint256 value) external pure {
        revert MigrationError(value);
    }

    function revertString() external pure {
        revert("Migration failed");
    }

    function revertEmpty() external pure {
        assembly {
            revert(0, 0)
        }
    }
}



abstract contract MigratorFactory {

    bytes4 constant WRITE_VALUE   = StorageMigrator.writeValue.selector;
    bytes4 constant REVERT_CUSTOM = StorageMigrator.revertCustom.selector;
    bytes4 constant REVERT_STRING = StorageMigrator.revertString.selector;
    bytes4 constant REVERT_EMPTY  = StorageMigrator.revertEmpty.selector;

    StorageMigrator internal Migrator;
    address  internal migrator;

    constructor() {
        Migrator = new StorageMigrator();
        migrator = address(Migrator);
    }
}