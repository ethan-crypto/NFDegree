// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";

contract NFDegree is ERC721URIStorage, KeeperCompatibleInterface {
    uint public tokenCount;
    uint public immutable interval;
    uint public lastTimeStamp;

    mapping(address => bool) graduated_users;

    // tokenIds -> counter
    mapping(uint => uint) transferCounter;

    constructor(uint updateInterval) ERC721("UT NFT Degrees", "NFDEGREE"){
        interval = updateInterval;
        lastTimeStamp = block.timestamp;
    }

    function checkUpkeep(bytes calldata ) external override 
    returns(bool upkeedNeeded, bytes memory performData) {
        upkeedNeeded = (block.timestamp - lastTimeStamp) > interval;
    }
    function updateGraduates(address [] calldata graduates) external virtual override {
        for(uint i = 0; i < graduates.length; i++){
            graduated_users[graduates[i]] = true;
        }
    }
    function mintDegree(string memory _tokenURI) external returns(uint) {
        require(graduated_users[msg.sender], "User has not graduated yet");
        tokenCount ++;
        _safeMint(msg.sender, tokenCount);
        _setTokenURI(tokenCount, _tokenURI);
        return(tokenCount);
    }

}