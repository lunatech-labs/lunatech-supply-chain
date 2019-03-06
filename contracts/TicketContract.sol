pragma solidity >=0.4.22;

 
contract TicketContract {
    string id;
 
 struct Ticket {
    string name;
    string host;
    bool initialized;
    TicketStatus status;
}

Ticket[] TicketList;

mapping(string  => Ticket) private ticketStore;

mapping(address => mapping(string => bool)) private ticketOwner;

enum TicketStatus { Available, onSale, Sold }


    function setId(string memory serial) public {
          id = serial;
    }
 
    function getId() public view returns (string memory) {
          return id;
    }
    
event createTicket(address account, string uuid, string manufacturer);
event ticketTransfer(address from, address to, string uuid);
event ticketSold(address from, address to, string uuid);
event RejectTransfer(address from, address to, string uuid, string message);


function ticketSell(address to, string memory uuid) public {
 
    if(!ticketStore[uuid].initialized) {
        emit RejectTransfer(msg.sender, to, uuid, "Duplicate Tickets!!!");
        return;
    }
    
    if(ticketStore[uuid].status != TicketStatus.Available) {
         emit RejectTransfer(msg.sender, to, uuid, "Status of Ticket is not match");
        return;
    }
 
    if(!ticketOwner[msg.sender][uuid]) {
        emit RejectTransfer(msg.sender, to, uuid, "Seller does not own this Ticket.");
        return;
    }
 
    ticketOwner[msg.sender][uuid] = false;
    ticketOwner[to][uuid] = true;
    ticketStore[uuid].status = TicketStatus.Sold;
    emit ticketSold(msg.sender, to, uuid);
}



function isOwnerOf(address owner, string memory uuid) public view returns (bool) {
 
    if(ticketOwner[owner][uuid]) {
        return true;
    }
 
    return false;
}

function getStatus(string memory uuid) public view returns (TicketStatus) {

        return ticketStore[uuid].status;
    
}

}


