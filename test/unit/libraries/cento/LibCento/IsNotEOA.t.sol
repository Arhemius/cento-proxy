// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibCentoTestSetup} from "./AAA/Setup.sol";

contract IsNotEOATest is LibCentoTestSetup {

    function test_NotEOA_RevertsIfEOA() public {
        when_CheckNotEoa(errors, owner);
        then_MatchesError(NoCodeOrEOA(owner));
    }

    function test_NotEOA_RevertsIf7702EOA() public {
        when_CheckNotEoa(errors, eip7702Eoa);
        then_MatchesError(Is7702EOA(eip7702Eoa));
    }

    function test_NotEOA_SucceedsOnValidContract() public {
        when_CheckNotEoa(__, facetA);
    }

}