pragma solidity ^0.8.7;

contract coinflip {
    uint rollNumber = 1;
    uint guess = 1;
    
    constructor() {
        address payable winner = payable(msg.sender);
    }
    
    //function flip() public {
        
    //}
    function roll(address payable _winner) private returns(bool){
        require(guess == 1 || guess == 2);
        if (guess == rollNumber) {
            _winner.transfer(msg.value);
        }
        else {
            return false;
        }
    }
}
