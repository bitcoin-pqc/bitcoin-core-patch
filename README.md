# bitcoin-core-patch

## Description

An extension for Bitcoin Core that adds post-quantum cryptographic (PQC) support via a soft-fork, introducing the `OP_CHECKPQCVERIFY` opcode and a new Pay-to-Quantum-Resistant-Hash address type.

## Features

* Soft-fork patch for Bitcoin Core (C++)
* New opcode: `OP_CHECKPQCVERIFY`
* PQC-compatible script and address format
* Docker Compose regtest network for testing
* Integration with PQClean reference implementations

## Getting Started

### Prerequisites

* Git
* Docker and Docker Compose
* CMake (3.16+)
* C++ compiler with C++17 support
* Python 3.6+

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/bitcoin-pqc/bitcoin-core-patch.git
   cd bitcoin-core-patch
   ```

2. Build and Test:
   ```bash
   # The CI workflow will automatically:
   # - Clone Bitcoin Core
   # - Apply the patch
   # - Build with CMake
   # - Run tests
   # You can run this locally with:
   docker-compose -f .github/workflows/ci.yml up
   ```

3. Run the Regtest Network:
   ```bash
   # Start the 4-node network (2 patched, 2 legacy)
   docker-compose up -d
   
   # Initialize and connect nodes
   ./start.sh
   
   # Check node status
   docker-compose ps
   ```

4. Explore the BIP Draft:
   The BIP draft is available at `doc/bip-0001-pay-to-quantum-resistant-hash.mediawiki`.
   It describes the technical specification, motivation, and implementation details.

### Development Workflow

1. Make changes to the patch in `patch/0001-add-op_checkpqcverify.patch`
2. Test locally:
   ```bash
   # Rebuild the patched nodes
   docker-compose build bitcoin-patched-1 bitcoin-patched-2
   
   # Restart the network
   docker-compose down
   docker-compose up -d
   ./start.sh
   ```
3. Run the test suite:
   ```bash
   docker-compose exec bitcoin-patched-1 bitcoin-cli -regtest testmempoolaccept '["<RAW_TX_HEX>"]'
   ```

## Usage

* Create a PQC address:
  ```bash
  bitcoin-cli -regtest createpqcaddress
  ```
* Send funds to a PQC address:
  ```bash
  bitcoin-cli -regtest sendtoaddress <PQC_ADDRESS> <AMOUNT>
  ```
* Verify PQC-signed transaction:
  ```bash
  bitcoin-cli -regtest testmempoolaccept '["<RAW_TX_HEX>"]'
  ```

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the MIT License.

## Topics

`post-quantum`, `bitcoin`, `c++`, `pqc`, `kyber`, `dilithium`, `falcon`, `cryptography`

