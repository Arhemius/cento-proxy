// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CentoRouterTestSetup} from "./AAA/Setup.sol";
import {FacetManagerAdapter} from "support/adapters/FacetManagerAdapter.sol";
import {Cento} from "interaction/Cento.sol";

contract FallbackTest is CentoRouterTestSetup {

    function test_Dummy_FacetManager() public view {
        bool out = when_CallDummy(Cento.FACET_MANAGER);
        assertTrue(out);
    }

    function test_Dummy_Observability() public view {
        bool out = when_CallDummy(Cento.OBSERVABILITY);
        assertTrue(out);
    }

    function test_Dummy_Ownership() public view {
        bool out = when_CallDummy(Cento.OWNERSHIP);
        assertTrue(out);
    }

    function test_RevertPropagation() public {
        when_PropagateRevert();
        then_MatchesError($Error("FacetManager Reverted"));
    }

    function test_Receive() public {
        vm.prank(owner);
        when_CallReceive(1 ether);
        assertEq(address(cr).balance, 1 ether);
    }

    function test_NonExistentFacet_Reverts() public {
        when_CallNonExistentFacet(255);
        then_MatchesError(Error({
            selector: ERR_FACET_NOT_FOUND,
            data: abi.encode(255)
        }));
    }


    // appended facet makes it 4 bytes selector + 2 bytes input + 1 byte facet = 7 bytes -> odd -> stage 1
    function test_InspectCalldata_Odd_Strips() public view {
        bytes4 selector = FacetManagerAdapter.inspectCalldata.selector;
        bytes memory input = new bytes(2);
        input[0] = 0xaf;
        input[1] = 0xff;
        (uint256 length, bytes memory data) = when_InspectCalldata(selector, input);
        assertEq(length, 4 + input.length);
        assertEq(data, abi.encodePacked(selector, input));
    }

    // target function is not in list of legacy selectors
    // appended facet makes it 4 bytes selector + 1 byte input + 1 byte facet = 6 bytes -> even -> stage 3
    function test_InspectCalldata_Even_Strips() public view {
        bytes4 selector = FacetManagerAdapter.inspectCalldata.selector;
        bytes memory input = new bytes(1);
        input[0] = 0xaf;
        (uint256 length, bytes memory data) = when_InspectCalldata(selector, input);
        assertEq(length, 4 + input.length);
        assertEq(data, abi.encodePacked(selector, input));
    }


    function test_CallOwner() public view {
        address currentOwner = when_CallGetOwner();
        assertEq(currentOwner, owner);
    }

    function test_CallTransferOwnership() public {
        vm.prank(owner);
        when_CallTransferOwnership(user);
        then_OwnerIs(user);
    }

    function test_CallSupportsInterface() public view {
        bool isSupported = when_CallSupportsInterface(i4);
        assertTrue(isSupported);
    }

}