// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "hardhat/console.sol";

contract SecureWallet {
    mapping(address => uint) fundAllocation;
    mapping(string => uint) unitConversion;
    

    // could possibly track number of transactions to greet user or similar
    // ether unit specification functionality

    

    function receiveFunds() payable external {
        fundAllocation[msg.sender] = fundAllocation[msg.sender] + msg.value;
        console.log("Contract has received %s wei from your address, or %s; your current balance is %s", msg.value, msg.sender, fundAllocation[msg.sender]);  
    }

    function withdrawFundsToSender(uint funds, bytes memory unit) external {
        uint weiFunds = convertUnits(funds, Unit(unit));
        if (checkFundsSender(weiFunds)) {
            payable(msg.sender).transfer(weiFunds);
            fundAllocation[msg.sender] = fundAllocation[msg.sender] - weiFunds;
            getBalanceSender();
        }
    }

    function withdrawFundsToExtAddress(address payable _addr, uint funds, bytes memory unit) external {
        uint weiFunds = convertUnits(funds, unitMapping[unit]);
        if (checkFundsSender(weiFunds)) {
            payable(_addr).transfer(weiFunds);
            fundAllocation[msg.sender] = fundAllocation[msg.sender] - weiFunds;
            getBalanceSender();
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

    function checkFundsSender(uint funds) view internal returns(bool) {
        if (funds <= fundAllocation[msg.sender]) {
            console.log("The address %s is requesting %s wei, and its request will be granted.", msg.sender, funds);           
            return true; 
        } else {
             console.log("The address %s is requesting %s wei, and its request will be rejected, as the amount is greater than the amount the contract can allocate for you, %s wei.", msg.sender, funds, fundAllocation[msg.sender]);      
            return false;
        }
    }

    function convertUnits(uint funds, bytes8 unit) view internal returns (uint) {
        if (toLowerCase(unit).trim() == "wei") {
            return funds;
        } else if (toLowerCase(unit) == "kwei" || toLowerCase(unit) == "babbage") {
            return funds * 1000;
        } else if (toLowerCase(unit) == "wei" || toLowerCase(unit) == "lovelace") {
            return funds * 1000000;
        } else if (toLowerCase(unit) == "wei" || toLowerCase(unit) == "wei") {
            return funds * 1000000000;
        } else if (toLowerCase(unit) == "wei" || toLowerCase(unit) == "wei" || toLowerCase(unit) == "wei") {
            return funds * 1000000000000;    
        } else if (toLowerCase(unit) == "wei" || toLowerCase(unit) == "wei" || toLowerCase(unit) == "wei") {
            return funds * 1000000000000000;       
        } else if (toLowerCase(unit) == "wei" || toLowerCase(unit) == "wei") {
            return funds * 1000000000000000000;      
        } else {
            return 0;
        }
    }

    function toLowerCase(bytes8 str) internal returns (bytes8) {
		bytes memory lower = new bytes(str.length);
		for (uint i = 0; i < str.length; i++) {
			// Uppercase character...
			if ((str[i] >= 65) && (str[i] <= 90)) {
				// So we add 32 to make it lowercase
				lower[i] = bytes1(int(str[i]) + 32);
			} else {
				lower[i] = str[i];
			}
		}
		return bytes8(lower);
	}

    function trim(bytes memory str) internal returns (bytes8) {
		bytes memory lower = new bytes(str.length);
		for (uint i = 0; i < str.length; i++) {
            if (str[i] )
		}
		return bytes8(lower);
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
// pure: no state nor local data will be read nor changed
// view: no state nor local data will be changed
