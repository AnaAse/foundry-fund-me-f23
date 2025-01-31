# FundMe - A Crowdsourcing Smart Contract

**FundMe** is a Solidity-based smart contract designed for decentralized crowdsourcing. It allows users to contribute ETH to the contract while ensuring contributions meet a minimum USD threshold using Chainlink's price feed. The contract is secure, owner-controlled, and fully tested using Foundry.

---

## Table of Contents
1. [Getting Started](#getting-started)
   - [Requirements](#requirements)
   - [Quickstart](#quickstart)
2. [Deployment](#deployment)
3. [Features](#features)
4. [Contributing](#contributing)
5. [License](#license)

---

## Getting Started

### Requirements
Before you begin, ensure you have the following installed:
- **Foundry**: For smart contract development and testing.
- **Git**: For version control and cloning the repository.
- **Node.js & npm** (optional): For additional tooling and scripts.
- **Ethereum Wallet**: A valid Ethereum wallet and private key for deployment and testing.

---

### Quickstart

1. **Clone the repository**:
   ```bash
   git clone https://github.com/AnaAse/foundry-fund-me-f23
   cd foundry-fund-me-f23
   forge build

    Install dependencies:
    bash
    Copy

    forge install

    Set up environment variables:
    Create a .env file in the root directory and add the following:
    plaintext
    Copy

    ETHERSCAN_API_KEY=your_etherscan_api_key
    PRIVATE_KEY=your_wallet_private_key
    CHAINLINK_PRICE_FEED=your_chainlink_price_feed_address

    Run tests:
    Verify the contract's functionality by running:
    bash
    Copy

    forge test

Deployment

To deploy the FundMe contract, use Foundry's scripting capabilities:
bash
Copy

forge script script/DeployFundMe.s.sol --rpc-url <your_rpc_url> --private-key $PRIVATE_KEY --broadcast

Replace <your_rpc_url> with your preferred Ethereum node RPC URL (e.g., Alchemy, Infura).
Features

    ETH Contributions: Accepts ETH contributions from users.

    Minimum Funding Requirements: Ensures contributions meet a minimum USD threshold using Chainlink price feeds.

    Owner-Controlled Withdrawals: Only the contract owner can withdraw funds.

    Fully Tested: Comprehensive test suite written with Foundry for reliability and security.

Contributing

We welcome contributions! If you'd like to contribute to the project, please follow these steps:

    Fork the repository.

    Create a new branch for your feature or bugfix.

    Submit a pull request with a detailed description of your changes.

For major changes, please open an issue first to discuss the proposed updates.
License

This project is licensed under the MIT License. See the LICENSE file for details.