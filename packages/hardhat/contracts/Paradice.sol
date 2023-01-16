//SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
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

/**
 * @title Paradice
 * 
 * @author @life_of_pandaa
 * @author @pow_vt
 * @author @buidlguidl
 * 
 * @notice This contract is the primary contract for the Paradice project. To render each roll, there are 6 different
 *         roll contracts.
 * 
 * @dev Extends ERC721 Non-Fungible Token Standard basic implementation using OpenZeppelin's v3 token library.
 *      The v4 library is not used because then the ERC721Enumerable library would be required to be used as well
 *      and this adds significant overhead to the contracts storage and the contract will be too large to deploy.
 *      Leaving more room for SVG code in the contract is a priority.
 * @dev Uses OpenZeppelin's Counters library to keep track of the tokenIds.
 * @dev Uses a mintDeadline and mintPrice. Both of which can be modified by the owner of the contract upon deployment.
 * @dev Uses a predictable (pseudo) random number generator to generate the roll outcomes. The random number is generated
 *      using the blockhash of the previous block, the sender of the transaction, the address of this contract, the tokenId
 *      of the token being minted, and the timestamp of the block. This is not a true random number generator, but it is
 *      sufficient for the purpose of rolling dice. It is important to note, an extra layer of 'randomness' in the generator 
 *      comes from the selecting of 6 different locations in the computed bytes32 hash.
 */

contract Paradice is ERC721, Ownable {
    using Strings for uint256;
    using HexStrings for uint160;
    using ToColor for bytes3;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    mapping (uint256 => mapping (uint256 => uint256)) public roll; // tokenId => (roll index => roll result)

    // mint deadline
    uint256 mintDeadline = block.timestamp + 24 hours; // MODIFY!

    // mint price
    uint256 mintPrice = 0;

    // render roll contracts
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

    function mint() public payable returns (uint256) {
        require(msg.value >= mintPrice, "NOT ENOUGH FUNDS SENT TO MINT");
        require(block.timestamp < mintDeadline, "DONE MINTING");

        _tokenIds.increment();
        uint256 id = _tokenIds.current();

        // PRNG
        bytes32 predictableRandom = keccak256(
            abi.encodePacked(blockhash(block.number-1),
                msg.sender,
                address(this),
                id,
                block.timestamp
            )
        );
        for(uint256 i = 0; i < 6; i++) {
            uint256 iRoll = 1+((6*uint256(uint8(predictableRandom[3*(i*2)])))/255);
            if(iRoll > 6) {
                iRoll = 1+((6*uint256(uint8(predictableRandom[3*((i-1)*2)])))/255);
            }
            roll[id][i] = iRoll;
        }

        _mint(msg.sender, id);

        return id;
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        require(_exists(id), "tokenId does not exist");
        
        string memory name = string(abi.encodePacked(
            'Roll ',
            SVGUtils.uint2str(roll[id][0]),
            SVGUtils.uint2str(roll[id][1]),
            SVGUtils.uint2str(roll[id][2]),
            SVGUtils.uint2str(roll[id][3]),
            SVGUtils.uint2str(roll[id][4]),
            SVGUtils.uint2str(roll[id][5])
        ));
        string memory description = string(abi.encodePacked('Roll #',SVGUtils.uint2str(id)));
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
                            '", "external_url":"',
                            'data:image/svg+xml;base64,',
                            image,
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

    function getRenderer(uint8 rollResult, uint8 index) internal view returns (string memory) {   
        if (rollResult == 1) {
            return IRoll1(roll1).renderRoll1(index, index * 6);
        } else if (rollResult == 2) {
            return IRoll2(roll2).renderRoll2(index, index * 6);
        } else if (rollResult == 3) {
            return IRoll3(roll3).renderRoll3(index, index * 6);
        } else if (rollResult == 4) {
            return IRoll4(roll4).renderRoll4(index, index * 6);
        } else if (rollResult == 5) {
            return IRoll5(roll5).renderRoll5(index, index * 6);
        } else if (rollResult == 6) {
            return IRoll6(roll6).renderRoll6(index, index * 6);
        }
    }

    function renderTokenById(uint256 id) internal view returns (string memory) {
        string memory renderRollBackground = string(abi.encodePacked(
            '<g >',
                '<rect width="2000" height="2000" fill="#000000"/>',
            '</g>'
        ));

        uint256[6] memory rollIndices = [
            roll[id][0],
            roll[id][1],
            roll[id][2],
            roll[id][3],
            roll[id][4],
            roll[id][5]
        ];

        string[6] memory renderRolls;

        for (uint8 i = 0; i < 6; i++) {
            renderRolls[i] = getRenderer(uint8(rollIndices[i]), i);
        }

        return string(abi.encodePacked(
            renderRollBackground,
            renderRolls[0],
            renderRolls[1],
            renderRolls[2],
            renderRolls[3],
            renderRolls[4],
            renderRolls[5]
        ));

    }

	function withdraw() public onlyOwner {
		uint256 balance = address(this).balance;
		(bool success,) = msg.sender.call{value: balance}('');
		require(success, 'Withdraw failed');
	}
}