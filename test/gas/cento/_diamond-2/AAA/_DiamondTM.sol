// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {DiamondTest} from "./Base.t.sol";
import {IDiamondCut} from "test/gas/cento/_diamond-2/src/interfaces/IDiamondCut.sol";
import {DiamondSigs} from "support/fixtures/dummies/DiamondSigs.sol";
import {IERC173} from "../src/interfaces/IERC173.sol";

abstract contract DiamondTM is DiamondTest, DiamondSigs {

    function setUp() public virtual {
        _create();
        _bootstrap();
        _setup();
    }

    // ---------------------------------------------------------------------
    // Phase 1: construct system under test
    // ---------------------------------------------------------------------

    function _create() internal virtual {
    }

    function target(address _target) internal {
        diamond = _target;
    }

    // ---------------------------------------------------------------------
    // Phase 2: protocol bootstrap
    // ---------------------------------------------------------------------

    function _bootstrap() internal virtual {}
    

    function installAndInit(IDiamondCut.FacetCut[] memory setF, address _init, bytes memory data) internal {
        bool ok; bytes memory ret;
        (ok, ret) = diamond.staticcall(abi.encodeCall(IERC173.owner, ()));
        if (!ok) revert("install: owner query failed");
        address currentOwner = abi.decode(ret, (address));
        vm.prank(currentOwner);
        (ok,) = diamond.call(abi.encodeCall(IDiamondCut.diamondCut, (setF, _init, data)));
        if (!ok) revert("install: diamondCut failed");
    }

    function setOwner(address newOwner) internal {
        bool ok; bytes memory ret;
        (ok, ret) = diamond.staticcall(abi.encodeCall(IERC173.owner, ()));
        if (!ok) revert("install: owner query failed");
        address currentOwner = abi.decode(ret, (address));
        vm.prank(currentOwner);
        (ok,) = diamond.call(abi.encodeCall(IERC173.transferOwnership, (newOwner)));
        if (!ok) revert("install: diamondCut failed");
    }

    // ---------------------------------------------------------------------
    // Phase 4: scenario initialization (use this in tests)
    // ---------------------------------------------------------------------

    function _setup() internal virtual {}
}