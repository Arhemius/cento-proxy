// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibCentoTestSetup} from "./AAA/Setup.sol";

contract ContractOwnerTest is LibCentoTestSetup {

    /*//////////////////////////////////////////////////////////////
                            GET OWNER
    //////////////////////////////////////////////////////////////*/

    function test_GetOwner_ReturnsInitialOwner() public {
        arrange_Owner(owner);
        address newOwner = when_GetContractOwner();
        then_OwnerIs(newOwner);
    }

    /*//////////////////////////////////////////////////////////////
                            SET OWNER
    //////////////////////////////////////////////////////////////*/

    function test_SetOwner_UpdatesStorage() public {
        when_SetContractOwner(__, owner);
        then_OwnerIs(owner);
    }

    function test_SetOwner_EmitsEvent() public {
        when_SetContractOwner(events, owner);
        then_MatchesEvent(address(lc), OwnershipTransferred(address(0), owner));
    }

    /*//////////////////////////////////////////////////////////////
                        ENFORCE OWNER
    //////////////////////////////////////////////////////////////*/

    function test_EnforceOwner_PassesForOwner() public {
        arrange_Owner(owner);
        vm.prank(owner);
        when_EnforceIsContractOwner(__);
    }

    function test_EnforceOwner_RevertsIfNotOwner() public {
        arrange_Owner(owner);
        vm.prank(user);
        when_EnforceIsContractOwner(errors);
        then_MatchesError(NotContractOwner(user));
    }
}