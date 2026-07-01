// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/builtins/Builtins.sol";
import {LibCentoTestSetup} from "./AAA/Setup.sol";

contract SetInterfaceTest is LibCentoTestSetup {

    function lc_setup() internal override {
        arrange_Interfaces(B4_(abi.encode(i1, i2, i3, i4)));
    }
    
    function test_SetI_AddsInterface() public {
        when_AddInterface(events, i5);
        then_InterfaceSupported(  i5);
        then_MatchesEvent(address(lc), InterfaceAdded(i5));
    }

    function test_SetI_RemovesInterface() public {
        when_RemoveInterface(events, i2);
        then_InterfaceNotSupported(  i2);
        then_MatchesEvent(address(lc), InterfaceRemoved(i2));
    }

    function test_SetI_AddsInterfaces() public {
        bytes4[] memory addI = interfaces();
        when_AddInterfaces(events, addI);
        then_InterfacesSupported(B4_(abi.encode(i1, i2, i3, i4, i5, i6, i7)));
        then_MatchesEvents(address(lc), InterfacesAdded(addI));
    }

    function test_SetI_RemovesInterfaces() public {
        bytes4[] memory remI = B4_(abi.encode(i2, i3, i4));
        when_RemoveInterfaces(events, remI);
        then_InterfacesSupported(B4_(abi.encode(i1)));
        then_MatchesEvents(address(lc), InterfacesRemoved(remI));
    }

}