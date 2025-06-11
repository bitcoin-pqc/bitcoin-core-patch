# bitcoin-pqc

## Description

An extension for Bitcoin Core that adds post-quantum cryptographic (PQC) support via a soft-fork, introducing the `OP_CHECKPQCVERIFY` opcode and a new Pay-to-Quantum-Resistant-Hash address type.

## Features

* Soft-fork patch for Bitcoin Core (C++)
* New opcode: `OP_CHECKPQCVERIFY`
* PQC-compatible script and address format
* Docker Compose regtest network for testing
* Integration with PQClean reference implementations

## Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/bitcoin-pqc/bitcoin-pqc.git
   ```
2. Apply the patch to Bitcoin Core:

   ```bash
   cd bitcoin
   git apply ../bitcoin-pqc/patch.diff
   ```
3. Build Bitcoin Core with PQC support:

   ```bash
   ./autogen.sh && ./configure && make
   ```
4. Run the regtest network:

   ```bash
   docker-compose up -d
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

