// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import { DSTest } from "../../modules/ds-test/src/test.sol";

import { IDemoToken } from "../interfaces/IDemoToken.sol";

import { DemoToken }            from "../DemoToken.sol";
import { DemoTokenFactory }     from "../DemoTokenFactory.sol";
import { DemoTokenInitializer } from "../DemoTokenInitializer.sol";

import { DemoTokenOwner } from "./accounts/DemoTokenOwner.sol";
import { DemoTokenUser }  from "./accounts/DemoTokenUser.sol";

contract Test is DSTest {

    function test_newInstance() external {
        DemoToken            implementation = new DemoToken();
        DemoTokenFactory     factory        = new DemoTokenFactory();
        DemoTokenInitializer initializer    = new DemoTokenInitializer();

        factory.registerImplementation(1, address(implementation), address(initializer));
        factory.setRecommendedVersion(1);

        assertEq(factory.versionOf(address(implementation)), 1);

        DemoTokenOwner tokenOwner = new DemoTokenOwner();

        IDemoToken token = IDemoToken(
            factory.newInstance(
                factory.recommendedVersion(),
                abi.encode("Test Token", "TST", 8, address(tokenOwner), 1337)
            )
        );

        // Assert Factory State
        assertEq(factory.implementationFor(address(token)), address(implementation));

        // Assert Token Proxy
        assertEq(token.allowance(address(0), address(0)), 0);
        assertEq(token.balanceOf(address(0)),             0);
        assertEq(token.balanceOf(address(tokenOwner)),    1337);
        assertEq(token.decimals(),                        uint8(8));
        assertEq(token.factory(),                         address(factory));
        assertEq(token.implementation(),                  address(implementation));
        assertEq(token.name(),                            "Test Token");
        assertEq(token.owner(),                           address(tokenOwner));
        assertEq(token.symbol(),                          "TST");
        assertEq(token.totalSupply(),                     1337);

        // Test State-Changing Functions
        DemoTokenOwner anotherTokenOwner = new DemoTokenOwner();

        assertTrue(!anotherTokenOwner.try_erc20_setOwner(address(token), address(anotherTokenOwner)));
        assertTrue(        tokenOwner.try_erc20_setOwner(address(token), address(anotherTokenOwner)));

        assertEq(token.owner(), address(anotherTokenOwner));

        assertTrue(      !tokenOwner.try_erc20_setOwner(address(token), address(tokenOwner)));
        assertTrue(anotherTokenOwner.try_erc20_setOwner(address(token), address(tokenOwner)));

        DemoTokenUser tokenUser1 = new DemoTokenUser();
        DemoTokenUser tokenUser2 = new DemoTokenUser();

        assertTrue(tokenOwner.try_erc20_approve(address(token), address(tokenUser1), 1000));

        assertTrue(!tokenUser2.try_erc20_transferFrom(address(token), address(tokenOwner), address(tokenUser2), 1000));
        assertTrue( tokenUser1.try_erc20_transferFrom(address(token), address(tokenOwner), address(tokenUser2), 1000));

        assertTrue(!tokenUser1.try_erc20_transfer(address(token), address(tokenUser1), 200));
        assertTrue( tokenUser2.try_erc20_transfer(address(token), address(tokenUser1), 200));

        assertTrue(!anotherTokenOwner.try_demoToken_mint(address(token), address(tokenUser2), 10_000));
        assertTrue(        tokenOwner.try_demoToken_mint(address(token), address(tokenUser2), 10_000));

        assertEq(token.balanceOf(address(tokenOwner)), 337);
        assertEq(token.balanceOf(address(tokenUser1)), 200);
        assertEq(token.balanceOf(address(tokenUser2)), 10_800);
    }

}
