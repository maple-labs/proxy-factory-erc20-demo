// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.7;

import { Owner } from "../../../modules/ownable/contracts/test/accounts/Owner.sol";

import { IDemoToken } from "../../interfaces/IDemoToken.sol";

import { DemoTokenUser } from "./DemoTokenUser.sol";

contract DemoTokenOwner is Owner, DemoTokenUser {

    /************************/
    /*** Direct Functions ***/
    /************************/

    function demoToken_mint(address token, address recipient, uint256 amount) external {
        IDemoToken(token).mint(recipient, amount);
    }

    /*********************/
    /*** Try Functions ***/
    /*********************/

    function try_demoToken_mint(address token, address recipient, uint256 amount) external returns (bool ok) {
        (ok,) = token.call(abi.encodeWithSelector(IDemoToken.mint.selector, recipient, amount));
    }

}
