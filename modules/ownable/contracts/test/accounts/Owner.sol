// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.7;

import { IOwnable } from "../../interfaces/IOwnable.sol";

contract Owner {

    /************************/
    /*** Direct Functions ***/
    /************************/

    function erc20_setOwner(address target, address newOwner) external {
        IOwnable(target).setOwner(newOwner);
    }

    /*********************/
    /*** Try Functions ***/
    /*********************/

    function try_erc20_setOwner(address target, address newOwner) external returns (bool ok) {
        (ok,) = target.call(abi.encodeWithSelector(IOwnable.setOwner.selector, newOwner));
    }

}
