// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {OwnershipTestSetup} from "./AAA/Setup.sol";

contract OwnershipTest is OwnershipTestSetup {

    function test_Transfer_WhenOwner_TransfersOwnership() public {
        arrange_Owner(owner);
        vm.prank(owner);
        when_TransferOwnership(__, user);
        then_OwnerIs(user);
    }

    function test_Transfer_WhenUser_Reverts() public {
        arrange_Owner(owner);
        vm.prank(user);
        when_TransferOwnership(errors, user);
        then_MatchesError(NotContractOwner(user));
    }

    function test_GetOwner_ReturnsOwner() public {
        arrange_Owner(owner);
        vm.prank(user);
        address currentOwner = when_GetContractOwner();
        then_OwnerIs(currentOwner);
    }
}