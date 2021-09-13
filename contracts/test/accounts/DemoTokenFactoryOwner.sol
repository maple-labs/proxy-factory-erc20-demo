// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.7;

import { Owner } from "../../../modules/ownable/contracts/test/accounts/Owner.sol";

import { IDemoTokenFactory } from "../../interfaces/IDemoTokenFactory.sol";

contract DemoTokenFactoryOwner is Owner {

    /************************/
    /*** Direct Functions ***/
    /************************/

    function demoTokenFactory_registerImplementation(
        address factory_,
        uint256 version_,
        address implementationAddress_,
        address initializer_
    ) external {
        IDemoTokenFactory(factory_).registerImplementation(version_, implementationAddress_, initializer_);
    }

    function demoTokenFactory_setRecommendedVersion(address factory_, uint256 version_) external {
        IDemoTokenFactory(factory_).setRecommendedVersion(version_);
    }

    function demoTokenFactory_enableUpgradePath(address factory_, uint256 fromVersion_, uint256 toVersion_, address migrator_) external {
        IDemoTokenFactory(factory_).enableUpgradePath(fromVersion_, toVersion_, migrator_);
    }

    function demoTokenFactory_disableMigrationPath(address factory_, uint256 fromVersion_, uint256 toVersion_) external {
        IDemoTokenFactory(factory_).disableMigrationPath(fromVersion_, toVersion_);
    }

    /*********************/
    /*** Try Functions ***/
    /*********************/

    function try_demoTokenFactory_registerImplementation(
        address factory_,
        uint256 version_,
        address implementationAddress_,
        address initializer_
    ) external returns (bool ok_) {
        ( ok_, ) = factory_.call(
            abi.encodeWithSelector(IDemoTokenFactory.registerImplementation.selector, version_, implementationAddress_, initializer_)
        );
    }

    function try_demoTokenFactory_setRecommendedVersion(address factory_, uint256 version_) external returns (bool ok_) {
        ( ok_, ) = factory_.call(abi.encodeWithSelector(IDemoTokenFactory.setRecommendedVersion.selector, version_));
    }

    function try_demoTokenFactory_enableUpgradePath(
        address factory_,
        uint256 fromVersion_,
        uint256 toVersion_,
        address migrator_
    ) external returns (bool ok_) {
        ( ok_, ) = factory_.call(abi.encodeWithSelector(IDemoTokenFactory.enableUpgradePath.selector, fromVersion_, toVersion_, migrator_));
    }

    function try_demoTokenFactory_disableMigrationPath(address factory_, uint256 fromVersion_, uint256 toVersion_) external returns (bool ok_) {
        ( ok_, ) = factory_.call(abi.encodeWithSelector(IDemoTokenFactory.disableMigrationPath.selector, fromVersion_, toVersion_));
    }

}
