pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FanTuneZArtist is ERC721, Ownable, IERC721Receiver {
    string public artistURI;
    uint256 public totalSupply;
    bool public saleEnabled;

    mapping(uint256 => string) private _uri;
    mapping(uint256 => uint256) public _price;

    event onArtistURIChanged(string _artistUri);
    event onMint(uint256 tokenId,string _uri, uint256 price);
    event onURIChanged(uint256 tokenId,string _uri);
    event onPriceChanged(uint256 tokenId,uint256 price);
    event onSold(uint256 tokenId, address to, uint256 saleAmount);

    event onSaleStatusChanged(bool status);


    constructor(
        string memory _name,
        string memory _symbol,
        string memory _artistURI
    ) ERC721(_name, _symbol) {
        artistURI = _artistURI;
    }

    function setArtistURI(string memory _artistURI) public  onlyOwner{
        artistURI = _artistURI;
        emit onArtistURIChanged(_artistURI);
    }


     function flipSale() public onlyOwner{
        saleEnabled = !saleEnabled;
        emit onSaleStatusChanged(saleEnabled);
    }


    function createNft(uint256 quantity,string memory uri, uint256 price) external onlyOwner {
        require(quantity > 0,"invalid quantity");

        uint256 index =totalSupply;
        for(uint256 i = 0; i< quantity ;i++){
            _safeMint(address(this),index);
            _price[index] = price;
            _uri[index] = uri;
            emit onMint(index,uri,price);
            index = index+1;
        }
        totalSupply =index;
    }

    


    function changeURI(uint256 tokenId, string memory uri) public onlyOwner {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        require(ownerOf(tokenId)== address(this), "Sold Out");
        _uri[tokenId] = uri;
        emit onURIChanged(tokenId, uri);
    }




     function changePrice(uint256 tokenId, uint256 price) public onlyOwner {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        require(ownerOf(tokenId)== address(this), "Sold Out");
        _price[tokenId] = price;
        emit onPriceChanged(tokenId, price);(tokenId, price);
    }


    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return _uri[tokenId];
    }



    function withdrawAmount() public onlyOwner{
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }




    function withdrawAmount(IERC20 token) public onlyOwner{
        uint256 balance =token.balanceOf(address(this));
       token.transfer(msg.sender,balance);
    }



    function buy(uint256 tokenId) public payable {
        require(ownerOf(tokenId)== address(this), "Sold Out");
        require(msg.value >= _price[tokenId], "Invalid Price");
        require(saleEnabled, "Sale not Enabled");
        IERC721(address(this)).safeTransferFrom(address(this), msg.sender, tokenId);
        emit onSold(tokenId, msg.sender,msg.value);
    }



    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external  override returns (bytes4){
        return 0x150b7a02;

    }
}

