pragma solidity ^0.8.7;

contract coinflip {
    uint rollNumber = 1;
    uint guess = 1;
    uint bet;
    address payable winner;
    event Roll(address payable indexed, uint, bool);
    
    function deposit() public payable {
        
    }

    function roll() public payable {
        winner = payable(msg.sender);
        bet = msg.value;
        require(guess == 1 || guess == 2);
        if (guess == rollNumber) {
            winner.transfer(bet);
            emit Roll(winner, bet, true);
        }
        else {
            emit Roll(winner, bet, false);
        }
    }
}
