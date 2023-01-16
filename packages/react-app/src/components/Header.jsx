import { PageHeader } from "antd";
import React from "react";

// displays a page header

export default function Header() {
  return (
    <a href="/">
      <PageHeader
        title="🎲 Paradice"
        subTitle="Randomly generated, On-Chain (.svg) NFT"
        style={{ cursor: "pointer" }}
      />
    </a>
  );
}
