// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/AuraNetworksCore.sol";

contract DeployAuraNetwork is Script {
    function run() external {
        // Load private key from environment or Foundry settings
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the contract with a constructor argument
        AuraNetworksCore core = new AuraNetworksCore();

        // Log the deployed contract address
        console.log("AuraNetworksCore deployed at:", address(core));

        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
}
