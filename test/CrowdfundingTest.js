const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Crowdfunding DApp", function () {
  let kycRegistry;
  let crowdfunding;
  let owner;
  let user1;
  let user2;
  let admin;

  beforeEach(async function () {
    [owner, user1, user2, admin] = await ethers.getSigners();

    // Deploy KYC Registry
    const KYCRegistry = await ethers.getContractFactory("KYCRegistry_UmerKhan");
    kycRegistry = await KYCRegistry.deploy();
    await kycRegistry.waitForDeployment();

    // Deploy Crowdfunding contract
    const Crowdfunding = await ethers.getContractFactory("Crowdfunding_UmerKhan");
    crowdfunding = await Crowdfunding.deploy(await kycRegistry.getAddress());
    await crowdfunding.waitForDeployment();
  });

  describe("KYC Registry", function () {
    it("Should allow users to submit KYC requests", async function () {
      await kycRegistry.connect(user1).submitKYCRequest("UmerKhan", "12345-1234567-1");
      
      const [exists, isApproved, isRejected] = await kycRegistry.getUserKYCStatus(user1.address);
      expect(exists).to.be.true;
      expect(isApproved).to.be.false;
      expect(isRejected).to.be.false;
    });

    it("Should allow admin to approve KYC requests", async function () {
      await kycRegistry.connect(user1).submitKYCRequest("UmerKhan", "12345-1234567-1");
      await kycRegistry.connect(owner).approveKYCRequest(user1.address);
      
      const isVerified = await kycRegistry.isVerified(user1.address);
      expect(isVerified).to.be.true;
    });

    it("Should prevent non-admin from approving KYC", async function () {
      await kycRegistry.connect(user1).submitKYCRequest("UmerKhan", "12345-1234567-1");
      
      await expect(
        kycRegistry.connect(user2).approveKYCRequest(user1.address)
      ).to.be.revertedWith("Only admin can perform this action");
    });
  });

  describe("Crowdfunding", function () {
    beforeEach(async function () {
      // Approve user1 for testing
      await kycRegistry.connect(user1).submitKYCRequest("UmerKhan", "12345-1234567-1");
      await kycRegistry.connect(owner).approveKYCRequest(user1.address);
    });

    it("Should allow verified users to create campaigns", async function () {
      const tx = await crowdfunding.connect(user1).createCampaign(
        "Test Campaign",
        "A test campaign for funding",
        ethers.parseEther("10")
      );
      
      await expect(tx).to.emit(crowdfunding, "CampaignCreated");
      
      const campaign = await crowdfunding.getCampaign(1);
      expect(campaign[1]).to.equal("Test Campaign");
      expect(campaign[2]).to.equal("A test campaign for funding");
      expect(campaign[3]).to.equal(ethers.parseEther("10"));
    });

    it("Should prevent unverified users from creating campaigns", async function () {
      await expect(
        crowdfunding.connect(user2).createCampaign(
          "Test Campaign",
          "A test campaign for funding",
          ethers.parseEther("10")
        )
      ).to.be.revertedWith("Only verified users can perform this action");
    });

    it("Should allow contributions to active campaigns", async function () {
      await crowdfunding.connect(user1).createCampaign(
        "Test Campaign",
        "A test campaign for funding",
        ethers.parseEther("10")
      );

      const tx = await crowdfunding.connect(user2).contribute(1, {
        value: ethers.parseEther("1")
      });
      
      await expect(tx).to.emit(crowdfunding, "ContributionMade");
      
      const campaign = await crowdfunding.getCampaign(1);
      expect(campaign[4]).to.equal(ethers.parseEther("1"));
    });

    it("Should complete campaign when goal is reached", async function () {
      await crowdfunding.connect(user1).createCampaign(
        "Test Campaign",
        "A test campaign for funding",
        ethers.parseEther("5")
      );

      await crowdfunding.connect(user2).contribute(1, {
        value: ethers.parseEther("5")
      });
      
      const campaign = await crowdfunding.getCampaign(1);
      expect(campaign[7]).to.be.true; // isCompleted
      expect(campaign[6]).to.be.false; // isActive
    });

    it("Should allow campaign creator to withdraw funds", async function () {
      await crowdfunding.connect(user1).createCampaign(
        "Test Campaign",
        "A test campaign for funding",
        ethers.parseEther("5")
      );

      await crowdfunding.connect(user2).contribute(1, {
        value: ethers.parseEther("5")
      });

      const tx = await crowdfunding.connect(user1).withdrawFunds(1);
      await expect(tx).to.emit(crowdfunding, "FundsWithdrawn");
      
      const campaign = await crowdfunding.getCampaign(1);
      expect(campaign[8]).to.be.true; // isWithdrawn
    });
  });
});
