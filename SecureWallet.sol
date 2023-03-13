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
        uint weiFunds = convertUnits(funds, trimLowerCase(bytes(unit)));
        console.log("weiFunds = %s.", weiFunds);
        if (checkFundsSender(weiFunds)) {
            payable(msg.sender).transfer(weiFunds);
            fundAllocation[msg.sender] = fundAllocation[msg.sender] - weiFunds;
            getBalanceSender();
        }
    }

    function withdrawFundsToExtAddress(address payable _addr, uint funds, string memory unit) payable external {
        uint weiFunds = convertUnits(funds, trimLowerCase(bytes(unit)));
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
        if (bytes32(unit) == "wei") {
            return funds;
        } else if (bytes32(unit) == "kwei" || bytes32(unit) == "babbage") {
            return funds * 1000;
        } else if (bytes32(unit) == "mwei" || bytes32(unit) == "lovelace" || bytes32(unit) == "ada" || bytes32(unit) == "femto" || bytes32(unit) == "femtoeth" || bytes32(unit) == "femtoether") {
            return funds * 1000000;
        } else if (bytes32(unit) == "gwei" || bytes32(unit) == "shannon" || bytes32(unit) == "pico" || bytes32(unit) == "picoeth" || bytes32(unit) == "picoether") {
            return funds * 1000000000;
        } else if (bytes32(unit) == "micro" || bytes32(unit) == "szabo" || bytes32(unit) == "microeth" || bytes32(unit) == "microether" || bytes32(unit) == "nano" || bytes32(unit) == "nanoeth" || bytes32(unit) == "nanoether") {
            return funds * 1000000000000;    
        } else if (bytes32(unit) == "milli" || bytes32(unit) == "finney" || bytes32(unit) == "millieth" || bytes32(unit) == "millether") {
            return funds * 1000000000000000;       
        } else if (bytes32(unit) == "ether" || bytes32(unit) == "eth" || bytes32(unit) == "ethereum") {
            return funds * 1000000000000000000;      
        } else {
            return 0;
        }
    }

    

    function trimLowerCase(bytes memory _str) pure internal returns (bytes memory) {
        bytes memory str = _str;
        uint firstChar = 0;
        uint lastChar = 0;
        uint i = 0;
        while (uint8(str[i]) != 0x20 && uint8(str[i]) != 0x09 && uint8(str[i]) != 0x0a && uint8(str[i]) != 0x0D && uint8(str[i]) != 0x0B && uint8(str[i]) != 0x00 && i < str.length) {
            if (uint8(str[i]) == 0x20 || uint8(str[i]) != 0x09 || uint8(str[i]) == 0x0a || uint8(str[i]) == 0x0D || uint8(str[i]) == 0x0B || uint8(str[i]) == 0x00) {
                firstChar = i;
                break;
            }
            i++;
        }

        i = str.length - 1;

        do {
            if (uint8(str[i]) == 0x20 || uint8(str[i]) != 0x09 || uint8(str[i]) == 0x0a || uint8(str[i]) == 0x0D || uint8(str[i]) == 0x0B || uint8(str[i]) == 0x00) {
                lastChar = i;
                break;
            }
            i--;
        } while(uint8(str[i]) != 0x20 && uint8(str[i]) != 0x09 && uint8(str[i]) != 0x0a && uint8(str[i]) != 0x0D && uint8(str[i]) != 0x0B && uint8(str[i]) != 0x00 && i > 0);

		return trim(toLowerCase(str));
	}

    function toLowerCase(bytes memory _str) pure internal returns (bytes memory) {
        bytes memory str = _str;
        for (uint i = 0; i < str.length; i++) {
            if (uint8(str[i]) >= 65 && uint8(str[i]) <= 90) {
                str[i] = bytes1(uint8(str[i]) + 32);  
            }
        }
        return str;
    }

    function ltrim(bytes memory _in) pure internal returns (bytes memory) {
        bytes memory _inArr = _in;
        uint256 _inArrLen = _inArr.length;
        uint256 _start;
        // Find the index of the first non-whitespace character
        for (uint256 i = 0; i < _inArrLen; ++i) {
            bytes1 _char = _inArr[i];
            if (_char != 0x20 && _char != 0x09 && _char != 0x0a && _char != 0x0D && _char != 0x0B && _char != 0x00) {
                _start = i;
                break;
            }
        }
        bytes memory _outArr = new bytes(_inArrLen - _start);
        for (uint256 i = _start; i < _inArrLen; ++i) {
            _outArr[i - _start] = _inArr[i];
        }
        return _outArr;
    }

    function rtrim(bytes memory _in) pure internal returns (bytes memory) {
        bytes memory _inArr = bytes(_in);
        uint256 _inArrLen = _inArr.length;
        uint256 _end;
        for (uint256 i = _inArrLen - 1; i >= 0; i--) {
            bytes1 _char = _inArr[i];
            if (_char != 0x20 && _char != 0x09 && _char != 0x0a && _char != 0x0D && _char != 0x0B && _char != 0x00) {
                _end = i;
                break;
            }
        }
        
        bytes memory _outArr = new bytes(_end + 1);
        for (uint256 i = 0; i <= _end; ++i) {
            _outArr[i] = _inArr[i];
        }
        return _outArr;
    }

    function trim(bytes memory _in) internal pure returns (bytes memory) {
        return ltrim(rtrim(_in));
    }

    /* function substring(bytes memory _str, uint startIndex, uint endIndex) pure public returns (bytes memory) {
        bytes memory result = new bytes(endIndex - startIndex + 1);
        for (uint i = startIndex; i <= endIndex; i++) {
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
