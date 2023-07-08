// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.14;
import "forge-std/Script.sol";
import {Marketplace} from "../src/Marketplace.sol";
contract DeployToken is Script
{
function run() external returns(Marketplace)
{
    vm.startBroadcast();
    Marketplace marketplace=new Marketplace();
    vm.stopBroadcast();
    return marketplace;
}
}