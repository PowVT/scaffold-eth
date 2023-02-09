/* eslint no-use-before-define: "warn" */
const fs = require("fs");
const chalk = require("chalk");
const { config, ethers, tenderly, run, network } = require("hardhat");
const { utils } = require("ethers");
const R = require("ramda");


const main = async () => {

  console.log("\n\n 📡 Deploying...\n");

  // read in all the assets to get their IPFS hash...
  /*let uploadedAssets = JSON.parse(fs.readFileSync("./uploaded.json"))
  let bytes32Array = []
  for(let a in uploadedAssets){
    console.log(" 🏷 IPFS:",a)
    let bytes32 = utils.id(a)
    console.log(" #️⃣ hashed:",bytes32)
    bytes32Array.push(bytes32)
  }
  console.log(" \n")*/

  // deploy the contract with all the artworks forSale
  const roll1 = await deploy("Roll1");
  const roll2 = await deploy("Roll2");
  const roll3 = await deploy("Roll3");
  const roll4 = await deploy("Roll4");
  const roll5 = await deploy("Roll5");
  const roll6 = await deploy("Roll6");

  const paradice = await deploy("Paradice",[roll1.address, roll2.address, roll3.address, roll4.address, roll5.address, roll6.address]);

  // // mint 
  // await paradice.mintItem()

  // let uri = await paradice.tokenURI(1)
  // console.log(uri)

  // const paradiceSingle = await deploy("ParadiceSingle",);

  //const yourContract = await ethers.getContractAt('YourContract', "0xaAC799eC2d00C013f1F11c37E654e59B0429DF6A")
  //const secondContract = await deploy("SecondContract")

  // const exampleToken = await deploy("ExampleToken")
  // const examplePriceOracle = await deploy("ExamplePriceOracle")
  // const smartContractWallet = await deploy("SmartContractWallet",[exampleToken.address,examplePriceOracle.address])

  /*
  //If you want to send value to an address from the deployer
  const deployerWallet = ethers.provider.getSigner()
  await deployerWallet.sendTransaction({
    to: "0x34aA3F359A9D614239015126635CE7732c18fDF3",
    value: ethers.utils.parseEther("0.001")
  })
  */


  /*
  //If you want to send some ETH to a contract on deploy (make your constructor payable!)
  const yourContract = await deploy("YourContract", [], {
  value: ethers.utils.parseEther("0.05")
  });
  */


  /*
  //If you want to link a library into your contract:
  // reference: https://github.com/austintgriffith/scaffold-eth/blob/using-libraries-example/packages/hardhat/scripts/deploy.js#L19
  const yourContract = await deploy("YourContract", [], {}, {
   LibraryName: **LibraryAddress**
  });
  */


  //If you want to verify your contract on tenderly.co (see setup details in the scaffold-eth README!)
  /*
  await tenderlyVerify(
    {contractName: "YourContract",
     contractAddress: yourContract.address
  })
  */

  // If you want to verify your contract on etherscan
  // const roll1 = await ethers.getContractAt('Roll1', "0xdCf5821BC13e8C847a93630483a16bD7b0109821");
  // const roll2 = await ethers.getContractAt('Roll2', "0x3Adc6412bE4B6692CBBEc6b08448b4c3E7De7E11");
  // const roll3 = await ethers.getContractAt('Roll3', "0x6D03be5CB5f74F2F9596f78a526AF869Df3B39be");
  // const roll4 = await ethers.getContractAt('Roll4', "0x5cEc24C6BBcF610fE607DB776452eA892B3Fe249");
  // const roll5 = await ethers.getContractAt('Roll5', "0x8A1a996cd63DD98c16030076f0B27F2926A35cB9");
  // const roll6 = await ethers.getContractAt('Roll6', "0x99F4eeEd02d54eC98Aa3f339C51ba3829FaA0475");
  // const paradice = await ethers.getContractAt('Paradice', "0x05456A7450CBf97C05c8e8D64E78F39cc4477b42");
  // if(network.name !== "localhost") {
  //   console.log(chalk.blue('verifying on etherscan'))
  //   await run("verify:verify", {
  //     address: paradice.address,
  //     constructorArguments: [roll1.address, roll2.address, roll3.address, roll4.address, roll5.address, roll6.address] // If your contract has constructor arguments, you can pass them as an array
  //   })
  //   await run("verify:verify", {
  //     address: roll1.address,
  //   })
  //   await run("verify:verify", {
  //     address: roll2.address,
  //   })
  //   await run("verify:verify", {
  //     address: roll3.address,
  //   })
  //   await run("verify:verify", {
  //     address: roll4.address,
  //   })
  //   await run("verify:verify", {
  //     address: roll5.address,
  //   })
  //   await run("verify:verify", {
  //     address: roll6.address,
  //   })
  // }
  

  console.log(
    " 💾  Artifacts (address, abi, and args) saved to: ",
    chalk.blue("packages/hardhat/artifacts/"),
    "\n\n"
  );
};

