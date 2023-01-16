//SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import 'base64-sol/base64.sol';

import './rolls/interfaces/IRoll1.sol';
import './rolls/interfaces/IRoll2.sol';
import './rolls/interfaces/IRoll3.sol';
import './rolls/interfaces/IRoll4.sol';
import './rolls/interfaces/IRoll5.sol';
import './rolls/interfaces/IRoll6.sol';

import './library/HexStrings.sol';
import './library/ToColor.sol';
import './library/SVGUtils.sol';

import "hardhat/console.sol";

contract Paradice is ERC721 {
    using Strings for uint256;
    using HexStrings for uint160;
    using ToColor for bytes3;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    mapping (uint256 => bytes3) public glow; // NOT USED RIGHT NOW!!!
    mapping (uint256 => mapping (uint256 => uint256)) public roll; // tokenId => (roll # => roll result)

    // mint deadline
    uint256 mintDeadline = block.timestamp + 24 hours; // MODIFY!

    // mint price
    uint256 mintPrice = 0;

    // dice positional (center)
    uint16 private constant offsetDice1 = 167;
    uint16 private constant offsetDice2 = 500;
    uint16 private constant offsetDice3 = 833;
    uint16 private constant offsetDice4 = 1167;
    uint16 private constant offsetDice5 = 1500;
    uint16 private constant offsetDice6 = 1833;

    // roll contracts
    address public roll1;
    address public roll2;
    address public roll3;
    address public roll4;
    address public roll5;
    address public roll6;

    constructor(
        address _roll1,
        address _roll2,
        address _roll3,
        address _roll4,
        address _roll5,
        address _roll6
    ) public ERC721("Paradice", "DICE") {
        roll1 = _roll1;
        roll2 = _roll2;
        roll3 = _roll3;
        roll4 = _roll4;
        roll5 = _roll5;
        roll6 = _roll6;
    }

    function mintItem() public payable returns (uint256) {
        require(msg.value >= mintPrice, "NOT ENOUGH FUNDS SENT TO MINT");
        require(block.timestamp < mintDeadline, "DONE MINTING");

        _tokenIds.increment();
        uint256 id = _tokenIds.current();

        _mint(msg.sender, id);

        bytes32 predictableRandom = keccak256(abi.encodePacked(blockhash(block.number-1), msg.sender, address(this), id, block.timestamp));
        glow[id] = bytes2(predictableRandom[0]) | ( bytes2(predictableRandom[1]) >> 8 ) | ( bytes3(predictableRandom[2]) >> 16 );
        for(uint256 i = 0; i < 6; i++) {
            uint256 iRoll = 1+((6*uint256(uint8(predictableRandom[3*(i*2)])))/255);
            if(iRoll > 6) {
                iRoll = 1+((6*uint256(uint8(predictableRandom[3*((i-1)*2)])))/255);
            }
            roll[id][i] = iRoll;
        }

        return id;
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        require(_exists(id), "tokenId does not exist");
        
        string memory name = string(abi.encodePacked('Roll #',id.toString()));
        string memory description = string(abi.encodePacked(
            'Roll results - ',
            SVGUtils.uint2str(roll[id][0]),
            SVGUtils.uint2str(roll[id][1]),
            SVGUtils.uint2str(roll[id][2]),
            SVGUtils.uint2str(roll[id][3]),
            SVGUtils.uint2str(roll[id][4]),
            SVGUtils.uint2str(roll[id][5])
        ));
        // generate svg
        string memory image = Base64.encode(bytes(generateSVGofTokenById(id)));
        // return metadata
        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            name,
                            '", "description":"',
                            description,
                            '", "external_url":"https://ipfs.io.ipfs/',
                            id.toString(),
                            '",',
                            '"owner":"',
                            (uint160(ownerOf(id))).toHexString(20),
                            '", "image": "',
                            'data:image/svg+xml;base64,',
                            image,
                            '"}'
                        )
                    )
                )
            )   
        );
    }

    function generateSVGofTokenById(uint256 id) public view returns (string memory) {
        string memory svg = string(abi.encodePacked(
            '<svg width="2000" height="2000" viewBox="0 0 2000 2000" fill="none" xmlns="http://www.w3.org/2000/svg">',
                renderTokenById(id),
            '</svg>'
        ));

        return svg;
    }

    function renderTokenById(uint256 id) internal view returns (string memory) {
        string memory renderRollBackground = string(abi.encodePacked(
            '<g >',
                '<rect width="2000" height="2000" fill="#000000"/>',
            '</g>'
        ));

        // get the roll results for each index
        uint256 roll1Index = roll[id][0];
        uint256 roll2Index = roll[id][1];
        uint256 roll3Index = roll[id][2];
        uint256 roll4Index = roll[id][3];
        uint256 roll5Index = roll[id][4];
        uint256 roll6Index = roll[id][5];

        // take each roll index and render it
        uint8 filterId;
        string memory renderRoll1;
        string memory renderRoll2;
        string memory renderRoll3;
        string memory renderRoll4;
        string memory renderRoll5;
        string memory renderRoll6;
        // index 1
        if (roll1Index == 1) {
            renderRoll1 = IRoll1(roll1).renderRoll1(0, 0);
            filterId + 1;
        } else if (roll1Index == 2) {
            renderRoll1 = IRoll2(roll2).renderRoll2(0, 0);
            filterId + 2;
        } else if (roll1Index == 3) {
            renderRoll1 = IRoll3(roll3).renderRoll3(0, 0);
            filterId + 3;
        } else if (roll1Index == 4) {
            renderRoll1 = IRoll4(roll4).renderRoll4(0, 0);
            filterId + 4;
        } else if (roll1Index == 5) {
            renderRoll1 = IRoll5(roll5).renderRoll5(0, 0);
            filterId + 5;
        } else if (roll1Index == 6) {
            renderRoll1 = IRoll6(roll6).renderRoll6(0, 0);
            filterId + 6;
        }
        // index 2
        if (roll2Index == 1) {
            renderRoll2 = IRoll1(roll1).renderRoll1(1, 6);
            filterId + 1;
        } else if (roll2Index == 2) {
            renderRoll2 = IRoll2(roll2).renderRoll2(1, 6);
            filterId + 2;
        } else if (roll2Index == 3) {
            renderRoll2 = IRoll3(roll3).renderRoll3(1, 6);
            filterId + 3;
        } else if (roll2Index == 4) {
            renderRoll2 = IRoll4(roll4).renderRoll4(1, 6);
            filterId + 4;
        } else if (roll2Index == 5) {
            renderRoll2 = IRoll5(roll5).renderRoll5(1, 6);
            filterId + 5;
        } else if (roll2Index == 6) {
            renderRoll2 = IRoll6(roll6).renderRoll6(1, 6);
            filterId + 6;
        }
        // index 3
        if (roll3Index == 1) {
            renderRoll3 = IRoll1(roll1).renderRoll1(2, 12);
            filterId + 1;
        } else if (roll3Index == 2) {
            renderRoll3 = IRoll2(roll2).renderRoll2(2, 12);
            filterId + 2;
        } else if (roll3Index == 3) {
            renderRoll3 = IRoll3(roll3).renderRoll3(2, 12);
            filterId + 3;
        } else if (roll3Index == 4) {
            renderRoll3 = IRoll4(roll4).renderRoll4(2, 12);
            filterId + 4;
        } else if (roll3Index == 5) {
            renderRoll3 = IRoll5(roll5).renderRoll5(2, 12);
            filterId + 5;
        } else if (roll3Index == 6) {
            renderRoll3 = IRoll6(roll6).renderRoll6(2, 12);
            filterId + 6;
        }
        // index 4
        if (roll4Index == 1) {
            renderRoll4 = IRoll1(roll1).renderRoll1(3, 18);
            filterId + 1;
        } else if (roll4Index == 2) {
            renderRoll4 = IRoll2(roll2).renderRoll2(3, 18);
            filterId + 2;
        } else if (roll4Index == 3) {
            renderRoll4 = IRoll3(roll3).renderRoll3(3, 18);
            filterId + 3;
        } else if (roll4Index == 4) {
            renderRoll4 = IRoll4(roll4).renderRoll4(3, 18);
            filterId + 4;
        } else if (roll4Index == 5) {
            renderRoll4 = IRoll5(roll5).renderRoll5(3, 18);
            filterId + 5;
        } else if (roll4Index == 6) {
            renderRoll4 = IRoll6(roll6).renderRoll6(3, 18);
            filterId + 6;
        }
        // index 5
        if (roll5Index == 1) {
            renderRoll5 = IRoll1(roll1).renderRoll1(4, 24);
            filterId + 1;
        } else if (roll5Index == 2) {
            renderRoll5 = IRoll2(roll2).renderRoll2(4, 24);
            filterId + 2;
        } else if (roll5Index == 3) {
            renderRoll5 = IRoll3(roll3).renderRoll3(4, 24);
            filterId + 3;
        } else if (roll5Index == 4) {
            renderRoll5 = IRoll4(roll4).renderRoll4(4, 24);
            filterId + 4;
        } else if (roll5Index == 5) {
            renderRoll5 = IRoll5(roll5).renderRoll5(4, 24);
            filterId + 5;
        } else if (roll5Index == 6) {
            renderRoll5 = IRoll6(roll6).renderRoll6(4, 24);
            filterId + 6;
        }
        // index 6
        if (roll6Index == 1) {
            renderRoll6 = IRoll1(roll1).renderRoll1(5, 30);
            filterId + 1;
        } else if (roll6Index == 2) {
            renderRoll6 = IRoll2(roll2).renderRoll2(5, 30);
            filterId + 2;
        } else if (roll6Index == 3) {
            renderRoll6 = IRoll3(roll3).renderRoll3(5, 30);
            filterId + 3;
        } else if (roll6Index == 4) {
            renderRoll6 = IRoll4(roll4).renderRoll4(5, 30);
            filterId + 4;
        } else if (roll6Index == 5) {
            renderRoll6 = IRoll5(roll5).renderRoll5(5, 30);
            filterId + 5;
        } else if (roll6Index == 6) {
            renderRoll6 = IRoll6(roll6).renderRoll6(5, 30);
            filterId + 6;
        }

        return string(abi.encodePacked(
            renderRollBackground,
            renderRoll1,
            renderRoll2,
            renderRoll3,
            renderRoll4,
            renderRoll5,
            renderRoll6
        ));
    }
}