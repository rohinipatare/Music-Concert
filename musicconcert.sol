//SPDX-License-Identifier: Unlicense
pragma solidity >=0.5.0 <0.9.0;


contract MusicConcertContract {
 struct Concert{
   address organizer;
   string singerName;
   string concertName;
   uint date; //0 1 2
   uint price;
   uint ticketCount;  //1 sec  0.5 sec
   uint ticketRemain;
 }


 mapping(uint=>Concert) public concerts;
 mapping(address=>mapping(uint=>uint)) public tickets;
 uint public nextId;
 

//Register new concert
 function createConcert(string memory singerName,string memory concertName,uint date,uint price,uint ticketCount) external{
   require(date>block.timestamp,"Enter Future Date!!! You can organize Concert for future date only!!!");
   require(ticketCount>0,"You can organize Concert only if you create more than 0 tickets!!!");


   concerts[nextId] = Concert(msg.sender,singerName,concertName,date,price,ticketCount,ticketCount);
   nextId++;
 }

//Buy tickets
 function buyTicket(uint id,uint quantity) external payable{
   require(concerts[id].date!=0,"Music Concert does not exist");
   require(concerts[id].date>block.timestamp,"Music Concert has already over");
   Concert storage _event = concerts[id];
   require(msg.value==(_event.price*quantity),"Insufficient Balance!!! Ethere in your wallet is not enough");
   require(_event.ticketRemain>=quantity,"Sorry!!!  Not enough tickets");
   _event.ticketRemain-=quantity;
   tickets[msg.sender][id]+=quantity;


 }

//Transfer your tickets to another address
 function transferTicket(uint id,uint quantity,address to) external{
   require(concerts[id].date!=0,"This Music Concert does not exist");
   require(concerts[id].date>block.timestamp,"This Music Concert has already over");
   require(tickets[msg.sender][id]>=quantity,"Sorry!!! You do not have enough tickets");
   tickets[msg.sender][id]-=quantity;
   tickets[to][id]+=quantity;
 }
}



