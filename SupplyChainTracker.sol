// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChainTracker {
    struct Product {
        uint id;
        string name;
        string status;
        address currentOwner;
        uint timestamp;
    }

    mapping(uint => Product) public products;
    uint public productCount;

    event ProductUpdated(uint id, string name, string status, address currentOwner, uint timestamp);

    function addProduct(string memory _name) public {
        productCount++;
        products[productCount] = Product(productCount, _name, "Created", msg.sender, block.timestamp);
        emit ProductUpdated(productCount, _name, "Created", msg.sender, block.timestamp);
    }

    function updateStatus(uint _id, string memory _status) public {
        Product storage product = products[_id];
        require(msg.sender == product.currentOwner, "Not authorized");
        product.status = _status;
        product.timestamp = block.timestamp;
        emit ProductUpdated(_id, product.name, _status, msg.sender, block.timestamp);
    }

    function transferOwnership(uint _id, address _newOwner) public {
        Product storage product = products[_id];
        require(msg.sender == product.currentOwner, "Not authorized");
        product.currentOwner = _newOwner;
        emit ProductUpdated(_id, product.name, product.status, _newOwner, block.timestamp);
    }
}