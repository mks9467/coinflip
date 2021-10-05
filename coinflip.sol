pragma solidity ^0.8.7;

contract coinflip {
    uint rollNumber = 67;
    uint bet;
    address payable winner;
    event Roll(address payable indexed, uint, bool);
    
    function deposit() public payable {
        
    }

    function roll() public payable {
        winner = payable(msg.sender);
        bet = msg.value;
        require(rollNumber <= 100 && rollNumber >= 1);
        if (rollNumber > 50) {
            winner.transfer(bet);
            emit Roll(winner, bet, true);
        }
        else {
            emit Roll(winner, bet, false);
        }
    }
}
