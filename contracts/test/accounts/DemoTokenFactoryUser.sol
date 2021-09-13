// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.7;

import { IDemoTokenFactory } from "../../interfaces/IDemoTokenFactory.sol";

contract DemoTokenFactoryUser {

    /************************/
    /*** Direct Functions ***/
    /************************/

    function demoTokenFactory_newToken(address factory_, bytes calldata arguments_) external {
        IDemoTokenFactory(factory_).newToken(arguments_);
    }

    /*********************/
    /*** Try Functions ***/
    /*********************/

    function try_demoTokenFactory_newToken(address factory_, bytes calldata arguments_) external returns (bool ok_) {
        ( ok_, ) = factory_.call(abi.encodeWithSelector(IDemoTokenFactory.newToken.selector, arguments_));
    }

}
