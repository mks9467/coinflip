// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract tokenflip {
    uint256 internal fee;
    address payable owner;
    uint public random;
    uint public bet;
    uint public minimumBet = 1;
    uint public winnings;
    address payable public player;
    event Roll(address indexed, uint indexed, bool indexed);
    event Deposit(address indexed, uint indexed);
    event Withdraw(address indexed, uint indexed);
    
    constructor() {
        owner = payable(msg.sender);
    }
    
    function deposit() public payable {
        emit Deposit(msg.sender, msg.value);
    }
    
    function withdraw(uint amount) public payable {
        require(msg.sender == owner);
        require(amount <= address(this).balance);
        owner.transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    function roll() public payable {
        player = payable(msg.sender);
        bet = msg.value;
        require(bet >= minimumBet, "Bet must be at least 1 wei");
        random = convert(vrf());
        if (random % 2 == 0) {
            winnings = bet + bet;
            player.transfer(winnings);
            emit Roll(player, bet, true);
        }
        else {
            emit Roll(player, bet, false);
        }
    }   
    function convert(bytes32 b) public pure returns(uint) {
        return uint(b);
    }
    function vrf() public view returns (bytes32 result) {
        uint[1] memory bn;
        bn[0] = block.number;
        assembly {
        let memPtr := mload(0x40)
        if iszero(staticcall(not(0), 0xff, bn, 0x20, memPtr, 0x20)) {
            invalid()
        }
        result := mload(memPtr)
        }
    }
}
