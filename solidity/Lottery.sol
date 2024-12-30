// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address payable[] public participants;
    address public manager;
    address payable winner;

    constructor()
    {
        manager=msg.sender;
    }
    receive() external payable 
    {    
        require(msg.value==1 ether);
        participants.push(payable(msg.sender));
    }
    function getBalance()public view returns(uint)
    {
        require(msg.sender==manager);
        return address(this).balance;
    }
    function random() public view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,participants.length)));
    }
    function selectWinner() public
    {
        require(msg.sender==manager);
        require(participants.length >= 3);
        uint temp = random();
        uint index = temp %  participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
    }

    function winnerAddress() public view returns(address)
    {
        return address(winner);
    }

    function reset()public  
    {
        participants = new address payable[](0);
    }
}