// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import { IOwnableStorageLayout } from "./interfaces/IOwnableStorageLayout.sol";

contract OwnableStorageLayout is IOwnableStorageLayout {

    address public override owner;

}
