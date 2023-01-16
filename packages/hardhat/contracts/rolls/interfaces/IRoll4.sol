// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.7.0;

interface IRoll4 {

    function renderRoll4(uint8 startIndex, uint8 filterStartId) external view returns (string memory);

}
