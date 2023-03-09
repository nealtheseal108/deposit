// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;
import "hardhat/console.sol";

contract SecureWallet {
    mapping(address => uint) fundAllocation;
    // could possibly track number of transactions to greet user or similar
    // ether unit specification functionality
    // directly send gifts to another user

    function receiveFunds() payable external {
        fundAllocation[msg.sender] = fundAllocation[msg.sender] + msg.value;
        console.log("Contract has received %s wei from %s, and the value of %s in this contract is %s wei.", msg.value, msg.sender, msg.sender, getBalanceSender());           

    }

    function withdrawFundsToSender(uint funds /*, bytes unit*/) external {
        if (checkFundsSender(funds)) {
            /* if (unit) */
            payable(msg.sender).transfer(funds);
            fundAllocation[msg.sender] = fundAllocation[msg.sender] - funds;
            getBalanceSender();
        }
    }

    function withdrawFundsToExtAddress(address payable _addr, uint funds) external {
        if (checkFundsSender(funds)) {
            payable(_addr).transfer(funds);
            fundAllocation[msg.sender] = fundAllocation[msg.sender] - funds;
            getBalance(msg.sender);
        }
    }

    function getBalance(address _addr) internal view returns (uint) {
        console.log("%s has a balance of %s wei.", _addr, fundAllocation[_addr]);
        return fundAllocation[_addr];
    }

    function getBalanceSender() public view returns (uint) {
        console.log("You, or %s, have a balance of %s wei.", msg.sender, fundAllocation[msg.sender]);
        return fundAllocation[msg.sender];
    }

    function checkFundsSender(uint funds) view private returns(bool) {
        if (funds <= fundAllocation[msg.sender]) {
            console.log("The address %s is requesting %s wei, and its request will be granted.", msg.sender, funds);           
            return true; 
        } else {
             console.log("The address %s is requesting %s wei, and its request will be rejected.", msg.sender, funds);      
            return false;
        }
    }

    function bytesEqual(bytes32 a, bytes32 b) private pure returns(bool) {
        return a == b;
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
