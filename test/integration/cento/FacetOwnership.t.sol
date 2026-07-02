// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CentoTestSetup} from "./_Setup.sol";
import {CentoCall} from "interaction/_CentoCall.sol";
import {CentoV1} from "interaction/CentoV1.sol";
import {FacetManager} from "src/cento/facets/FacetManager.sol";
import "support/builtins/Builtins.sol";

contract FacetOwnershipTest is CentoTestSetup {

    function test_FacetOwnership_OnlyOwnerCanUpdate() public {
        uint8 facetIndex = 3;

        vm.prank(user);
        Execute(cento, CentoCall._append(CentoV1.FACET_MANAGER,
            abi.encodeCall(FacetManager.atomicUpdate, (
                FacetArr(abi.encode(facetIndex, facetA))._out(), 
                NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
            ))
        ));
        then_MatchesError(NotContractOwner(user));

        vm.prank(owner);
        CentoProxy.atomicUpdate(
            FacetArr(abi.encode(facetIndex, facetA))._out(), 
            NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
        );

        vm.prank(owner);
        CentoProxy.transferOwnership(user);

        vm.prank(user);
        CentoProxy.atomicUpdate(
            FacetArr(abi.encode(facetIndex, facetB))._out(), 
            NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
        );

        vm.prank(owner);
        Execute(cento, CentoCall._append(CentoV1.FACET_MANAGER,
            abi.encodeCall(FacetManager.atomicUpdate, (
                FacetArr(abi.encode(facetIndex, facetA))._out(), 
                NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
            ))
        ));
        then_MatchesError(NotContractOwner(owner));
    }

}