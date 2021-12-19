// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract tokenflip is Ownable{
    IERC20 public _token;
    uint public winnings;
    address public player;
    event Roll(address indexed, uint indexed, bool indexed);
    event Deposit(address indexed, uint indexed);
    event Withdraw(address indexed, uint indexed);
    
    constructor(IERC20 token) {
        _token = token;
    }
    
    function deposit(uint256 amount) public payable {
        _token.transferFrom(msg.sender, address(this), amount);
        emit Deposit(msg.sender, amount);
    }
    
    function withdraw(uint256 amount) public onlyOwner {
        require(amount <= _token.balanceOf(address(this)));
        _token.transfer(msg.sender, amount);
        emit Withdraw(msg.sender, amount);
    }

    function roll(uint256 bet) public returns(bool) {
        player = msg.sender;
        _token.transferFrom(player, address(this), bet);
        require(bet < _token.balanceOf(msg.sender));
        if (random() % 2 == 0) {
            winnings = bet + bet;
            _token.transfer(player, winnings);
            emit Roll(player, bet, true);
            return true;
        }
        else {
            emit Roll(player, bet, false);
            return false;
        }
    }   
    function balance() public view returns(uint) {
        return _token.balanceOf(address(this));
    }
    function random() public view returns (uint) {
        return uint(keccak256(abi.encode(block.difficulty, block.timestamp)));
    } 
}
