// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {Diamond} from "test/gas/cento/_diamond-2/src/Diamond.sol";
import {IDiamondCut} from "test/gas/cento/_diamond-2/src/interfaces/IDiamondCut.sol";
import {DiamondCutFacet} from "test/gas/cento/_diamond-2/src/facets/DiamondCutFacet.sol";
import {DiamondLoupeFacet} from "test/gas/cento/_diamond-2/src/facets/DiamondLoupeFacet.sol";
import {OwnershipFacet} from "test/gas/cento/_diamond-2/src/facets/OwnershipFacet.sol";
import {DiamondInit} from "test/gas/cento/_diamond-2/src/upgradeInitializers/DiamondInit.sol";
import {DiamondSigs} from "support/fixtures/dummies/DiamondSigs.sol";

contract DeployDiamondGasTest is Script, DiamondSigs {

    function run() public {
        address owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

        vm.startBroadcast();
        address dc  = address(new DiamondCutFacet());
        address dl  = address(new DiamondLoupeFacet());
        address own = address(new OwnershipFacet());
        address di  = address(new DiamondInit());
        address diamond = address(new Diamond(owner, dc));
        vm.stopBroadcast();

        DiamondDeploymentCut[0].facetAddress = dl;
        DiamondDeploymentCut[1].facetAddress = own;

        vm.startBroadcast();
        (bool ok,) = address(diamond).call(abi.encodeCall(
            IDiamondCut.diamondCut, (DiamondDeploymentCut, di, abi.encodeCall(DiamondInit.init, ()))
        ));
        if (!ok) revert("create: diamondCut failed (diamond)");
        vm.stopBroadcast();
    }
}