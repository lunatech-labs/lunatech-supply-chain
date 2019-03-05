pragma solidity >=0.4.22;

 
contract TicketContract {
    string id;
 
 struct Ticket {
    string name;
    string host;
}

Ticket[] TicketList;

mapping(string  => Ticket) private ticketStore;

mapping(address => mapping(string => bool)) private ticketOwnerCheck;

enum TicketStatus { Available, onSale }


    function setId(string memory serial) public {
          id = serial;
    }
 
    function getId() public view returns (string memory) {
          return id;
    }
    
event createTicket(address account, string uuid, string manufacturer);
event ticketTransfer(address from, address to, string uuid);
event ticketSold(address from, address to, string uuid);


function ticketSold(address to, string memory uuid) public {
 
    if(!ticketStore[uuid].initialized) {
        emit RejectTransfer(msg.sender, to, uuid, "No ticket is found!!!");
        return;
    }
    
    if(ticketStore[uuid].status != AssetStatus.FoodManufacturing) {
         emit RejectTransfer(msg.sender, to, uuid, "Status of asset is not match");
        return;
    }
 
    if(!walletStore[msg.sender][uuid]) {
        emit RejectTransfer(msg.sender, to, uuid, "Sender does not own this asset.");
        return;
    }
 
    walletStore[msg.sender][uuid] = false;
    walletStore[to][uuid] = true;
    assetStore[uuid].status = AssetStatus.onTheWay;
    emit AssetTransfer(msg.sender, to, uuid);
}

function toDistributor(address to, string memory uuid) public {
 
    if(!assetStore[uuid].initialized) {
        emit RejectTransfer(msg.sender, to, uuid, "No asset with this UUID exists");
        return;
    }
    
    if(assetStore[uuid].status != AssetStatus.Available) {
         emit RejectTransfer(msg.sender, to, uuid, "Status of asset is not match");
        return;
    }
 
    if(!assetStore[msg.sender][uuid]) {
        emit RejectTransfer(msg.sender, to, uuid, "Sender does not own this ticket.");
        return;
    }
 
    ticketStore[msg.sender][uuid] = false;
    ticketStore[to][uuid] = true;
    ticketStore[uuid].status = AssetStatus.distributor;
    emit ticketTransfer(msg.sender, to, uuid);
}

function isOwnerOf(address owner, string memory uuid) public view returns (bool) {
 
    if(ticketStore[owner][uuid]) {
        return true;
    }
 
    return false;
}

function getStatus(string memory uuid) public view returns (TicketStatus) {

        return ticketStore[uuid].status;
    
}

}


