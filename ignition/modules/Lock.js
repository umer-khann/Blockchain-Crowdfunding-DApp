// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("CrowdfundingModule", (m) => {
  // Deploy KYC Registry first
  const kycRegistry = m.contract("KYCRegistry_UmerKhan");
  
  // Deploy Crowdfunding contract with KYC Registry address
  const crowdfunding = m.contract("Crowdfunding_UmerKhan", [kycRegistry]);

  return { kycRegistry, crowdfunding };
});
