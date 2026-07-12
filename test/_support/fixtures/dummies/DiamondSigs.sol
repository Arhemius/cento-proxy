// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/builtins/Builtins.sol";

import {IDiamondCut} from "test/gas/cento/_diamond-2/src/interfaces/IDiamondCut.sol";
import {IDiamondLoupe} from "test/gas/cento/_diamond-2/src/interfaces/IDiamondLoupe.sol";
import {IERC165} from "test/gas/cento/_diamond-2/src/interfaces/IERC165.sol";
import {IERC173} from "test/gas/cento/_diamond-2/src/interfaces/IERC173.sol";

import {DiamondCutFacet} from "test/gas/cento/_diamond-2/src/facets/DiamondCutFacet.sol";
import {DiamondLoupeFacet} from "test/gas/cento/_diamond-2/src/facets/DiamondLoupeFacet.sol";
import {OwnershipFacet} from "test/gas/cento/_diamond-2/src/facets/OwnershipFacet.sol";
import {DiamondInit} from "test/gas/cento/_diamond-2/src/upgradeInitializers/DiamondInit.sol";

contract DiamondSigs {
    
    IDiamondCut.FacetCut[] internal DiamondDeploymentCut;

    bytes4[] internal diamondCutSigs;
    bytes4[] internal diamondLoupeSigs;
    bytes4[] internal ownershipSigs;

    address internal diamondCut;
    address internal diamondLoupe;
    address internal ownership;
    address internal diamondInit;

    constructor() {
        createFacets();
        createDeploymentCut();
    }

    function createFacets() private {
        diamondCut   = address(new DiamondCutFacet());
        diamondLoupe = address(new DiamondLoupeFacet());
        ownership    = address(new OwnershipFacet());
        diamondInit  = address(new DiamondInit());
    }

    function createDeploymentCut() private {
        DiamondDeploymentCut.push(IDiamondCut.FacetCut({
            facetAddress: diamondLoupe,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: B4_(abi.encode(
                IDiamondLoupe.facets.selector,
                IDiamondLoupe.facetFunctionSelectors.selector,
                IDiamondLoupe.facetAddresses.selector,
                IDiamondLoupe.facetAddress.selector,
                IERC165.supportsInterface.selector
            ))
        }));
        DiamondDeploymentCut.push(IDiamondCut.FacetCut({
            facetAddress: ownership,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: B4_(abi.encode(
                IERC173.owner.selector,
                IERC173.transferOwnership.selector
            ))
        }));
    }
}