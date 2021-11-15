// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract coinflip is VRFConsumerBase {
    
    bytes32 internal keyHash;
    uint256 internal fee;
    address payable owner;
    uint256 public randomResult;
    uint public bet;
    uint public minimumBet = 1000000000000000;
    address payable public player;
    event Roll(address indexed, uint indexed, bool indexed);
    event Deposit(address indexed, uint indexed);
    event Withdraw(address indexed, uint indexed);
    
    constructor() 
        VRFConsumerBase(
            0x3d2341ADb2D31f1c5530cDC622016af293177AE0, // VRF Coordinator
            0xb0897686c545045aFc77CF20eC7A532E3120E0F1  // LINK Token
        )
    
    {
        keyHash = 0xf86195cf7690c55907b2b611ebb7343a6f649bff128701cc542f0569e2c549da;
        fee = 0.0001 * 10 ** 18;
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

    function roll() public payable returns(bytes32 requestId) {
        player = payable(msg.sender);
        bet = msg.value;
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK");
        require(bet >= minimumBet, "Bet must be at least 1000000000000000 wei");
        requestId = requestRandomness(keyHash, fee);
        return requestId;
    }
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = (randomness % 100) + 1;
        require(randomResult <= 100 && randomResult >= 1);
        if (randomResult > 50) {
            player.transfer(bet);
            player.transfer(bet);
            emit Roll(player, bet, true);
        }
        else {
            emit Roll(player, bet, false);
        }
        
    }
}

