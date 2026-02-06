@echo off
echo 🚀 Starting Crowdfunding DApp by UmerKhan (22i-0780)
echo ==================================================

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed. Please install Node.js first.
    pause
    exit /b 1
)

REM Check if npm is installed
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm is not installed. Please install npm first.
    pause
    exit /b 1
)

echo ✅ Node.js and npm are installed

REM Install dependencies
echo 📦 Installing dependencies...
npm install

REM Install frontend dependencies
echo 📦 Installing frontend dependencies...
cd frontend
npm install
cd ..

REM Compile contracts
echo 🔨 Compiling smart contracts...
npx hardhat compile

echo.
echo 🎉 Setup completed successfully!
echo.
echo To start the DApp:
echo 1. Open a new terminal and run: npx hardhat node
echo 2. Open another terminal and run: npx hardhat run scripts/deploy.js --network localhost
echo 3. Open another terminal and run: cd frontend ^&^& npm start
echo.
echo Then open http://localhost:3000 in your browser and connect MetaMask!
echo.
echo 📝 Don't forget to:
echo    - Add the local network (http://127.0.0.1:8545) to MetaMask
echo    - Import one of the test accounts from Hardhat
echo    - The first account will be the admin for KYC approvals
pause
