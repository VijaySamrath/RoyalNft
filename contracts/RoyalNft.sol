// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RoyalNft is ERC721, ERC721Enumerable, Ownable {

    uint96 royaltyFeesInBips;
    address royaltyReceiver; 
    string public contractURI;

    constructor(uint96 _royaltyFeesInBips , string memory _contractURI) ERC721("MyNft", "MTK") {
        royaltyFeesInBips = _royaltyFeesInBips;
        contractURI = _contractURI;
        royaltyReceiver = msg.sender;
    }

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return interfaceId == 0x2a55205a || super.supportsInterface(interfaceId);
    }

     function royaltyInfo(
        uint256 _tokenId,
        uint256 _salePrice
    ) external view returns (
        address receiver,
        uint256 royaltyAmount
    ){
        return(royaltyReceiver, calculateRoyalty(_salePrice));
}

    function calculateRoyalty(uint _salePrice) view public returns(uint){
        return(_salePrice / 10000) * royaltyFeesInBips;

    }

    function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
        royaltyReceiver = _receiver;
        royaltyFeesInBips = _royaltyFeesInBips;
    }

    function setContractURI(string calldata _contractURI) public onlyOwner{
        contractURI = _contractURI;
    }
}