const keccak256 = require("keccak256");
const { MerkleTree } = require("merkletreejs");

// let whiteListAddresses = [
//   "0xEcA98626b3ACc920848c538c1dA021E59d6F0394",
//   "0x121684501d2Fb3Ffd92E7a021D63F51b85504C08",
//   "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266",
//   "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
//   "0x571Ea4885290BbEf357655E7D82ABea32C65a617",
// ];

// Frank rinkeby: 0x121684501d2Fb3Ffd92E7a021D63F51b85504C08

let whiteListAddresses = [
  "0x3352000B697976838C062B33558573A8D6527AD6",
  "0x37BA7DC18AA5D10CF89F2B8F82D9D5677EFE3ED2",
  "0x215683AF559C9FD210248D9FB3272B8D32E79E70",
  "0xEcA98626b3ACc920848c538c1dA021E59d6F0394",
  "0x571Ea4885290BbEf357655E7D82ABea32C65a617",
  "0x121684501d2Fb3Ffd92E7a021D63F51b85504C08",
];

// NOTES:
// Add the wallet you want to test is in the tree
// Add new root with wallet address to the contract
// Must Update The mintAddress wallett and rebuilding the proof whenever switching wallets
// Use the updated proof when calling the whitelist mint function
// Give remix a few minutes to deploy the contract to rinkeby

const leafNodes = whiteListAddresses.map((addr) => keccak256(addr));
const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });
const rootHash = merkleTree.getHexRoot();
console.log({ rootHash });

const minterAddress = keccak256("0x121684501d2Fb3Ffd92E7a021D63F51b85504C08");
console.log("minterAddress: ", minterAddress);

const hexProof = merkleTree.getHexProof(minterAddress);
console.log("hexProof: ", hexProof);

console.log("verify: ", merkleTree.verify(hexProof, minterAddress, rootHash)); // true
