// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import { ERC20Initializer }   from "../modules/erc20/src/ERC20Initializer.sol";
import { OwnableInitializer } from "../modules/ownable/contracts/OwnableInitializer.sol";

contract DemoTokenInitializer is ERC20Initializer, OwnableInitializer {

    fallback() external {
        (
            string memory name,
            string memory symbol,
            uint8 decimals,
            address owner,
            uint256 initialSupply
        ) = abi.decode(msg.data, (string, string, uint8, address, uint256));

        ERC20Initializer._initialize(name, symbol, decimals);
        OwnableInitializer._initialize(owner);

        balanceOf[owner] = initialSupply;
        totalSupply      = initialSupply;
    }

}
