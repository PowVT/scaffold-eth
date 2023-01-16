// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.7.0;

interface IRoll5 {

    function renderRoll5(uint8 startIndex, uint8 filterStartId) external view returns (string memory);

}
