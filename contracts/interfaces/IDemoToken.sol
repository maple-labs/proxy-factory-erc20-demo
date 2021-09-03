// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import { IERC20 }   from "../../modules/erc20/src/interfaces/IERC20.sol";
import { IOwnable } from "../../modules/ownable/contracts/interfaces/IOwnable.sol";
import { IProxied } from "../../modules/proxy-factory/contracts/interfaces/IProxied.sol";

interface IDemoToken is IProxied, IERC20, IOwnable {

    function mint(address recipient, uint256 amount) external;

}
