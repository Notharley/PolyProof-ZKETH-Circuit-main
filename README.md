# PolyProof-ZKETH-Circuit

This repository contains the implementation of a zkSNARK circuit that performs specific logical operations. The circuit is designed to prove knowledge of inputs A = 0 and B = 1 that yield an output of 0. Additionally, this project includes deploying a verifier on-chain to verify proofs generated from this circuit.

## Description

This Circom project involves creating a zkSNARK circuit to demonstrate knowledge of specific logical inputs and their resulting output. The circuit implements logical gates, and the resulting proof is verified on-chain using a verifier contract deployed on the Polygon network (Cardona zkEVM or Sepolia or Mumbai Testnet).

## Prerequisites

- [MetaMask](https://metamask.io/) installed in your browser
- [Hardhat](https://github.com/gmchad/zardkat) for compiling and deploying the contract
- [Circom](https://docs.circom.io/) for writing and compiling the circuit
- VS Code Integrated development Environment 

## Getting Started

### Executing program

1. To build and run this project, we can use VS Code or GitPod.
2. Create a new file by clicking on the "+" icon in the left-hand sidebar.
3. Clone the repository Harhat circom.
4. Design the code according to circuit mentioned below.
![image](https://github.com/user-attachments/assets/b2ecc304-5c9e-4ed6-8b19-7ba18bc20612)

```
pragma circom 2.0.0;

/*This circuit template checks that c is the multiplication of a and b.*/  

template ZKSnarkCircuit () {  
   // Signal inputs
   signal input A;
   signal input B;
   
   // Signals from gates
   signal X;
   signal Y;

   // Final signal output
   signal output Q;

   // Component gates used to create custom circuit
   component And_Gate = AND();
   component Not_Gate = NOT();
   component Or_Gate = OR();
   
   // Circuit logic
   And_Gate.a <== A;
   And_Gate.b <== B;
   X <== And_Gate.out;

   Not_Gate.in <== B;
   Y <== Not_Gate.out;

   Or_Gate.a <== X;
   Or_Gate.b <== Y;
   Q <== Or_Gate.out;
}

template AND() {
    signal input a;
    signal input b;
    signal output out;

    out <== a*b;
}

template NOT() {
    signal input in;
    signal output out;

    out <== 1 + in - 2*in;
}

template OR() {
    signal input a;
    signal input b;
    signal output out;

    out <== a + b - a*b;
}

component main = ZKSnarkCircuit();
```
### Install
`npm i`

### Compile
`npx hardhat circom` 
This will generate the **out** file with circuit intermediaries and geneate the **MultiplierVerifier.sol** contract

### Prove and Deploy
`npx hardhat run scripts/deploy.ts --network zkEVM`
This script does 4 things  
1. Deploys the MultiplierVerifier.sol contract
2. Generates a proof from circuit intermediaries with `generateProof()`
3. Generates calldata with `generateCallData()`
4. Calls `verifyProof()` on the verifier contract with calldata

With two commands you can compile a ZKP, generate a proof, deploy a verifier, and verify the proof 🎉

## Configuration
### Directory Structure
**circuits**
```
├── multiplier
│   ├── circuit.circom
│   ├── input.json
│   └── out
│       ├── circuit.wasm
│       ├── multiplier.r1cs
│       ├── multiplier.vkey
│       └── multiplier.zkey
├── new-circuit
└── powersOfTau28_hez_final_12.ptau
```
Each new circuit lives in it's own directory. At the top level of each circuit directory lives the circom circuit and input to the circuit.
The **out** directory will be autogenerated and store the compiled outputs, keys, and proofs. The Powers of Tau file comes from the Polygon Hermez ceremony, which saves time by not needing a new ceremony. 

**contracts**
```
contracts
└── MultiplierVerifier.sol
```
Verifier contracts are autogenerated and prefixed by the circuit name, in this example **Multiplier**

## hardhat.config.ts
```
  circom: {
    // (optional) Base path for input files, defaults to `./circuits/`
    inputBasePath: "./circuits",
    // (required) The final ptau file, relative to inputBasePath, from a Phase 1 ceremony
    ptau: "powersOfTau28_hez_final_12.ptau",
    // (required) Each object in this array refers to a separate circuit
    circuits: JSON.parse(JSON.stringify(circuits))
  },
```
### circuits.config.json
circuits configuation is separated from hardhat.config.ts for **autogenerated** purposes (see next section)
```
[
  {
    "name": "multiplier",
    "protocol": "groth16",
    "circuit": "multiplier/circuit.circom",
    "input": "multiplier/input.json",
    "wasm": "multiplier/out/circuit.wasm",
    "zkey": "multiplier/out/multiplier.zkey",
    "vkey": "multiplier/out/multiplier.vkey",
    "r1cs": "multiplier/out/multiplier.r1cs",
    "beacon": "0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f"
  }
]
```

**adding circuits**   
To add a new circuit, you can run the `newcircuit` hardhat task to autogenerate configuration and directories i.e  
```
npx hardhat newcircuit --name newcircuit
```

## Connecting MetaMask with Polygon zkEVM Cardona Testnet

1. Open MetaMask and click on the network dropdown at the top.
2. Select "Add Network" and fill in the following details:
    - **Network Name:** Polygon zkEVM Cardona Testnet
    - **New RPC URL:** https://polygon-zkevm-cardona.blockpi.network/v1/rpc/public
    - **ChainID:** 2442
    - **Symbol:** ETH
3. Save and switch to the new network.

## Verifying Contract on PolygonScan

1. Go to PolygonScan(https://cardona-zkevm.polygonscan.com/).
2. Search for your contract address.
3. Complete the verification.

### Authors
Divij Shukla
