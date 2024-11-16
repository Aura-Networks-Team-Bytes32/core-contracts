// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract AuraNetworksCore {
    mapping(bytes32 => bool) public s_users;
    mapping(bytes32 => address) public s_userPKP;
    mapping(address => uint256) public s_balances;
    mapping(uint256 => address) public s_merchants;

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

    function registerUser(
        bytes32 _worldcoinHash,
        bytes32 _debitCardHash,
        address _pkpEOA,
        bytes32 dataSigned,
        bytes32 r,
        bytes32 s,
        uint8 v
    ) external EOA_Verify(_pkpEOA, dataSigned, r, s, v) {
        require(!s_users[_worldcoinHash], "User Already Registered");
        s_users[_worldcoinHash] = true;
        s_userPKP[_debitCardHash] = _pkpEOA;
    }

    function registerMerchant(
        address _merchantAddress,
        uint256 _merchantId
    ) external {
        require(s_merchants[_merchantId] == address(0), "Id already used");
        s_merchants[_merchantId] = _merchantAddress;
    }

    function spendMoney(
        address _pkpEOASpender,
        uint256 _merchantId,
        uint256 amount,
        bytes32 dataSigned,
        bytes32 r,
        bytes32 s,
        uint8 v
    ) external EOA_Verify(_pkpEOASpender, dataSigned, r, s, v) {
        s_balances[_pkpEOASpender] -= amount;
        address merchantAddress = s_merchants[_merchantId];
        s_balances[merchantAddress] += amount;
    }
}