const deploy = async (contractName, _args = [], overrides = {}, libraries = {}) => {
  console.log(` 🛰  Deploying: ${contractName}`);

  const contractArgs = _args || [];
  const contractArtifacts = await ethers.getContractFactory(contractName,{libraries: libraries});
  const deployed = await contractArtifacts.deploy(...contractArgs, overrides);
  const encoded = abiEncodeArgs(deployed, contractArgs);
  fs.writeFileSync(`artifacts/${contractName}.address`, deployed.address);

  let extraGasInfo = ""
  if(deployed&&deployed.deployTransaction){
    const gasUsed = deployed.deployTransaction.gasLimit.mul(deployed.deployTransaction.gasPrice)
    extraGasInfo = `${utils.formatEther(gasUsed)} ETH, tx hash ${deployed.deployTransaction.hash}`
  }

  console.log(
    " 📄",
    chalk.cyan(contractName),
    "deployed to:",
    chalk.magenta(deployed.address)
  );
  console.log(
    " ⛽",
    chalk.grey(extraGasInfo)
  );

  await tenderly.persistArtifacts({
    name: contractName,
    address: deployed.address
  });

  if (!encoded || encoded.length <= 2) return deployed;
  fs.writeFileSync(`artifacts/${contractName}.args`, encoded.slice(2));

  return deployed;
};


// ------ utils -------

// abi encodes contract arguments
// useful when you want to manually verify the contracts
// for example, on Etherscan
const abiEncodeArgs = (deployed, contractArgs) => {
  // not writing abi encoded args if this does not pass
  if (
    !contractArgs ||
    !deployed ||
    !R.hasPath(["interface", "deploy"], deployed)
  ) {
    return "";
  }
  const encoded = utils.defaultAbiCoder.encode(
    deployed.interface.deploy.inputs,
    contractArgs
  );
  return encoded;
};

// checks if it is a Solidity file
const isSolidity = (fileName) =>
  fileName.indexOf(".sol") >= 0 && fileName.indexOf(".swp") < 0 && fileName.indexOf(".swap") < 0;

const readArgsFile = (contractName) => {
  let args = [];
  try {
    const argsFile = `./contracts/${contractName}.args`;
    if (!fs.existsSync(argsFile)) return args;
    args = JSON.parse(fs.readFileSync(argsFile));
  } catch (e) {
    console.log(e);
  }
  return args;
};

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// If you want to verify on https://tenderly.co/
const tenderlyVerify = async ({contractName, contractAddress}) => {

  let tenderlyNetworks = ["kovan","goerli","mainnet","rinkeby","ropsten","matic","mumbai","xDai","POA"]
  let targetNetwork = process.env.HARDHAT_NETWORK || config.defaultNetwork

  if(tenderlyNetworks.includes(targetNetwork)) {
    console.log(chalk.blue(` 📁 Attempting tenderly verification of ${contractName} on ${targetNetwork}`))

    await tenderly.persistArtifacts({
      name: contractName,
      address: contractAddress
    });

    let verification = await tenderly.verify({
        name: contractName,
        address: contractAddress,
        network: targetNetwork
      })

    return verification
  } else {
      console.log(chalk.grey(` 🧐 Contract verification not supported on ${targetNetwork}`))
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
