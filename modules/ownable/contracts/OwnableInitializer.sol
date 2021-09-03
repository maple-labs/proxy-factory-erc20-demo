// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import { IOwnable } from "./interfaces/IOwnable.sol";

import { OwnableStorageLayout } from "./OwnableStorageLayout.sol";

contract OwnableInitializer is OwnableStorageLayout {

    function _initialize(address _owner) internal {
        owner = _owner;
    }

}
