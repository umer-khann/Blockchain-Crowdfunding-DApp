# Decentralized Crowdfunding Platform

**Developed by UmerKhan, Roll No: 22i-0780**

A complete decentralized crowdfunding platform built with Solidity smart contracts and React frontend, featuring KYC verification and MetaMask integration.

## Features

### 🔐 KYC System
- Users can submit KYC requests with name and CNIC
- Admin can approve or reject KYC requests
- Only verified users can create crowdfunding campaigns

### 💰 Campaign Management
- Create campaigns with title, description, and funding goal
- View all active campaigns with real-time funding progress
- Campaign status tracking (Active/Completed/Withdrawn)

### 💸 Contributions
- Anyone can contribute ETH to active campaigns
- Real-time funding updates
- Automatic campaign completion when goal is reached

### 🏦 Fund Withdrawal
- Campaign creators can withdraw funds when goals are met
- Secure withdrawal process with status updates

### 🔗 MetaMask Integration
- Connect wallet to interact with the platform
- Display wallet address and ETH balance
- All transactions handled through MetaMask

## Smart Contracts

### KYCRegistry_UmerKhan.sol
- Manages user verification system
- Handles KYC request submission, approval, and rejection
- Tracks verified users

### Crowdfunding_UmerKhan.sol
- Manages crowdfunding campaigns
- Handles contributions and fund withdrawals
- Integrates with KYC registry for verification

## Technology Stack

- **Smart Contracts**: Solidity ^0.8.28
- **Development Framework**: Hardhat
- **Frontend**: React.js
- **Blockchain Interaction**: Ethers.js v6
- **Wallet Integration**: MetaMask

## Prerequisites

- Node.js (v16 or higher)
- MetaMask browser extension
- Git

## Installation & Setup

### 1. Clone the Repository
```bash
git clone <repository-url>
cd crowdfunding-dapp-umerkhan
```

### 2. Install Dependencies
```bash
# Install Hardhat dependencies
npm install

# Install frontend dependencies
cd frontend
npm install
cd ..
```

### 3. Compile Smart Contracts
```bash
npx hardhat compile
```

### 4. Start Local Blockchain
```bash
# In a new terminal
npx hardhat node
```

### 5. Deploy Contracts
```bash
# In another terminal
npx hardhat run scripts/deploy.js --network localhost
```

### 6. Start Frontend
```bash
# In another terminal
cd frontend
npm start
```

## Usage Instructions

### 1. Connect MetaMask
- Open the DApp in your browser (usually http://localhost:3000)
- Click "Connect MetaMask Wallet"
- Approve the connection in MetaMask
- Make sure you're connected to the local Hardhat network (Chain ID: 1337)

### 2. KYC Verification
- Go to the "KYC" tab
- Submit your full name and CNIC
- Wait for admin approval

### 3. Admin Functions
- The first account (deployer) is automatically the admin
- Go to "Admin Panel" tab
- Check KYC status of users by entering their address
- Approve or reject KYC requests

### 4. Create Campaigns
- Complete KYC verification first
- Go to "Create Campaign" tab
- Enter campaign details and funding goal
- Submit the campaign

### 5. Contribute to Campaigns
- View campaigns in the "Campaigns" tab
- Enter contribution amount in ETH
- Click "Contribute" and confirm in MetaMask

### 6. Withdraw Funds
- Campaign creators can withdraw funds when goals are met
- Click "Withdraw Funds" button on completed campaigns

## Project Structure

```
crowdfunding-dapp-umerkhan/
├── contracts/
│   ├── KYCRegistry_UmerKhan.sol
│   └── Crowdfunding_UmerKhan.sol
├── scripts/
│   └── deploy.js
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── Header.js
│   │   │   ├── KYCForm.js
│   │   │   ├── AdminPanel.js
│   │   │   ├── CampaignList.js
│   │   │   └── CreateCampaign.js
│   │   ├── contracts/
│   │   │   ├── KYCRegistry_UmerKhan.json
│   │   │   ├── Crowdfunding_UmerKhan.json
│   │   │   └── contractAddresses.json
│   │   ├── App.js
│   │   └── App.css
│   └── package.json
├── hardhat.config.js
└── package.json
```

## Contract Addresses

After deployment, contract addresses will be automatically saved to:
`frontend/src/contracts/contractAddresses.json`

## Testing

### Manual Testing Steps

1. **KYC Flow**:
   - Submit KYC request with name "UmerKhan" and CNIC
   - Admin approves the request
   - Verify user can now create campaigns

2. **Campaign Creation**:
   - Create a campaign with title, description, and goal
   - Verify campaign appears in the list

3. **Contributions**:
   - Contribute ETH to active campaigns
   - Verify funding progress updates

4. **Fund Withdrawal**:
   - Complete a campaign by reaching the goal
   - Withdraw funds as campaign creator

## Screenshots

The DApp includes the following key screens:
1. **KYC Approval**: Admin panel showing KYC request approval
2. **Campaign Creation**: Form for creating new campaigns
3. **Contributions**: Campaign listing with contribution functionality
4. **Fund Withdrawal**: Withdrawal interface for completed campaigns

## Security Features

- Only verified users can create campaigns
- Only campaign creators can withdraw funds
- Admin-only KYC approval system
- Secure smart contract interactions

## Troubleshooting

### Common Issues

1. **MetaMask Connection Issues**:
   - Ensure MetaMask is installed and unlocked
   - Check that you're connected to the correct network (localhost:8545)

2. **Contract Interaction Errors**:
   - Verify contracts are deployed correctly
   - Check contract addresses in `contractAddresses.json`

3. **Transaction Failures**:
   - Ensure sufficient ETH balance
   - Check gas limits in MetaMask

## License

This project is developed for educational purposes as part of the Blockchain course assignment.

## Contact

**Developer**: UmerKhan  
**Roll Number**: 22i-0780  
**Course**: Blockchain (Semester 7)