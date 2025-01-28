# Include environment variables from the .env file
-include .env

# Build the project using Forge
build:;	forge build
# before forge, below, use tab no spaces
deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

 
