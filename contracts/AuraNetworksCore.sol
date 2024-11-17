// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {VennFirewallConsumer} from "@ironblocks/firewall-consumer/contracts/consumers/VennFirewallConsumer.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract AuraNetworksCore is VennFirewallConsumer  {
    mapping(bytes32 => bool) public s_users;
    mapping(bytes32 => address) public s_userPKP;
    mapping(address => uint256) public s_balances;
    mapping(uint256 => address) public s_merchants;

    // 0x501e0636c64b28840e0C38409Beb87d6BdfA835A -> admin account
    modifier EOA_Verify(
        address _pkpEOA,
        bytes32 dataSigned,
        bytes32 r,
        bytes32 s,
        uint8 v
    ) {
        address signer = ecrecover(dataSigned, v, r, s);
        // Check if the recovered address matches the expected signer
        require(signer == _pkpEOA, "Failed Auth");
        _;
    }

    constructor() {
        s_balances[
            0x501e0636c64b28840e0C38409Beb87d6BdfA835A
        ] = 10000000000000000000000000000;
    }

    function registerUser(
        bytes32 _worldcoinHash,
        bytes32 _debitCardHash,
        address _pkpEOA
    ) external firewallProtected// bytes32 dataSigned,
    // bytes32 r,
    // bytes32 s,
    // uint8 v
    // EOA_Verify(_pkpEOA, dataSigned, r, s, v) firewallProtected
    {
        require(!s_users[_worldcoinHash], "User Already Registered");
        s_users[_worldcoinHash] = true;
        s_userPKP[_debitCardHash] = _pkpEOA;
    }

    function registerMerchant(
        address _merchantAddress,
        uint256 _merchantId
    ) external  firewallProtected {
        require(s_merchants[_merchantId] == address(0), "Id already used");
        s_merchants[_merchantId] = _merchantAddress;
    }

    function spendMoney(
        address _pkpEOASpender,
        uint256 _merchantId,
        uint256 amount
    ) external   firewallProtected// bytes32 dataSigned,
    // bytes32 r,
    // bytes32 s,
    // uint8 v
    // EOA_Verify(_pkpEOASpender, dataSigned, r, s, v) firewallProtected
    {
        s_balances[_pkpEOASpender] -= amount;
        address merchantAddress = s_merchants[_merchantId];
        s_balances[merchantAddress] += amount;
    }
}
