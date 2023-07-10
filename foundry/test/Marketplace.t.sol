pragma solidity ^0.8.14;
import {Test} from "forge-std/Test.sol";
import {Marketplace} from "../src/Marketplace.sol";
contract MarketplaceTest is Test
{
    bytes32 private constant MINTER = keccak256(abi.encode("MINTER")) ;
    Marketplace instance;
    function setUp() public
    {
        instance=new Marketplace("");
    }
    function testgrant() public
    {
        address randomuser= vm.addr(2);
        instance.grantMinterRole(randomuser);
        assert(instance.roles(MINTER,randomuser)==true);
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
        vm.deal(randomuser,4e18);
        instance.grantMinterRole(randomuser);
        vm.prank(randomuser);
        instance.mintToken{value: 4 ether}(1, 2);
        assert(instance.balanceOf(randomuser, 1)==2);
    }
    function testRevertMintval() public{
        address randomuser= vm.addr(3);
        vm.deal(randomuser,4 ether);
        instance.grantMinterRole(randomuser);
        vm.prank(randomuser);
        instance.mintToken{value:1 ether}(1, 2);
        assert(instance.balanceOf(randomuser, 1)==0);
    }
     function testRevertnotMint() public{
        address randomuser= vm.addr(3);
        vm.deal(randomuser,4 ether);
        vm.prank(randomuser);
        instance.mintToken{value:1 ether}(1, 2);
    }
    function testRevertMintlimit() public{
        // vm.expectRevert();
        address randomuser= vm.addr(3);
        vm.deal(randomuser,3 ether);
        instance.grantMinterRole(randomuser);
        vm.prank(randomuser);
        instance.mintToken{value:2 ether}(1, 1);
        vm.deal(randomuser,42 ether);
        instance.mintToken{value:2 ether}(1, 21);
        assert(instance.balanceOf(randomuser, 1)==1);
    }
    function testBurn() public
    {
        address randomuser= vm.addr(3);
        vm.deal(randomuser,20 ether);
        instance.grantMinterRole(randomuser);
        vm.prank(randomuser);
        instance.mintToken{value:20 ether}(1, 10);
        vm.prank(randomuser);
        instance.burnToken(1, 3);
        assert(instance.balanceOf(randomuser, 1)==7);
    }
    function testBurnRevert() public
    {
     address randomuser= vm.addr(3);
        vm.deal(randomuser,3 ether);
        instance.grantMinterRole(randomuser);
        vm.prank(randomuser);
        instance.mintToken{value:2 ether}(1, 1);
        vm.prank(randomuser);
        instance.burnToken(1, 3);
    }
      function testBurnRevertnotminter() public
    {
     address randomuser= vm.addr(3);
        vm.deal(randomuser,3 ether);
        vm.prank(randomuser);
        instance.burnToken(1, 3);
    }
}