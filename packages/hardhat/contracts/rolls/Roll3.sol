// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.7.0;

import "../library/SVGUtils.sol";

/**
 * @title Roll3
 * 
 * @author @life_of_pandaa
 * @author @pow_vt
 * 
 * @notice This contract is used to render svg code for a dice roll of 3.
 * 
 * @dev The die is rendered as three white dots with a yellow filter.
 */

contract Roll3 {

    function renderDots(uint8 startIndex, uint8 filterStartId) internal pure returns(string memory) {
        return string(abi.encodePacked(
            '<g filter="url(#id',SVGUtils.uint2str(filterStartId),')">',
                '<circle cx="',SVGUtils.uint2str(167 + (startIndex * 333) - 70),'" cy="1070" r="10.0386" fill="#fff"/>',
            '</g>',
            '<g filter="url(#id',SVGUtils.uint2str(filterStartId + 1),')">',
                '<circle cx="',SVGUtils.uint2str(167 + (startIndex * 333)),'" cy="1000" r="10.0386" fill="#fff"/>',
            '</g>',
            '<g filter="url(#id',SVGUtils.uint2str(filterStartId + 2),')">',
                '<circle cx="',SVGUtils.uint2str(167 + (startIndex * 333) + 70),'" cy="930" r="10.0386" fill="#fff"/>',
            '</g>'
        ));
    }

    function renderFilters(uint8 startIndex, uint8 filterStartId) internal pure returns(string memory) {
        return string(abi.encodePacked(
            '<defs>',
                '<filter id="id',SVGUtils.uint2str(filterStartId),'" x="',SVGUtils.uint2str(1 + (startIndex * 333)),'" y="140" width="333.333" height="2000" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">',
                    '<feFlood flood-opacity="0" result="BackgroundImageFix"/>',
                    '<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>',
                    '<feMorphology radius="51" operator="dilate" in="SourceAlpha" result="effect1_dropShadow_502_2"/>',
                    '<feOffset/>',
                    '<feGaussianBlur stdDeviation="70"/>',
                    '<feComposite in2="hardAlpha" operator="out"/>',
                    '<feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 0.780392 0 0 0 0 0.00392157 0 0 0 0.2 0"/>',
                    '<feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_502_2"/>',
                    '<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>',
                    '<feMorphology radius="11" operator="dilate" in="SourceAlpha" result="effect2_dropShadow_502_2"/>',
                    '<feOffset/>',
                    '<feGaussianBlur stdDeviation="25"/>',
                    '<feComposite in2="hardAlpha" operator="out"/>',
                    '<feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 0.780392 0 0 0 0 0.00392157 0 0 0 0.8 0"/>',
                    '<feBlend mode="normal" in2="effect1_dropShadow_502_2" result="effect2_dropShadow_502_2"/>',
                    '<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>',
                    '<feMorphology radius="8" operator="dilate" in="SourceAlpha" result="effect3_dropShadow_502_2"/>',
                    '<feOffset/>',
                    '<feGaussianBlur stdDeviation="10"/>',
                    '<feComposite in2="hardAlpha" operator="out"/>',
                    '<feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 0.780392 0 0 0 0 0.00392157 0 0 0 1 0"/>',
                    '<feBlend mode="normal" in2="effect2_dropShadow_502_2" result="effect3_dropShadow_502_2"/>',
                    '<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>',
                    '<feMorphology radius="2" operator="dilate" in="SourceAlpha" result="effect4_dropShadow_502_2"/>',
                    '<feOffset/>',
                    '<feGaussianBlur stdDeviation="2.5"/>',
                    '<feComposite in2="hardAlpha" operator="out"/>',
                    '<feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 0.780392 0 0 0 0 0.00392157 0 0 0 1 0"/>',
                    '<feBlend mode="normal" in2="effect3_dropShadow_502_2" result="effect4_dropShadow_502_2"/>',
                    '<feBlend mode="normal" in="SourceGraphic" in2="effect4_dropShadow_502_2" result="shape"/>',
                '</filter>',
                '<filter id="id',SVGUtils.uint2str(filterStartId + 1),'" x="',SVGUtils.uint2str(1 + (startIndex * 333)),'" y="0" width="333.333" height="2000" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">',
                    '<feFlood flood-opacity="0" result="BackgroundImageFix"/>',
                    '<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>',
                    '<feMorphology radius="51" operator="dilate" in="SourceAlpha" result="effect1_dropShadow_502_2"/>',
                    '<feOffset/>',
                    '<feGaussianBlur stdDeviation="70"/>',
                    '<feComposite in2="hardAlpha" operator="out"/>',
                    '<feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 0.780392 0 0 0 0 0.00392157 0 0 0 0.2 0"/>',
                    '<feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_502_2"/>',
                    '<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>',
                    '<feMorphology radius="11" operator="dilate" in="SourceAlpha" result="effect2_dropShadow_502_2"/>',
                    '<feOffset/>',
                    '<feGaussianBlur stdDeviation="25"/>',
                    '<feComposite in2="hardAlpha" operator="out"/>',
                    '<feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 0.780392 0 0 0 0 0.00392157 0 0 0 0.8 0"/>',
                    '<feBlend mode="normal" in2="effect1_dropShadow_502_2" result="effect2_dropShadow_502_2"/>',
                    '<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>',
                    '<feMorphology radius="8" operator="dilate" in="SourceAlpha" result="effect3_dropShadow_502_2"/>',
                    '<feOffset/>',
                    '<feGaussianBlur stdDeviation="10"/>',
                    '<feComposite in2="hardAlpha" operator="out"/>',
                    '<feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 0.780392 0 0 0 0 0.00392157 0 0 0 1 0"/>',
                    '<feBlend mode="normal" in2="effect2_dropShadow_502_2" result="effect3_dropShadow_502_2"/>',
                    '<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>',
                    '<feMorphology radius="2" operator="dilate" in="SourceAlpha" result="effect4_dropShadow_502_2"/>',
                    '<feOffset/>',
                    '<feGaussianBlur stdDeviation="2.5"/>',
                    '<feComposite in2="hardAlpha" operator="out"/>',
                    '<feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 0.780392 0 0 0 0 0.00392157 0 0 0 1 0"/>',
                    '<feBlend mode="normal" in2="effect3_dropShadow_502_2" result="effect4_dropShadow_502_2"/>',
                    '<feBlend mode="normal" in="SourceGraphic" in2="effect4_dropShadow_502_2" result="shape"/>',
                '</filter>',
                '<filter id="id',SVGUtils.uint2str(filterStartId + 2),'" x="',SVGUtils.uint2str(1 + (startIndex * 333)),'" y="101.461" width="333.333" height="2000" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">',
                    '<feFlood flood-opacity="0" result="BackgroundImageFix"/>',
                    '<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>',
                    '<feMorphology radius="20" operator="dilate" in="SourceAlpha" result="effect1_dropShadow_502_2"/>',
                    '<feOffset/>',
                    '<feGaussianBlur stdDeviation="70"/>',
                    '<feComposite in2="hardAlpha" operator="out"/>',
                    '<feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 0.780392 0 0 0 0 0.00392157 0 0 0 0.2 0"/>',
                    '<feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_502_2"/>',
                    '<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>',
                    '<feMorphology radius="11" operator="dilate" in="SourceAlpha" result="effect2_dropShadow_502_2"/>',
                    '<feOffset/>',
                    '<feGaussianBlur stdDeviation="25"/>',
                    '<feComposite in2="hardAlpha" operator="out"/>',
                    '<feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 0.780392 0 0 0 0 0.00392157 0 0 0 0.8 0"/>',
                    '<feBlend mode="normal" in2="effect1_dropShadow_502_2" result="effect2_dropShadow_502_2"/>',
                    '<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>',
                    '<feMorphology radius="8" operator="dilate" in="SourceAlpha" result="effect3_dropShadow_502_2"/>',
                    '<feOffset/>',
                    '<feGaussianBlur stdDeviation="10"/>',
                    '<feComposite in2="hardAlpha" operator="out"/>',
                    '<feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 0.780863 0 0 0 0 0.00392157 0 0 0 1 0"/>',
                    '<feBlend mode="normal" in2="effect2_dropShadow_502_2" result="effect3_dropShadow_502_2"/>',
                    '<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>',
                    '<feMorphology radius="2" operator="dilate" in="SourceAlpha" result="effect4_dropShadow_502_2"/>',
                    '<feOffset/>',
                    '<feGaussianBlur stdDeviation="2.5"/>',
                    '<feComposite in2="hardAlpha" operator="out"/>',
                    '<feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 0.780392 0 0 0 0 0.00392157 0 0 0 1 0"/>',
                    '<feBlend mode="normal" in2="effect3_dropShadow_502_2" result="effect4_dropShadow_502_2"/>',
                    '<feBlend mode="normal" in="SourceGraphic" in2="effect4_dropShadow_502_2" result="shape"/>',
                '</filter>',
            '</defs>'
        ));
    }

    function renderRoll3(uint8 startIndex, uint8 filterStartId) public pure returns(string memory) {
        return string(abi.encodePacked(
            renderDots(startIndex, filterStartId),
            renderFilters(startIndex, filterStartId)
      ));
    }
}
