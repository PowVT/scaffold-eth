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

    // function renderDot(uint8 startIndex, uint8 filterStartId) internal pure returns (string memory) {
    //     return string(abi.encodePacked(
    //         '<g>',
    //             '<path d="M91.06 45.65c0 25.21-20.44 45.65-45.65 45.65-60.55-2.4-60.54-88.9 0-91.3 25.21 0 45.65 20.44 45.65 45.65Z" style="fill:url(#a)" data-name="Layer 1"/>',
    //         '</g>'
    //     ));
    // }

    // function renderFilter(uint8 startIndex, uint8 filterStartId) internal pure returns (string memory) {
    //     return string(abi.encodePacked(
    //         '<defs>',
    //            'radialGradient id="a" cx="45.53" cy="45.65" fx="45.53" fy="45.65" r="45.59" gradientUnits="userSpaceOnUse">',
    //            '<stop offset="0" stop-color="#fff"/>',
    //            '<stop offset=".07" stop-color="#fefdfd"/>',
    //            '<stop offset=".09" stop-color="#fdf6f6"/>',
    //            '<stop offset=".11" stop-color="#fceaea"/>',
    //            '<stop offset=".12" stop-color="#fad9d9"/>',
    //            '<stop offset=".13" stop-color="#f7c3c3"/>',
    //            '<stop offset=".14" stop-color="#f4a9a9"/>',
    //            '<stop offset=".14" stop-color="#f4a6a6"/>',
    //            '<stop offset=".17" stop-color="#f67a7a" stop-opacity=".86"/>',
    //            '<stop offset=".2" stop-color="#f94f4f" stop-opacity=".71"/>',
    //            '<stop offset=".22" stop-color="#fc2c2c" stop-opacity=".6"/>',
    //            '<stop offset=".25" stop-color="#fd1414" stop-opacity=".52"/>',
    //            '<stop offset=".27" stop-color="#fe0505" stop-opacity=".47"/>',
    //            '<stop offset=".29" stop-color="red" stop-opacity=".45"/>',
    //            '<stop offset=".33" stop-color="red" stop-opacity=".42"/>',
    //            '<stop offset=".79" stop-color="red" stop-opacity=".12"/>',
    //            '<stop offset="1" stop-color="red" stop-opacity="0"/>',
    //            '</radialGradient>',
    //         '</defs>'
    //     ));
    // }

    function renderRoll1(uint8 startIndex, uint8 filterStartId) public pure returns (string memory) {
        return string(abi.encodePacked(
            renderDot(startIndex, filterStartId),
            renderFilter(startIndex, filterStartId)
        ));
    }
}
