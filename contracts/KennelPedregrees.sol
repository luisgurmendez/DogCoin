pragma solidity ^0.4.18;

import "./lib/strings.sol";

contract KennelPedigrees {
  using strings for *;

  struct Kennel {
    address kennelAddress;
    string name;
    string id;
    bool exists;
  }

  struct Dog {
    uint256 dogId; // id kennel + id dog
    address owner;
    string breed;
    string name;
    uint256 fatherId;
    uint256 motherId;
    uint256 price;
    bool onSale;
    bool exists;
  }

  struct ApprovalStruct {
    address owner;
    address recipient;
    bool exists;
  }

	mapping (address => Kennel) kennels;
  mapping (uint256 => Dog) dogs;
  mapping (uint256 => ApprovalStruct) internal approvals;

  address contractOwner;

  event Approval(address owner, address to, uint256 tokenId);

  event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);

  constructor() public {
    contractOwner = msg.sender;
  }

  modifier onlyContractOwner() {
    require(msg.sender == contractOwner);
    _;
  }

  modifier onlyKennels() {
    require(kennels[msg.sender].exists);
    _;
  }

  modifier onlyDogOwner(uint256 dogId){
    require(dogs[dogId].owner == msg.sender);
    _;
  }

  function setDogPrice(uint256 dogId, uint256 price) public onlyDogOwner(dogId){
    dogs[dogId].price = price;
  }

  function setDogOnSale(uint256 dogId, bool onSale) public onlyDogOwner(dogId){
    dogs[dogId].onSale = onSale;
  }

  function buyDog(uint256 dogId) public payable {
    Dog memory dog = dogs[dogId];
    require(dog.exists);
    require(dog.onSale);
    require(msg.value == dog.price);
    require(msg.sender != dog.owner);

    _transferAndPayDog(dogId, msg.sender);

  }

  function _transferAndPayDog(uint256 dogId, address newOwner ) internal {
    address pastOwner = dogs[dogId].owner;
    dogs[dogId].owner = newOwner;
    dogs[dogId].onSale = false;
    pastOwner.transfer(dogs[dogId].price);
  }

  function addKennel(address kennelAddress, string name, string id) public onlyContractOwner() returns(bool) {
    if (kennels[kennelAddress].exists) {
      return false;
    } else {
      kennels[kennelAddress] = Kennel(kennelAddress, name, id, true);
      return true;
    }
  }

  function addDog(string dogId, string breed, string name, uint256 fatherId, uint256 motherId) public onlyKennels() returns(bool) {
    Kennel memory kennel = kennels[msg.sender];
    string memory kennelId = kennel.id;
    string memory joinedId = kennelId.toSlice().concat(dogId.toSlice());
    uint256 joinedIdInt = uint256(keccak256(abi.encodePacked(joinedId)));
    Dog memory dog = dogs[joinedIdInt];
    if (dog.exists) {
      return false;
    } else {
      Dog memory newDog = Dog(joinedIdInt, msg.sender,  breed, name, fatherId, motherId, 0, false, true);
      dogs[joinedIdInt] = newDog;
      return true;
    }
  }

  function searchDog(string kennelId, string dogId) public view returns(uint256, string, string, uint256, uint256) {
    string memory joinedId = kennelId.toSlice().concat(dogId.toSlice());
    uint256 joinedIdInt = uint256(keccak256(abi.encodePacked(joinedId)));
    Dog memory dog = dogs[joinedIdInt];
    if (dog.exists) {
      return (dog.dogId, dog.breed, dog.name, dog.fatherId, dog.motherId);
    } else {
      /* doggo no existe */
      return;
    }
  }


  // ERC-721
  /* function totalSupply() public constant returns (uint256) { */
    // Guardar un array de los doggos ids, y retornar el length.
    /* return dogs; */
  /* } */

  /* function balanceOf(address _owner) public constant returns (uint256 balance){ */
    // iterar en el doggo array y fijarse si el address
    // es igual que el _owner y retornar un count.
  /* } */

  function ownerOf(uint256 _dogId) public constant returns (address){
     require(dogs[_dogId].exists);
     return dogs[_dogId].owner;
  }

  function approve(address _to, uint256 _dogId) public {
    address owner = ownerOf(_dogId);

    require(msg.sender == owner); // Sender is owner of doggo
    require(dogs[_dogId].exists); // Dog with _dogId exists.
    require(msg.sender != _to); // Sender is recipient

    if (_to != address(0)) {
      approvals[_dogId].owner = owner;
      approvals[_dogId].recipient = _to;
      approvals[_dogId].exists = true;

    } else {
      if(!approvals[_dogId].exists){
        return;
      }
      approvals[_dogId].exists = false;
    }
    emit Approval(owner, _to, _dogId);

  }

  function takeOwnership(uint256 _dogId) public {
    require(approvals[_dogId].exists); // Approval for doggo od _dogId exists
    require(approvals[_dogId].recipient == msg.sender); // Recipient of approval for doggo of _dogId is the sender
    require(msg.sender != ownerOf(_dogId)); // Sender is not the owner of doggo

    emit Transfer(approvals[_dogId].owner, msg.sender, _dogId);

    dogs[_dogId].owner = msg.sender;
    approvals[_dogId].exists = false;
    approvals[_dogId].recipient = address(0); // correct?
    approvals[_dogId].owner = address(0); //correct?
  }

  function transfer(address _to, uint256 _tokenId) public view {
    require(msg.sender == ownerOf(_tokenId));
    require(dogs[_tokenId].exists);
    require(_to != 0);

  }
}
