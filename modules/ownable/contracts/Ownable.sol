// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.7;

import { OwnableConstructorless } from "./OwnableConstructorless.sol";
import { OwnableInitializer }     from "./OwnableInitializer.sol";

contract Ownable is OwnableConstructorless, OwnableInitializer {

    constructor(address _owner) {
        _initialize(_owner);
    }

}
