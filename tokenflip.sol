pragma solidity ^0.8.7;

contract test {
    
    uint256 internal fee;
    address payable owner;
    bytes32 public randomness;
    uint public random;
    uint public bet;
    uint public minimumBet = 1000000000000000;
    address payable public player;
    event Roll(address indexed, uint indexed, bool indexed);
    event Deposit(address indexed, uint indexed);
    event Withdraw(address indexed, uint indexed);
    
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
        require(bet >= minimumBet, "Bet must be at least 1000000000000000 wei");
        randomness = vrf();
        random = asciiToInteger(randomness);
        if (random % 2 == 0) {
            player.transfer(bet);
            player.transfer(bet);
            emit Roll(player, bet, true);
        }
        else {
            emit Roll(player, bet, false);
        }
    }
    function asciiToInteger(bytes32 x) public pure returns (uint256) {
    uint256 y;
    for (uint256 i = 0; i < 32; i++) {
        uint256 c = (uint256(x) >> (i * 8)) & 0xff;
        if (48 <= c && c <= 57)
            y += (c - 48) * 10 ** i;
        else if (65 <= c && c <= 90)
            y += (c - 65 + 10) * 10 ** i;
        else if (97 <= c && c <= 122)
            y += (c - 97 + 10) * 10 ** i;
        else
            break;
    }
    return y;
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
