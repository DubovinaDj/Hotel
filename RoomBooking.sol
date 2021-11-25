// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HotelRoom {

    uint public roomPrice = 0.01 ether;     // 10000000000000000 Wei
    address payable public owner;           //state variable ethereum address type. Payable because owner of contract can receive ethers/payment
    enum Status {Empty, Booked}             //represent room status
    Status public statuses;

    event LogBookRoom(address boook, uint value);

    constructor() {
        owner = payable(msg.sender);          //ethereum addres of user how call this function, owner of contract
        statuses = Status.Empty;
    }

    modifier IsRoomEmpty {
        require(statuses == Status.Empty, "Currently booked.");  
        _;     
    }

    function book() external payable IsRoomEmpty returns (uint balance)  {
        require(msg.value == roomPrice, "Room is 0.01 ether");

        uint balanceBeforeTransfer = address(this).balance;
        statuses = Status.Booked;
        owner.transfer(msg.value);
        emit LogBookRoom(msg.sender, msg.value);

        assert(address(this).balance == balanceBeforeTransfer - msg.value);
        return address(this).balance;
    }
}