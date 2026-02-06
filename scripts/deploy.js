const hre = require("hardhat");

async function main() {
  console.log("Deploying contracts...");

  // Deploy KYC Registry first
  const KYCRegistry = await hre.ethers.getContractFactory("KYCRegistry_UmerKhan");
  const kycRegistry = await KYCRegistry.deploy();
  await kycRegistry.waitForDeployment();
  
  const kycRegistryAddress = await kycRegistry.getAddress();
  console.log("KYC Registry deployed to:", kycRegistryAddress);

  // Deploy Crowdfunding contract with KYC Registry address
  const Crowdfunding = await hre.ethers.getContractFactory("Crowdfunding_UmerKhan");
  const crowdfunding = await Crowdfunding.deploy(kycRegistryAddress);
  await crowdfunding.waitForDeployment();
  
  const crowdfundingAddress = await crowdfunding.getAddress();
  console.log("Crowdfunding contract deployed to:", crowdfundingAddress);

  // Save contract addresses to a file for frontend use
  const fs = require('fs');
  const path = require('path');
  
  const contractAddresses = {
    kycRegistry: kycRegistryAddress,
    crowdfunding: crowdfundingAddress,
    network: hre.network.name
  };
  
  // Ensure the contracts directory exists
  const contractsDir = path.dirname('./frontend/src/contracts/contractAddresses.json');
  if (!fs.existsSync(contractsDir)) {
    fs.mkdirSync(contractsDir, { recursive: true });
  }
  
  fs.writeFileSync(
    './frontend/src/contracts/contractAddresses.json',
    JSON.stringify(contractAddresses, null, 2)
  );
  
  console.log("Contract addresses saved to frontend/src/contracts/contractAddresses.json");
  console.log("Deployment completed successfully!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
