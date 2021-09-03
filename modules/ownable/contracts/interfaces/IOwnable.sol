// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import { IOwnableStorageLayout } from "./IOwnableStorageLayout.sol";

interface IOwnable is IOwnableStorageLayout{

    function setOwner(address newOwner) external;

}
