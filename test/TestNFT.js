const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TestNFT", function () {
  it("Should do some stuff", async function () {
    const TestNFT = await ethers.getContractFactory("TestNFT");
    const testNFT = await TestNFT.deploy(
      "Test NFT",
      "TNFT",
      "TEST URI",
      "TEST HIDDEN URI"
    );
    await testNFT.deployed();

    await testNFT.pauseWhiteListMint(false);
    expect(await testNFT.whiteListMintPaused()).to.equal(false);

    // await testNFT.pauseWhiteListMint(true);
    // const whiteListPausedState = await testNFT.whiteListMintPaused();
    // console.log("whiteListPausedState: ", whiteListPausedState);
  });
});
