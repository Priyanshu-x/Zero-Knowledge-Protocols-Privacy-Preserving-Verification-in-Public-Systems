
let provider;
let signer;
let contract;

const contractAddress = "PUT_DEPLOYED_CONTRACT_ADDRESS_HERE";
const contractABI = [
  "function registerUser(address _user) public",
  "function isUserVerified(address _user) public view returns (bool)",
  "function revokeUser(address _user) public"
];

// Connect MetaMask
document.getElementById("connectWallet").onclick = async function() {
  if (window.ethereum) {
    provider = new ethers.providers.Web3Provider(window.ethereum);
    await provider.send("eth_requestAccounts", []);
    signer = provider.getSigner();
    contract = new ethers.Contract(contractAddress, contractABI, signer);
    document.getElementById("output").innerText = "✅ Wallet connected!";
  } else {
    alert("Please install MetaMask!");
  }
};

// Register User
async function registerUser() {
  const address = document.getElementById("userAddress").value;
  try {
    const tx = await contract.registerUser(address);
    await tx.wait();
    document.getElementById("output").innerText = "User registered successfully!";
  } catch (err) {
    document.getElementById("output").innerText = "Error: " + err.message;
  }
}

// Check Verification
async function checkVerification() {
  const address = document.getElementById("userAddress").value;
  try {
    const verified = await contract.isUserVerified(address);
    document.getElementById("output").innerText = verified ? "✅ User is verified" : "❌ User not verified";
  } catch (err) {
    document.getElementById("output").innerText = "Error: " + err.message;
  }
}

// Revoke User
async function revokeUser() {
  const address = document.getElementById("userAddress").value;
  try {
    const tx = await contract.revokeUser(address);
    await tx.wait();
    document.getElementById("output").innerText = "User revoked successfully!";
  } catch (err) {
    document.getElementById("output").innerText = "Error: " + err.message;
  }
}
