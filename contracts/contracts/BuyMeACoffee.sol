// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract BuyMeACoffee {
   // Deployed to Goerli at : 0x1830Bd47d9F3C6a8450aB6579129a80207F2eD9f
   /**
    * @dev emit  an event "NewMemo" when a new memo is created 
    */
   event NewMemo(
    address indexed from,
    uint256 timestamp,
    string name,
    string message
   );

   /**
    * @dev create a memo struct to store elements of a memo
    * a "from" address which is the address of the sender
    * the "timestamp"
    * the "name" of sender
    * a "message" sender stores on the blockchain
    */

   struct Memo {
    address from;
    uint256 timestamp;
    string name;
    string message;
   }
   /**
    * @dev list all the "memos" received from fans and friends in
    * a "Memo" array of type struct
    */
   Memo[] public memos;
   
   /**
    * @dev set the "address" of the contract "deployer" as the owner
    * @dev "owner" address payable so that it can receive eth in the contract
    */
   address payable owner;

   constructor() {
    owner =  payable(msg.sender);
   }
   
   /**
    * @dev buyCoffee fro contract owner
    * @param _name name of the coffee buyer
    * @param _message a message from the coffee buyer 
    * Emit a ""NewMemo" event"
    */
   function buyCoffee(string memory _name, string memory _message)
   public
   payable
    {
      /**
       * @notice coffee costs money , it's not free
       */
      require(msg.value > 0, "You cannot buy a coffee with 0 eth");
      /**
       * @dev create a "Memo" struct instance and store it in "memos" array
       */
      memos.push(Memo({ 
        from: msg.sender,
        timestamp: block.timestamp,
        name: _name,
        message: _message
    }));
    emit NewMemo(msg.sender, block.timestamp, _name, _message);
   }

   /**
    * @dev "withdraw" function to withdraw eth stored in the contract
    */
   function withdraw(address payable _to) public onlyOwner {
      (bool sent, ) = _to.call{value: address(this).balance}("");
      require(sent, "Failed to send ether");
      
   }

   /**
    * @dev "getMemo" function to get "memos" 
    */
   function getMemo() public view returns (Memo[] memory) {
      return memos;
   }

   /**
    * @dev function getBalance() to get the contract balance
    */
   function getBalance() public view onlyOwner returns(uint) {
    return address(this).balance;
   }

   /**
    * @dev modifier onlyOwner to restrict access to only owxner
    */
   modifier onlyOwner {
     require( msg.sender == owner, "You are not authorized to withdraw");
     _;
   }
   /**
    * @notice make contract receive ether
    */
   receive() external payable {}
   fallback() external payable {}
}
