// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "hardhat/console.sol";

contract SecureWallet {
    mapping(address => uint) fundAllocation;

    function receiveFunds() payable external {
        fundAllocation[msg.sender] = fundAllocation[msg.sender] + msg.value;
        console.log("Contract has received %s wei from your address, or %s; your current balance is %s wei.", msg.value, msg.sender, fundAllocation[msg.sender]);  
    }

    function withdrawFundsToSender(uint funds, string memory unit) payable external {
        uint weiFunds = convertUnits(funds, removeSpacesLowerCase(bytes(unit)));
        console.log("weiFunds = %s.", weiFunds);
        if (checkFundsSender(weiFunds)) {
            payable(msg.sender).transfer(weiFunds);
            fundAllocation[msg.sender] = fundAllocation[msg.sender] - weiFunds;
            getBalanceSender();
        }
    }

    function withdrawFundsToExtAddress(address payable _addr, uint funds, string memory unit) payable external {
        uint weiFunds = convertUnits(funds, removeSpacesLowerCase(bytes(unit)));
        console.log("weiFunds = %s.", weiFunds);
        if (checkFundsSender(weiFunds) && weiFunds != 0) {
            payable(_addr).transfer(weiFunds);
            fundAllocation[msg.sender] = fundAllocation[msg.sender] - weiFunds;
            getBalanceSender();
        }
    }

    function getBalance(address _addr) view internal returns (uint) {
        console.log("%s has a balance of %s wei.", _addr, fundAllocation[_addr]);
        return fundAllocation[_addr];
    }

    function getBalanceSender() view internal returns (uint) {
        console.log("You, or %s, have a balance of %s wei.", msg.sender, fundAllocation[msg.sender]);
        return fundAllocation[msg.sender];
    }

    function checkFundsSender(uint funds) view internal returns (bool) {
        if (funds <= fundAllocation[msg.sender]) {
            console.log("The address %s is requesting %s wei, and its request will be granted.", msg.sender, funds);           
            return true; 
        } else {
             console.log("The address %s is requesting %s wei, and its request will be rejected, as the amount is greater than the amount the contract can allocate for you, %s wei.", msg.sender, funds, fundAllocation[msg.sender]);      
            return false;
        }
    }
    
    function convertUnits(uint funds, bytes memory unit) pure internal returns (uint) {
        if (bytes10(unit) == "wei") {
            return funds;
        } else if (bytes10(unit) == "kwei" || bytes10(unit) == "babbage") {
            return funds * 1000;
        } else if (bytes10(unit) == "mwei" || bytes10(unit) == "lovelace" || bytes10(unit) == "ada" || bytes10(unit) == "femto" || bytes10(unit) == "femtoeth" || bytes10(unit) == "femtoether") {
            return funds * 1000000;
        } else if (bytes10(unit) == "gwei" || bytes10(unit) == "shannon" || bytes10(unit) == "pico" || bytes10(unit) == "picoeth" || bytes10(unit) == "picoether") {
            return funds * 1000000000;
        } else if (bytes10(unit) == "micro" || bytes10(unit) == "szabo" || bytes10(unit) == "microeth" || bytes10(unit) == "microether" || bytes10(unit) == "nano" || bytes10(unit) == "nanoeth" || bytes10(unit) == "nanoether") {
            return funds * 1000000000000;    
        } else if (bytes10(unit) == "milli" || bytes10(unit) == "finney" || bytes10(unit) == "millieth" || bytes10(unit) == "millether") {
            return funds * 1000000000000000;       
        } else if (bytes10(unit) == "ether" || bytes10(unit) == "eth" || bytes10(unit) == "ethereum") {
            return funds * 1000000000000000000;      
        } else {
            return 0;
        }
    }

    function toLowerCase(bytes memory _str) pure internal returns (bytes memory) {
        bytes memory str = _str;
        for (uint i = 0; i < str.length; ++i) {
            if (uint8(str[i]) >= 65 && uint8(str[i]) <= 90) {
                str[i] = bytes1(uint8(str[i]) + 32);  
            }
        }
        return str;
    }

    function removeSpacesLowerCase(bytes memory _str) pure public returns (bytes memory) {
        uint spaceCounter = 0;
        for (uint i = 0; i < _str.length; ++i) {
            if (uint8(_str[i]) <= 65 || uint8(_str[i]) >= 122) {
                if (uint8(_str[i]) == 0x20 || uint8(_str[i]) == 0x09 || uint8(_str[i]) == 0x0a || uint8(_str[i]) == 0x0D || uint8(_str[i]) == 0x0B || uint8(_str[i]) == 0x00) {
                    ++spaceCounter;
                }
            }
        }

        bytes memory output = new bytes(_str.length - spaceCounter);
        spaceCounter = 0;
        for (uint i = 0; i < _str.length; ++i) {
            if (uint8(_str[i]) <= 65 || uint8(_str[i]) >= 122) {
                if (uint8(_str[i]) == 0x20 || uint8(_str[i]) == 0x09 || uint8(_str[i]) == 0x0a || uint8(_str[i]) == 0x0D || uint8(_str[i]) == 0x0B || uint8(_str[i]) == 0x00) {
                    // do nothing
                } else {
                    output[spaceCounter] = _str[i];
                    spaceCounter++;
                }
            } else {
                output[spaceCounter] = _str[i];
                spaceCounter++;
            }
        }
        
        return toLowerCase(output);
    }
    
    /* function leftTrim(bytes memory _str) pure internal returns (bytes memory) {
        bytes memory str = _str;
        uint256 length = str.length;
        uint256 start;
        for (uint256 i = 0; i < length; ++i) {
            bytes1 char = str[i];
            if (char != 0x20 && char != 0x09 && char != 0x0a && char != 0x0D && char != 0x0B && char != 0x00) {
                start = i;
                break;
            }
        }
        bytes memory output = new bytes(length - start);
        for (uint256 i = start; i < length; ++i) {
            output[i - start] = str[i];
        }
        return output;
    }

    function rightTrim(bytes memory _str) pure internal returns (bytes memory) {
        bytes memory str = bytes(_str);
        uint256 length = str.length;
        uint256 end;
        for (uint256 i = length - 1; i >= 0; --i) {
            bytes1 char = str[i];
            if (char != 0x20 && char != 0x09 && char != 0x0a && char != 0x0D && char != 0x0B && char != 0x00) {
                end = i;
                break;
            }
        }
        
        bytes memory output = new bytes(end + 1);
        for (uint256 i = 0; i <= end; ++i) {
            output[i] = str[i];
        }
        return output;
    }
    
    function substring(bytes memory _str, uint startIndex, uint endIndex) pure public returns (bytes memory) {
        bytes memory result = new bytes(endIndex - startIndex + 1);
        for (uint i = startIndex; i <= endIndex; ++i) {
            result[i - startIndex] = _str[i];
        }
        return result;
    }
    
    function convertToETH (uint _amount) private returns (bytes memory) {
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
    } 
    function trimLowerCase(bytes memory _str) pure public returns (bytes memory) {
        bytes memory str = _str;
        uint firstChar = 0;
        uint lastChar = 0;
        uint i = 0;
        while (uint8(str[i]) != 0x20 && uint8(str[i]) != 0x09 && uint8(str[i]) != 0x0a && uint8(str[i]) != 0x0D && uint8(str[i]) != 0x0B && uint8(str[i]) != 0x00 && i < str.length) {
            if (uint8(str[i]) == 0x20 || uint8(str[i]) == 0x09 || uint8(str[i]) == 0x0a || uint8(str[i]) == 0x0D || uint8(str[i]) == 0x0B || uint8(str[i]) == 0x00) {
                firstChar = i;
                break;
            }
            ++i;
        }

        i = str.length - 1;

        do {
            if (uint8(str[i]) == 0x20 || uint8(str[i]) == 0x09 || uint8(str[i]) == 0x0a || uint8(str[i]) == 0x0D || uint8(str[i]) == 0x0B || uint8(str[i]) == 0x00) {
                lastChar = i;
                break;
            }
            --i;
        } while(uint8(str[i]) != 0x20 && uint8(str[i]) != 0x09 && uint8(str[i]) != 0x0a && uint8(str[i]) != 0x0D && uint8(str[i]) != 0x0B && uint8(str[i]) != 0x00 && i > 0);

		return substring(toLowerCase(str), firstChar, lastChar);
	} */

} 

// public: all contracts may access
// external: only external contracts may access
// internal: only this contract and sub-contracts may access
// private only this contracct may access
// pure: no state nor local data will be read nor changed
// view: no state nor local data will be changed
// address: an ethereum "account" to which funds may be stored
// mapping: a ethereum-ized version of a hashmap with keccak256 hashes
