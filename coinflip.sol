pragma solidity ^0.8.7;

contract coinflip {
    uint rollNumber = 1;
    uint guess = 1;
    event Roll(address payable indexed, uint, bool);
    
    function start() public payable {
        address payable winner = payable(msg.sender);
        uint bet = msg.value;
        roll(winner, bet);
    }
    
    function roll(address payable _winner, uint _bet) private {
        require(guess == 1 || guess == 2);
        if (guess == rollNumber) {
            _winner.transfer(_bet);
            emit Roll(_winner, _bet, true);
        }
        else {
            emit Roll(_winner, _bet, false);
        }
    }
}
