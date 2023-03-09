// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;
import "hardhat/console.sol";

contract SecureWallet {
    mapping(address => uint) fundAllocation;
    // could possibly track number of transactions to greet user or similar

    function receiveFunds() payable external {
        fundAllocation[msg.sender] = msg.value;
        console.log("Contract has received %s wei from %s.", msg.value, msg.sender);           
    }

    function withdrawFundsToSender(uint funds) external {
        if (checkFunds(msg.sender, funds)) {
            payable(msg.sender).transfer(funds);
            fundAllocation[msg.sender] = fundAllocation[msg.sender] - funds;
            getBalance(msg.sender);
        }
    }

    function withdrawFundsToExtAddress(address payable _addr, uint funds) external {
        if (checkFunds(msg.sender, funds)) {
            payable(_addr).transfer(funds);
            fundAllocation[msg.sender] = fundAllocation[msg.sender] - funds;
            getBalance(msg.sender);
        }
    }

    function checkFunds(address _addr, uint funds) view private returns(bool) {
        if (funds <= fundAllocation[_addr]) {
            console.log("The address %s is requesting %s wei, and its request will be granted.", _addr, funds);           
            return true; 
        } else {
             console.log("The address %s is requesting %s wei, and its request will be rejected.", _addr, funds);      
            return false;
        }
    }

    function getBalanceSender() external view returns (uint) {
        console.log("The address %s has a balance of %s wei.", msg.sender, fundAllocation[msg.sender]);
        return fundAllocation[msg.sender];
    }

    function getBalance(address _addr) private view returns (uint) {
        console.log("The address %s has a balance of %s wei.", _addr, fundAllocation[_addr]);
        return fundAllocation[_addr];
    }

    /* function convertToETH (uint _amount) private returns (bytes memory) {
        bytes memory ethBytes = "";
        uint amount = _amount;
        uint numberOfDigits = 0;
        while (amount > 10) {
            amount = amount / 10;
            numberOfDigits++;
        }
        amount = _amount;
        if (numberOfDigits > 18) {
            for (uint i = numberOfDigits; i >= 1; i--) {
                ethBytes = bytes.concat(ethBytes, (amount / (10**i)));
            }
        } else {

        }
    } */

} 

// public: all contracts may access
// external: only external contracts may access
// internal: only this contract and sub-contracts may access
// private only this contracct may access

