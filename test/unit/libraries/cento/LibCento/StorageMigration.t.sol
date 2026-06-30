// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibCentoTestSetup} from "./AAA/Setup.sol";

contract StorageMigrationTest is LibCentoTestSetup {
    
    function test_Migration_WritesToStorage() public {
        bytes memory data = given_MigratorCall(WRITE_VALUE, abi.encode(42));
        when_CallMigrator(__, migrator, data);
        uint256 stored = uint256(h.TestSlot(Migrator.TEST_SLOT()));
        then_ValueIs(stored, 42);
    }

    function test_Migration_SkippedWhenZeroAddress() public {
        bytes memory data = given_MigratorCall(WRITE_VALUE, abi.encode(42));
        when_CallMigrator(__, address(0), data);
        uint256 stored = uint256(h.TestSlot(Migrator.TEST_SLOT()));
        then_ValueIs(stored, 0);
    }

    function test_Migrator_NoCodeOrEOA_Reverts() public {
        bytes memory data = given_MigratorCall(WRITE_VALUE, abi.encode(42));
        when_CallMigrator(errors, user, data);
        then_MatchesError(NoCodeOrEOA(user));
    }

    function test_Migration_RevertsEmpty() public {
        bytes memory data = given_MigratorCall(REVERT_EMPTY);
        when_CallMigrator(errors, migrator, data);
        then_MatchesError(StorageMigrationFailed(migrator));
    }

    function test_Migration_RevertsPanic() public {
        bytes memory data = given_MigratorCall(REVERT_PANIC);
        when_CallMigrator(errors, migrator, data);
        then_MatchesError($Panic(1));
    }

    function test_Migration_RevertsError() public {
        bytes memory data = given_MigratorCall(REVERT_ERROR);
        when_CallMigrator(errors, migrator, data);
        then_MatchesError($Error("Migration failed"));
    }

    function test_Migration_RevertsCustom() public {
        bytes memory data = given_MigratorCall(REVERT_CUSTOM);
        when_CallMigrator(errors, migrator, data);
        then_MatchesError(MigrationError());
    }

}