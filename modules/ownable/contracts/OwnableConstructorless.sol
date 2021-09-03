// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import { IOwnable } from "./interfaces/IOwnable.sol";

import { OwnableStorageLayout } from "./OwnableStorageLayout.sol";

contract OwnableConstructorless is IOwnable, OwnableStorageLayout {

    function setOwner(address newOwner) external override {
        require(msg.sender == owner, "O:SO:NOT_OWNER");
        owner = newOwner;
    }

}
