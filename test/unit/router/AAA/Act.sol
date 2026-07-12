// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CentoRouterTest} from "./Base.t.sol";
import {CentoCall} from "interaction/_CentoCall.sol";
import {ValidContract} from "support/fixtures/ValidContract.sol";
import {CentoRouterAdapter} from "support/adapters/CentoRouterAdapters.sol";
import {FacetManagerAdapter} from "support/adapters/FacetManagerAdapter.sol";
import {IERC173} from "cento/interfaces/IERC173.sol";
import {IERC165} from "cento/interfaces/IERC165.sol";
import {CentoV1} from "interaction/CentoV1.sol";

abstract contract CentoRouterAct is CentoRouterTest {

    function when_ConstructCentoProxy(address _contractOwner, address[3] memory facetAddresses) internal {
        cr = new CentoRouterAdapter(_contractOwner, facetAddresses);
        target(address(cr));
        lc_bind();
    }

    function when_CallDummy(uint8 facetIndex) internal view returns (bool out) {
        bytes memory _calldata = CentoCall._append(facetIndex,
            abi.encodeCall(ValidContract.dummy, ())
        );
        return abi.decode(
            CentoCall._staticcall(address(cr), _calldata),
            (bool)
        );
    }

    function when_InspectCalldata(bytes4 selector, bytes memory input) internal view returns (uint256 length, bytes memory output) {
        bytes memory _calldata = CentoCall._append(CentoV1.FACET_MANAGER,
            abi.encodePacked(selector, input)
        );
        return abi.decode(
            CentoCall._staticcall(address(cr), _calldata),
            (uint256, bytes)
        );
    }

    function when_PropagateRevert() internal {
        bytes memory _calldata = CentoCall._append(CentoV1.FACET_MANAGER, 
            abi.encodeCall(FacetManagerAdapter.revertError, ())
        );
        Execute(address(cr), _calldata);
    }

    function when_CallReceive(uint256 value) internal {
        CentoCall._call(address(cr), value, "");
    }

    function when_CallNonExistentFacet_Odd(uint8 index) internal {
        // provided slot is expected to be empty for this test
        Execute(address(cr), CentoCall._append(index, ""));
    }

    function when_CallNonExistentFacet_Even(uint8 index) internal {
        // provided slot is expected to be empty for this test
        Execute(address(cr), CentoCall._append(index, "e"));
    }

    function when_CallGetOwner() internal view returns (address owner) {
        (bool ok, bytes memory ret) = address(cr).staticcall(abi.encodeCall(IERC173.owner, ()));
        require(ok, "Stage 2 call failed");
        owner = abi.decode(ret, (address));
    }

    function when_CallTransferOwnership(address newOwner) internal {
        (bool ok, ) = address(cr).call(abi.encodeCall(IERC173.transferOwnership, (newOwner)));
        require(ok, "Stage 2 call failed");
    }

    function when_CallSupportsInterface(bytes4 interfaceId) internal view returns (bool isSupported) {
        (bool ok, bytes memory ret) = address(cr).staticcall(abi.encodeCall(IERC165.supportsInterface, (interfaceId)));
        require(ok, "Stage 2 call failed");
        isSupported = abi.decode(ret, (bool));
    }

}