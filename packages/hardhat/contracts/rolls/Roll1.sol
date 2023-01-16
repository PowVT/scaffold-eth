// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.7.0;

import "../library/SVGUtils.sol";

/**
 * @title Roll1
 * 
 * @author @life_of_pandaa
 * @author @pow_vt
 * 
 * @notice This contract is used to render svg code for a dice roll of 1.
 * 
 * @dev The die is rendered as a single white dot with a red filter.
 */

contract Roll1 {

    function renderDot(uint8 startIndex, uint8 filterStartId) internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g filter="url(#id',SVGUtils.uint2str(filterStartId),')">',
                '<circle cx="',SVGUtils.uint2str(167 + (startIndex * 333)),'" cy="1000" r="10.039" fill="#fff"/>',
            '</g>'
        ));
    }

    function renderFilter(uint8 startIndex, uint8 filterStartId) internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<defs>',
                '<filter id="id',SVGUtils.uint2str(filterStartId),'" x="',SVGUtils.uint2str(1 + (startIndex * 333)),'" y=".461" width="333.333" height="2000" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">',
                    '<feFlood flood-opacity="0" result="BackgroundImageFix"/>',
                    '<feColorMatrix in="SourceAlpha" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>',
                    '<feMorphology radius="51" operator="dilate" in="SourceAlpha" result="effect1_dropShadow_399_16"/>',
                    '<feOffset/>',
                    '<feGaussianBlur stdDeviation="70"/>',
                    '<feComposite in2="hardAlpha" operator="out"/>',
                    '<feColorMatrix values="0 0 0 0 0.898039 0 0 0 0 0.00392157 0 0 0 0 0 0 0 0 0.6 0"/>',
                    '<feBlend in2="BackgroundImageFix" result="effect1_dropShadow_399_16"/>',
                    '<feColorMatrix in="SourceAlpha" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>',
                    '<feMorphology radius="11" operator="dilate" in="SourceAlpha" result="effect2_dropShadow_399_16"/>',
                    '<feOffset/><feGaussianBlur stdDeviation="25"/>',
                    '<feComposite in2="hardAlpha" operator="out"/>',
                    '<feColorMatrix values="0 0 0 0 0.898039 0 0 0 0 0.00392157 0 0 0 0 0 0 0 0 0.8 0"/>',
                    '<feBlend in2="effect1_dropShadow_399_16" result="effect2_dropShadow_399_16"/>',
                    '<feColorMatrix in="SourceAlpha" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>',
                    '<feMorphology radius="8" operator="dilate" in="SourceAlpha" result="effect3_dropShadow_399_16"/>',
                    '<feOffset/>',
                    '<feGaussianBlur stdDeviation="10"/>',
                    '<feComposite in2="hardAlpha" operator="out"/>',
                    '<feColorMatrix values="0 0 0 0 0.898039 0 0 0 0 0.00392157 0 0 0 0 0 0 0 0 1 0"/>',
                    '<feBlend in2="effect2_dropShadow_399_16" result="effect3_dropShadow_399_16"/>',
                    '<feColorMatrix in="SourceAlpha" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>',
                    '<feMorphology radius="2" operator="dilate" in="SourceAlpha" result="effect4_dropShadow_399_16"/>',
                    '<feOffset/><feGaussianBlur stdDeviation="2.5"/>',
                    '<feComposite in2="hardAlpha" operator="out"/>',
                    '<feColorMatrix values="0 0 0 0 0.898039 0 0 0 0', '0.00392157 0 0 0 0 0 0 0 0 1 0"/>',
                    '<feBlend in2="effect3_dropShadow_399_16" result="effect4_dropShadow_399_16"/>',
                    '<feBlend in="SourceGraphic" in2="effect4_dropShadow_399_16" result="shape"/>',
                '</filter>',
            '</defs>'
        ));
    }

    function renderRoll1(uint8 startIndex, uint8 filterStartId) public pure returns (string memory) {
        return string(abi.encodePacked(
            renderDot(startIndex, filterStartId),
            renderFilter(startIndex, filterStartId)
        ));
    }
}
