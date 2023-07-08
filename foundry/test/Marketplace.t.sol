pragma solidity ^0.8.14;
import {Test} from "forge-std/Test.sol";
import {Marketplace} from "../src/Marketplace.sol";
contract MarketplaceTest is Test
{
    Marketplace instance;
    address owner;
    function setUp() public
    {
        owner= vm.addr(1);
        vm.prank(owner);
        Marketplace instance=new Marketplace();
    }
    function testgrant() public
    {
        vm.prank(owner);
        address randomuser= vm.addr(2);
        instance.grantMinterRole(randomuser);
    }
    function testRevert() public
    {
        vm.expectRevert();
        address randomuser= vm.addr(2);
        vm.prank(randomuser);
        instance.grantMinterRole(randomuser);
    }
    function testupdatePrice() public
    {
        vm.prank(owner);
        instance.updateTokenPrice(1e18, 2e18, 3e18, 15e17, 275e16);
    }
    function testupdateRevert() public
    {
        vm.expectRevert();
        address randomuser= vm.addr(3);
        vm.prank(randomuser);
        instance.updateTokenPrice(1e18, 2e18, 3e18, 15e17, 275e16);
    }
    function testMint() public{
        address randomuser= vm.addr(3);
        vm.deal(randomuser,3 ether);
        vm.prank(owner);
        instance.grantMinterRole(randomuser);
        vm.prank(randomuser);
        instance.mintToken{value:2 ether}(1, 2);
    }
    function testRevertMintval() public{
        vm.expectRevert();
        address randomuser= vm.addr(3);
        vm.deal(randomuser,3 ether);
        vm.prank(owner);
        instance.grantMinterRole(randomuser);
        vm.prank(randomuser);
        instance.mintToken{value:1 ether}(1, 2);
    }
    function testRevertMintlimit() public{
        vm.expectRevert();
        address randomuser= vm.addr(3);
        vm.deal(randomuser,3 ether);
        vm.prank(owner);
        instance.grantMinterRole(randomuser);
        vm.prank(randomuser);
        instance.mintToken{value:2 ether}(1, 21);
    }
    function testBurn() public
    {
        address randomuser= vm.addr(3);
        vm.deal(randomuser,3 ether);
        vm.prank(owner);
        instance.grantMinterRole(randomuser);
        vm.prank(randomuser);
        instance.mintToken{value:2 ether}(1, 10);
        instance.burnToken(1, 3);
    }
    function testBurnRevert() public
    {
        address randomuser= vm.addr(3);
        vm.deal(randomuser,3 ether);
        vm.prank(owner);
        instance.grantMinterRole(randomuser);
        vm.prank(randomuser);
        instance.burnToken(1, 3);
    }
}