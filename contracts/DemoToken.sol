// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import { ERC20Constructorless }   from "../modules/erc20/src/ERC20Constructorless.sol";
import { OwnableConstructorless } from "../modules/ownable/contracts/OwnableConstructorless.sol";
import { Proxied }                from "../modules/proxy-factory/contracts/Proxied.sol";

import { IDemoTokenFactory } from "./interfaces/IDemoTokenFactory.sol";

import { IDemoToken } from "./interfaces/IDemoToken.sol";

contract DemoToken is IDemoToken, Proxied, ERC20Constructorless, OwnableConstructorless {

    function mint(address recipient_, uint256 amount_) external override {
        require(msg.sender == owner, "PT:M:NOT_OWNER");
        _mint(recipient_, amount_);
    }

    function upgrade(uint256 version_, bytes calldata arguments_) external override {
        require(msg.sender == owner, "PT:U:NOT_OWNER");
        IDemoTokenFactory(factory()).upgrade(version_, arguments_);
    }

}
