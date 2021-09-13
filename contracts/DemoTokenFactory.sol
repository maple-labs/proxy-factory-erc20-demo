// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import { Ownable }      from "../modules/ownable/contracts/Ownable.sol";
import { ProxyFactory } from "../modules/proxy-factory/contracts/ProxyFactory.sol";

import { IProxied } from "../modules/proxy-factory/contracts/interfaces/IProxied.sol";

import { IDemoTokenFactory } from "./interfaces/IDemoTokenFactory.sol";

contract DemoTokenFactory is IDemoTokenFactory, ProxyFactory, Ownable {

    uint256 public override recommendedVersion;

    mapping(string => address) public override tokenAddressFor;
    mapping(uint256 => mapping(uint256 => bool)) public override upgradePathAllowed;

    constructor(address owner_) Ownable(owner_) {}

    function registerImplementation(uint256 version_, address implementationAddress_, address initializer_) external override {
        require(msg.sender == owner,    "DTF:RI:NOT_OWNER");
        require(version_ != uint256(0), "DTF:RI:INVALID_VERSION");

        _registerImplementation(version_, implementationAddress_);
        _registerMigrator(version_, version_, initializer_);

        emit ImplementationRegistered(version_, implementationAddress_, initializer_);
    }

    function setRecommendedVersion(uint256 version_) external override {
        require(msg.sender == owner,    "DTF:SRV:NOT_OWNER");
        require(version_ != uint256(0), "DTF:SRV:INVALID_VERSION");

        emit RecommendedVersionSet(recommendedVersion = version_);
    }

    function newToken(bytes memory arguments_) external override returns (address tokenAddress_) {
        (string memory symbol) = abi.decode(arguments_, (string));
        require(tokenAddressFor[symbol] == address(0), "DTF:NT:SYMBOL_TAKEN");

        uint256 version = recommendedVersion;
        bool success;
        (success, tokenAddress_) = _newInstance(version, arguments_);
        require(success, "DTF:NT:FAILED");
        
        emit TokenDeployed(version, tokenAddressFor[symbol] = tokenAddress_, symbol);
    }

    function enableUpgradePath(uint256 fromVersion_, uint256 toVersion_, address migrator_) external override {
        require(msg.sender == owner, "DTF:RMP:NOT_OWNER");

        _registerMigrator(fromVersion_, toVersion_, migrator_);
        upgradePathAllowed[fromVersion_][toVersion_] = true;

        emit UpgradePathEnabled(fromVersion_, toVersion_, migrator_);
    }

    function disableMigrationPath(uint256 fromVersion_, uint256 toVersion_) external override {
        require(msg.sender == owner, "DTF:RMP:NOT_OWNER");

        _registerMigrator(fromVersion_, toVersion_, address(0));
        upgradePathAllowed[fromVersion_][toVersion_] = false;

        emit UpgradePathDisabled(fromVersion_, toVersion_);
    }

    function upgrade(uint256 toVersion_, bytes calldata arguments_) external override {
        uint256 fromVersion = _versionOf[IProxied(msg.sender).implementation()];
        require(upgradePathAllowed[fromVersion][toVersion_], "DTF:UI:NOT_ALLOWED");

        _upgradeInstance(msg.sender, toVersion_, arguments_);

        emit TokenUpgraded(msg.sender, fromVersion, toVersion_, arguments_);
    }

    function implementationOf(uint256 version_) external view override returns (address implementation_) {
        return _implementationOf[version_];
    }

    function versionOf(address implementation_) external view override returns (uint256 version_) {
        return _versionOf[implementation_];
    }

    function migratorForPath(uint256 fromVersion_, uint256 toVersion_) external view override returns (address migrator_) {
        return _migratorForPath[fromVersion_][toVersion_];
    }

}
