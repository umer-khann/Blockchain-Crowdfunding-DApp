@echo off
echo 🔧 Fixing MetaMask Connection Issues
echo ====================================

echo.
echo Step 1: Stopping all processes...
taskkill /f /im node.exe >nul 2>&1
echo ✅ Stopped all Node.js processes

echo.
echo Step 2: Starting Hardhat node...
start "Hardhat Node" cmd /k "npx hardhat node"
timeout /t 3 /nobreak >nul

echo.
echo Step 3: Deploying contracts...
start "Deploy Contracts" cmd /k "npx hardhat run scripts/deploy.js --network localhost"
timeout /t 5 /nobreak >nul

echo.
echo Step 4: Starting frontend...
start "Frontend" cmd /k "cd frontend && npm start"
timeout /t 3 /nobreak >nul

echo.
echo 🎉 All services started!
echo.
echo 📝 Next steps:
echo 1. Open MetaMask
echo 2. Go to Settings ^> Advanced ^> Reset Account
echo 3. Clear browser cache (Ctrl+Shift+Delete)
echo 4. Restart MetaMask
echo 5. Make sure you're on Hardhat Local network
echo 6. Open http://localhost:3000
echo.
echo If still having issues, try importing a fresh account:
echo Account #0: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
echo Private Key: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
echo.
pause

