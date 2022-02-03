// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract TestNFT is ERC721Enumerable, Ownable {
  using Strings for uint256;

  string baseURI;
  string public baseExtension = ".json";
  uint256 public cost = 0.02 ether;
  uint256 public maxSupply = 800;
  uint256 public maxMintAmount = 2;
  bool public whiteListMintPaused= true;
  bool public publicMintPaused= false;
  bool public revealed = false;
  string public notRevealedUri;
  bytes32 public whiteListMerkleRoot;



  constructor(
    string memory _name,
    string memory _symbol,
    string memory _initBaseURI,
    string memory _initNotRevealedUri
  ) ERC721(_name, _symbol) {
    setBaseURI(_initBaseURI);
    setNotRevealedURI(_initNotRevealedUri);
  }

      modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
        require(
            MerkleProof.verify(
                merkleProof,
                root,
                keccak256(abi.encodePacked(msg.sender))
            ),
            "Address does not exist in list"
        );
        _;
    }

  // ======= INTERNAL =======
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  // ======= PUBLIC ======= 
  function publicMint(uint256 _mintAmount) public payable
  {
    uint256 supply = totalSupply();
    require(!publicMintPaused, "public mint paused");
    require(_mintAmount > 0, "mint amount cannot be zero");
    require(_mintAmount <= maxMintAmount, "mint amount exceeds max");
    require(supply + _mintAmount <= maxSupply);

    if (msg.sender != owner()) {
      require(msg.value >= cost * _mintAmount);
    }

    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
    }
  }

  function whiteListMint(uint256 _mintAmount, bytes32[] calldata merkleProof) 
        public payable
        isValidMerkleProof(merkleProof, whiteListMerkleRoot)
  {
    uint256 supply = totalSupply();
    require(!whiteListMintPaused);
    require(_mintAmount > 0);
    require(_mintAmount <= maxMintAmount);
    require(supply + _mintAmount <= maxSupply); 
    
    if (msg.sender != owner()) {
      require(msg.value >= cost * _mintAmount);
    }

    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
    }
  }

  function walletOfOwner(address _owner)
    public
    view
    returns (uint256[] memory)
  {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    for (uint256 i; i < ownerTokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    
    if(revealed == false) {
        return notRevealedUri;
    }

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
  }

  // ===== ONLY OWNER =====
  function setWhiteListMerkleRoot(bytes32 merkleRoot) external onlyOwner {
        whiteListMerkleRoot = merkleRoot;
  }

  function reveal() public onlyOwner {
      revealed = true;
  }
  
  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }

  function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
    maxMintAmount = _newmaxMintAmount;
  }
  
  function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
    notRevealedUri = _notRevealedURI;
  }

  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }

  function pauseWhiteListMint(bool _state) public onlyOwner {
    whiteListMintPaused = _state;
  }

  function pausePublicMint(bool _state) public onlyOwner {
    publicMintPaused = _state;
  }

  function withdrawAll() public payable onlyOwner {
        uint256 _each = address(this).balance / 2;
        require(payable(owner()).send(_each));
        require(payable(0x121684501d2Fb3Ffd92E7a021D63F51b85504C08).send(_each));
  }
}
