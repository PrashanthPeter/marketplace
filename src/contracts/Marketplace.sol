pragma solidity ^0.5.0;

contract Marketplace {
    string public name;
    uint256 public productCount = 0;
    mapping(uint256 => Product) public products;

    struct Product {
        uint256 id;
        string name;
        uint256 price;
        address payable owner;
        bool purchased;
    }

    event ProductCreated(
        uint256 id,
        string name,
        uint256 price,
        address payable owner,
        bool purchased
    );

        event ProductPurchased(
        uint256 id,
        string name,
        uint256 price,
        address payable owner,
        bool purchased
    );

    constructor() public {
        name = "Dapp University Marketplace";
    }

    function createProduct(string memory _name, uint256 _price) public {
        require(bytes(_name).length > 0);
        require(_price > 0);

        productCount++;

        products[productCount] = Product(
            productCount,
            _name,
            _price,
            msg.sender,
            false
        );

        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }

    function purchaseProduct(uint _id) public payable {
        //   fetch the product
        Product memory _product = products[_id];
        //    fetch the owner
        address payable _seller = _product.owner;
        // make sure the product has a valid id
        require(_product.id > 0 && _product.id <= productCount);
        // Require that there is enough Ether in the transaction
        require(msg.value >= _product.price);
        // Require that the product has not been purchases already
        require(!_product.purchased);
        // Require that the buyer is not the seller
        require(_seller != msg.sender);
       // Transfer ownership to the buyer
        _product.owner = msg.sender;
        // mark as purchasedK
        _product.purchased = true;
        // Update the product
        products[_id] = _product;
        // pay the seller by sending them Ether
        address(_seller).transfer(msg.value);

         emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true);
    }
}
