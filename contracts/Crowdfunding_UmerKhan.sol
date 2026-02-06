// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IKYCRegistry {
    function isVerified(address user) external view returns (bool);
}

contract Crowdfunding_UmerKhan {
    IKYCRegistry public kycRegistry;
    address public admin;
    
    struct Campaign {
        uint256 id;
        string title;
        string description;
        uint256 goal;
        uint256 fundsRaised;
        address creator;
        bool isActive;
        bool isCompleted;
        bool isWithdrawn;
        uint256 createdAt;
    }
    
    struct Contribution {
        address contributor;
        uint256 amount;
        uint256 timestamp;
    }
    
    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => Contribution[]) public campaignContributions;
    mapping(address => uint256[]) public userCampaigns;
    mapping(address => mapping(uint256 => uint256)) public userContributions;
    
    uint256 public campaignCount;
    
    event CampaignCreated(uint256 indexed campaignId, address indexed creator, string title, uint256 goal);
    event ContributionMade(uint256 indexed campaignId, address indexed contributor, uint256 amount);
    event CampaignCompleted(uint256 indexed campaignId, uint256 totalRaised);
    event FundsWithdrawn(uint256 indexed campaignId, address indexed creator, uint256 amount);
    
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }
    
    modifier onlyVerified() {
        require(kycRegistry.isVerified(msg.sender), "Only verified users can perform this action");
        _;
    }
    
    modifier campaignExists(uint256 _campaignId) {
        require(_campaignId > 0 && _campaignId <= campaignCount, "Campaign does not exist");
        _;
    }
    
    modifier onlyCampaignCreator(uint256 _campaignId) {
        require(campaigns[_campaignId].creator == msg.sender, "Only campaign creator can perform this action");
        _;
    }
    
    constructor(address _kycRegistry) {
        kycRegistry = IKYCRegistry(_kycRegistry);
        admin = msg.sender;
    }
    
    function createCampaign(
        string memory _title,
        string memory _description,
        uint256 _goal
    ) external onlyVerified returns (uint256) {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(_goal > 0, "Goal must be greater than 0");
        
        campaignCount++;
        
        campaigns[campaignCount] = Campaign({
            id: campaignCount,
            title: _title,
            description: _description,
            goal: _goal,
            fundsRaised: 0,
            creator: msg.sender,
            isActive: true,
            isCompleted: false,
            isWithdrawn: false,
            createdAt: block.timestamp
        });
        
        userCampaigns[msg.sender].push(campaignCount);
        
        emit CampaignCreated(campaignCount, msg.sender, _title, _goal);
        
        return campaignCount;
    }
    
    function contribute(uint256 _campaignId) external payable campaignExists(_campaignId) {
        Campaign storage campaign = campaigns[_campaignId];
        
        require(campaign.isActive, "Campaign is not active");
        require(!campaign.isCompleted, "Campaign is already completed");
        require(msg.value > 0, "Contribution amount must be greater than 0");
        
        campaign.fundsRaised += msg.value;
        userContributions[msg.sender][_campaignId] += msg.value;
        
        campaignContributions[_campaignId].push(Contribution({
            contributor: msg.sender,
            amount: msg.value,
            timestamp: block.timestamp
        }));
        
        emit ContributionMade(_campaignId, msg.sender, msg.value);
        
        // Check if goal is reached
        if (campaign.fundsRaised >= campaign.goal) {
            campaign.isCompleted = true;
            campaign.isActive = false;
            emit CampaignCompleted(_campaignId, campaign.fundsRaised);
        }
    }
    
    function withdrawFunds(uint256 _campaignId) external 
        campaignExists(_campaignId) 
        onlyCampaignCreator(_campaignId) 
    {
        Campaign storage campaign = campaigns[_campaignId];
        
        require(campaign.isCompleted, "Campaign is not completed yet");
        require(!campaign.isWithdrawn, "Funds have already been withdrawn");
        require(campaign.fundsRaised > 0, "No funds to withdraw");
        
        campaign.isWithdrawn = true;
        uint256 amount = campaign.fundsRaised;
        
        // Reset funds raised to prevent reentrancy
        campaign.fundsRaised = 0;
        
        payable(campaign.creator).transfer(amount);
        
        emit FundsWithdrawn(_campaignId, campaign.creator, amount);
    }
    
    function getCampaign(uint256 _campaignId) external view campaignExists(_campaignId) returns (
        uint256 id,
        string memory title,
        string memory description,
        uint256 goal,
        uint256 fundsRaised,
        address creator,
        bool isActive,
        bool isCompleted,
        bool isWithdrawn,
        uint256 createdAt
    ) {
        Campaign memory campaign = campaigns[_campaignId];
        return (
            campaign.id,
            campaign.title,
            campaign.description,
            campaign.goal,
            campaign.fundsRaised,
            campaign.creator,
            campaign.isActive,
            campaign.isCompleted,
            campaign.isWithdrawn,
            campaign.createdAt
        );
    }
    
    function getCampaignContributions(uint256 _campaignId) external view campaignExists(_campaignId) returns (Contribution[] memory) {
        return campaignContributions[_campaignId];
    }
    
    function getUserCampaigns(address _user) external view returns (uint256[] memory) {
        return userCampaigns[_user];
    }
    
    function getUserContribution(address _user, uint256 _campaignId) external view returns (uint256) {
        return userContributions[_user][_campaignId];
    }
    
    function getAllCampaigns() external view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](campaignCount);
        for (uint256 i = 1; i <= campaignCount; i++) {
            allCampaigns[i - 1] = campaigns[i];
        }
        return allCampaigns;
    }
    
    function getCampaignStatus(uint256 _campaignId) external view campaignExists(_campaignId) returns (string memory) {
        Campaign memory campaign = campaigns[_campaignId];
        if (campaign.isWithdrawn) {
            return "Withdrawn";
        } else if (campaign.isCompleted) {
            return "Completed";
        } else if (campaign.isActive) {
            return "Active";
        } else {
            return "Inactive";
        }
    }
}
