// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CentoTestSetup} from "./_Setup.sol";
import {CentoCall} from "interaction/_CentoCall.sol";
import {ValidContract} from "support/fixtures/ValidContract.sol";
import "support/builtins/Builtins.sol";

contract RouterDispatchTest is CentoTestSetup {

    function test_Router_UpdatesAndDispatches() public {
        uint8 facetIndex = 3;

        Execute(cento, CentoCall._append(facetIndex,
            abi.encodeCall(ValidContract.dummy, ())
        ));
        then_Reverted();

        vm.prank(owner);
        CentoProxy.atomicUpdate(
            FacetArr(abi.encode(facetIndex, facetA))._out(), 
            NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
        );

        bool out = when_CallDummy(facetIndex);
        assertTrue(out, "Expected dummy() to return true.");
    }

    function when_CallDummy(uint8 facetIndex) private view returns (bool out) {
        bytes memory _calldata = CentoCall._append(facetIndex,
            abi.encodeCall(ValidContract.dummy, ())
        );
        return abi.decode(
            CentoCall._staticcall(cento, _calldata),
            (bool)
        );
    }
}