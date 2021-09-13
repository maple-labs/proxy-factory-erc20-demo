// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import { IOwnable } from "../../modules/ownable/contracts/interfaces/IOwnable.sol";

interface IDemoTokenFactory is IOwnable {

    /// @dev A version of a token implementation, at some address, was registered, with an optional initializer.
    event ImplementationRegistered(uint256 indexed version, address indexed implementationAddress, address initializer);

    /// @dev A recommended token implementation version was set.
    event RecommendedVersionSet(uint256 recommendedVersion);

    /// @dev A proxy of a version of a token implementation was deployed, with a symbol.
    event TokenDeployed(uint256 indexed version, address indexed contractAddress, string symbol);

    /// @dev A migration path, and possibly a migrator contract, has been enabled between two versions.
    event UpgradePathEnabled(uint256 indexed fromVersion, uint256 indexed toVersion, address indexed migrator);

    /// @dev A migration path has been disabled between two versions.
    event UpgradePathDisabled(uint256 indexed fromVersion, uint256 indexed toVersion);

    /// @dev A proxy has been upgrade from an implementation version implementation version, with some migration arguments.
    event TokenUpgraded(address indexed tokenAddress, uint256 indexed fromVersion, uint256 indexed toVersion, bytes arguments);

    /// @dev Returns the address of the implementation of a version.
    function implementationOf(uint256 version_) external view returns (address implementation_);

    /// @dev Returns the version of an implementation address.
    function versionOf(address implementation_) external view returns (uint256 version_);

    /// @dev Returns the address of the migration contract for an upgrade path (from version, to version).
    function migratorForPath(uint256 fromVersion_, uint256 toVersion_) external view returns (address migrator_);

    /// @dev Returns the recommended version of the implementation.
    function recommendedVersion() external returns (uint256 recommendedVersion_);

    /// @dev Returns the address of a proxy token.
    function tokenAddressFor(string memory symbol_) external returns (address tokenAddress_);

    /// @dev Returns whether a proxy can be upgraded from a version to a version.
    function upgradePathAllowed(uint256 fromVersion_, uint256 toVersion_) external returns (bool upgradePathAllowed_);

    /// @dev Set the addresses of a version of a token implementation contract, with an optional initializer contract.
    function registerImplementation(uint256 version_, address implementationAddress_, address initializer_) external;

    /// @dev Set the recommended token implementation version.
    function setRecommendedVersion(uint256 version_) external;

    /// @dev Deploys a new instance of a token proxy.
    function newToken(bytes memory arguments_) external returns (address tokenAddress_);

    /// @dev Enables upgrading from a version to another version, with an optional migrator contract.
    function enableUpgradePath(uint256 fromVersion_, uint256 toVersion_, address migrator_) external;

    /// @dev Disables upgrading from a version to another version.
    function disableMigrationPath(uint256 fromVersion_, uint256 toVersion_) external;

    /// @dev Upgrades and migrates the caller (a proxy instance) to a version, with some migration arguments.
    function upgrade(uint256 toVersion_, bytes calldata arguments_) external;

}
