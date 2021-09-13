// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import { DSTest } from "../../modules/ds-test/src/test.sol";

import { IDemoToken } from "../interfaces/IDemoToken.sol";

import { DemoToken }            from "../DemoToken.sol";
import { DemoTokenFactory }     from "../DemoTokenFactory.sol";
import { DemoTokenInitializer } from "../DemoTokenInitializer.sol";

import { DemoTokenFactoryOwner } from "./accounts/DemoTokenFactoryOwner.sol";
import { DemoTokenFactoryUser }  from "./accounts/DemoTokenFactoryUser.sol";
import { DemoTokenOwner }        from "./accounts/DemoTokenOwner.sol";
import { DemoTokenUser }         from "./accounts/DemoTokenUser.sol";

contract MockDemoTokenV2 is DemoToken {

    function getFoo() external view returns(uint256 foo_) {
        return totalSupply;
    }

}

contract Test is DSTest {

    function test_story1() external {
        DemoTokenFactoryOwner factoryOwner = new DemoTokenFactoryOwner();
        DemoTokenFactory      factory      = new DemoTokenFactory(address(factoryOwner));

        DemoToken            implementationV1 = new DemoToken();
        DemoTokenInitializer initializer      = new DemoTokenInitializer();

        factoryOwner.demoTokenFactory_registerImplementation(address(factory), uint256(1), address(implementationV1), address(initializer));
        factoryOwner.demoTokenFactory_setRecommendedVersion(address(factory), uint256(1));

        assertEq(factory.versionOf(address(implementationV1)), uint256(1));

        DemoTokenOwner tokenOwner = new DemoTokenOwner();

        IDemoToken token = IDemoToken(factory.newToken(abi.encode("TST", "Test Token", uint8(9), address(tokenOwner), uint256(1000))));

        assertEq(token.implementation(),                    address(implementationV1));
        assertEq(factory.versionOf(token.implementation()), uint256(1));
        assertEq(factory.tokenAddressFor("TST"),            address(token));

        DemoTokenUser tokenUser = new DemoTokenUser();

        DemoTokenUser(address(tokenOwner)).erc20_transfer(address(token), address(tokenUser), uint256(250));
        assertEq(token.balanceOf(address(tokenUser)), uint256(250));

        MockDemoTokenV2 implementationV2 = new MockDemoTokenV2();

        factoryOwner.demoTokenFactory_registerImplementation(address(factory), uint256(2), address(implementationV2), address(initializer));
        factoryOwner.demoTokenFactory_setRecommendedVersion(address(factory), uint256(2));
        factoryOwner.demoTokenFactory_enableUpgradePath(address(factory), uint256(1), uint256(2), address(0));

        tokenOwner.demoToken_upgrade(address(token), uint256(2), new bytes(0));

        assertEq(token.implementation(),                    address(implementationV2));
        assertEq(factory.versionOf(token.implementation()), uint256(2));

        DemoTokenUser(address(tokenOwner)).erc20_transfer(address(token), address(tokenUser), uint256(250));

        assertEq(token.balanceOf(address(tokenUser)),      uint256(500));
        assertEq(MockDemoTokenV2(address(token)).getFoo(), uint256(1000));
    }

}
