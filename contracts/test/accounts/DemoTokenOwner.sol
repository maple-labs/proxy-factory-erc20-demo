// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.7;

import { Owner } from "../../../modules/ownable/contracts/test/accounts/Owner.sol";

import { IDemoToken } from "../../interfaces/IDemoToken.sol";

import { DemoTokenUser } from "./DemoTokenUser.sol";

contract DemoTokenOwner is Owner, DemoTokenUser {

    /************************/
    /*** Direct Functions ***/
    /************************/

    function demoToken_mint(address token_, address recipient_, uint256 amount_) external {
        IDemoToken(token_).mint(recipient_, amount_);
    }

    function demoToken_upgrade(address token_, uint256 version_, bytes calldata arguments_) external {
        IDemoToken(token_).upgrade(version_, arguments_);
    }

    /*********************/
    /*** Try Functions ***/
    /*********************/

    function try_demoToken_mint(address token_, address recipient_, uint256 amount_) external returns (bool ok_) {
        ( ok_, ) = token_.call(abi.encodeWithSelector(IDemoToken.mint.selector, recipient_, amount_));
    }

    function try_demoToken_upgrade(address token_, uint256 version_, bytes calldata arguments_) external returns (bool ok_) {
        ( ok_, ) = token_.call(abi.encodeWithSelector(IDemoToken.upgrade.selector, version_, arguments_));
    }

}
