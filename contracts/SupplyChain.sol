pragma solidity >=0.4.22;

 
contract SupplyChain {
    string id;
 
 struct Asset {
    string name;
    string description;
    string manufacturer;
    AssetStatus status;
    bool initialized;    
}

mapping(string  => Asset) private assetStore;

mapping(address => mapping(string => bool)) private walletStore;

enum AssetStatus { FoodManufacturing, onTheWay, distributor, RetailWarehouse, Store }


    function setId(string memory serial) public {
          id = serial;
    }
 
    function getId() public view returns (string memory) {
          return id;
    }
    
event AssetCreate(address account, string uuid, string manufacturer);
event RejectCreate(address account, string uuid, string message);
event AssetTransfer(address from, address to, string uuid);
event RejectTransfer(address from, address to, string uuid, string message);

function createAsset (string memory name, string memory description, string memory uuid, string memory manufacturer) public {
 
    if(assetStore[uuid].initialized) {
        emit RejectCreate(msg.sender, uuid, "Asset with this UUID already exists.");    
        return;
      }
 
      assetStore[uuid] = Asset(name, description, manufacturer, AssetStatus.onTheWay, true);
      walletStore[msg.sender][uuid] = true;
      emit AssetCreate(msg.sender, uuid, manufacturer);
}

function getAssetByUUID(string memory uuid) view public returns (string memory, string memory, string memory)  {
 
    return (assetStore[uuid].name, assetStore[uuid].description, assetStore[uuid].manufacturer);
 
}

function assetOnTheWay(address to, string memory uuid) public {
 
    if(!assetStore[uuid].initialized) {
        emit RejectTransfer(msg.sender, to, uuid, "No asset with this UUID exists");
        return;
    }
    
    if(assetStore[uuid].status != AssetStatus.FoodManufacturing) {
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
    
    if(assetStore[uuid].status != AssetStatus.onTheWay) {
         emit RejectTransfer(msg.sender, to, uuid, "Status of asset is not match");
        return;
    }
 
    if(!walletStore[msg.sender][uuid]) {
        emit RejectTransfer(msg.sender, to, uuid, "Sender does not own this asset.");
        return;
    }
 
    walletStore[msg.sender][uuid] = false;
    walletStore[to][uuid] = true;
    assetStore[uuid].status = AssetStatus.distributor;
    emit AssetTransfer(msg.sender, to, uuid);
}

function isOwnerOf(address owner, string memory uuid) public view returns (bool) {
 
    if(walletStore[owner][uuid]) {
        return true;
    }
 
    return false;
}

function getStatus(string memory uuid) public view returns (AssetStatus) {

        return assetStore[uuid].status;
    
}

}


