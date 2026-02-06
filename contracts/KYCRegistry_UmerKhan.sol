// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract KYCRegistry_UmerKhan {
    address public admin;
    
    struct KYCRequest {
        string name;
        string cnic;
        bool isApproved;
        bool isRejected;
        bool exists;
    }
    
    mapping(address => KYCRequest) public kycRequests;
    mapping(address => bool) public isVerified;
    
    event KYCRequestSubmitted(address indexed user, string name, string cnic);
    event KYCRequestApproved(address indexed user, string name);
    event KYCRequestRejected(address indexed user, string name);
    
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }
    
    modifier onlyVerified() {
        require(isVerified[msg.sender] || msg.sender == admin, "Only verified users can perform this action");
        _;
    }
    
    constructor() {
        admin = msg.sender;
        isVerified[admin] = true; // Admin is automatically verified
    }
    
    function submitKYCRequest(string memory _name, string memory _cnic) external {
        require(!kycRequests[msg.sender].exists, "KYC request already exists");
        require(!isVerified[msg.sender], "User is already verified");
        
        kycRequests[msg.sender] = KYCRequest({
            name: _name,
            cnic: _cnic,
            isApproved: false,
            isRejected: false,
            exists: true
        });
        
        emit KYCRequestSubmitted(msg.sender, _name, _cnic);
    }
    
    function approveKYCRequest(address _user) external onlyAdmin {
        require(kycRequests[_user].exists, "KYC request does not exist");
        require(!kycRequests[_user].isApproved, "KYC request already approved");
        require(!kycRequests[_user].isRejected, "KYC request already rejected");
        
        kycRequests[_user].isApproved = true;
        isVerified[_user] = true;
        
        emit KYCRequestApproved(_user, kycRequests[_user].name);
    }
    
    function rejectKYCRequest(address _user) external onlyAdmin {
        require(kycRequests[_user].exists, "KYC request does not exist");
        require(!kycRequests[_user].isApproved, "KYC request already approved");
        require(!kycRequests[_user].isRejected, "KYC request already rejected");
        
        kycRequests[_user].isRejected = true;
        
        emit KYCRequestRejected(_user, kycRequests[_user].name);
    }
    
    function getUserKYCStatus(address _user) external view returns (bool, bool, bool) {
        return (kycRequests[_user].exists, kycRequests[_user].isApproved, kycRequests[_user].isRejected);
    }
    
    function getUserKYCInfo(address _user) external view returns (string memory, string memory, bool, bool, bool) {
        require(kycRequests[_user].exists, "KYC request does not exist");
        KYCRequest memory request = kycRequests[_user];
        return (request.name, request.cnic, request.isApproved, request.isRejected, request.exists);
    }
}
