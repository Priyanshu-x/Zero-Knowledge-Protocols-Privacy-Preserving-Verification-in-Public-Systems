// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Zero-Knowledge Protocols: Privacy-Preserving Verification
 * @dev A smart contract demonstrating zero-knowledge proof concepts
 * @author ZK Protocol Team
 */
contract Project {
    
    // Events for frontend interaction
    event SecretCommitted(address indexed user, bytes32 commitment, uint256 timestamp);
    event ProofVerified(address indexed user, bool isValid, uint256 timestamp);
    event AgeVerified(address indexed user, bool isValid, uint256 timestamp);
    
    // Struct to store user commitments
    struct Commitment {
        bytes32 hash;
        uint256 timestamp;
        bool isRevealed;
    }
    
    // Mappings for different verification types
    mapping(address => Commitment) private secretCommitments;
    mapping(address => bool) public verifiedUsers;
    mapping(address => bool) public ageVerifiedUsers;
    
    // Contract owner
    address public owner;
    
    // Minimum age for verification (18 years)
    uint256 public constant MIN_AGE = 18;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    /**
     * @dev Core Function 1: Commit to a secret using hash commitment
     * @param _commitment The hash of the secret (keccak256(secret + nonce))
     * This simulates the commitment phase of a zero-knowledge proof
     */
    function commitSecret(bytes32 _commitment) external {
        require(_commitment != bytes32(0), "Invalid commitment");
        require(secretCommitments[msg.sender].hash == bytes32(0), "Commitment already exists");
        
        secretCommitments[msg.sender] = Commitment({
            hash: _commitment,
            timestamp: block.timestamp,
            isRevealed: false
        });
        
        emit SecretCommitted(msg.sender, _commitment, block.timestamp);
    }
    
    /**
     * @dev Core Function 2: Verify knowledge of secret without revealing it
     * @param _secret The original secret value
     * @param _nonce The nonce used in commitment
     * This simulates zero-knowledge proof verification
     */
    function verifySecret(string memory _secret, uint256 _nonce) external returns (bool) {
        require(secretCommitments[msg.sender].hash != bytes32(0), "No commitment found");
        require(!secretCommitments[msg.sender].isRevealed, "Secret already revealed");
        
        // Recreate the commitment hash
        bytes32 computedHash = keccak256(abi.encodePacked(_secret, _nonce));
        
        bool isValid = (computedHash == secretCommitments[msg.sender].hash);
        
        if (isValid) {
            secretCommitments[msg.sender].isRevealed = true;
            verifiedUsers[msg.sender] = true;
        }
        
        emit ProofVerified(msg.sender, isValid, block.timestamp);
        return isValid;
    }
    
    /**
     * @dev Core Function 3: Age verification using zero-knowledge proof simulation
     * @param _ageProof A simulated proof that age >= 18 (in real ZK, this would be a cryptographic proof)
     * @param _merkleRoot Simulated merkle root for additional verification
     * This demonstrates privacy-preserving age verification
     */
    function verifyAge(uint256 _ageProof, bytes32 _merkleRoot) external returns (bool) {
        require(_ageProof > 0, "Invalid age proof");
        require(_merkleRoot != bytes32(0), "Invalid merkle root");
        
        // Simplified ZK age verification simulation
        // In a real implementation, this would verify a zero-knowledge proof
        // that the user's age is >= 18 without revealing the actual age
        
        // Simulate proof verification using hash computation
        bytes32 proofHash = keccak256(abi.encodePacked(msg.sender, _ageProof, _merkleRoot));
        uint256 proofResult = uint256(proofHash) % 100;
        
        // Consider proof valid if result meets certain criteria (simulation)
        bool isValid = (proofResult >= 18 && _ageProof >= MIN_AGE);
        
        if (isValid) {
            ageVerifiedUsers[msg.sender] = true;
        }
        
        emit AgeVerified(msg.sender, isValid, block.timestamp);
        return isValid;
    }
    
    // View functions for frontend interaction
    function getCommitment(address _user) external view returns (bytes32, uint256, bool) {
        Commitment memory commitment = secretCommitments[_user];
        return (commitment.hash, commitment.timestamp, commitment.isRevealed);
    }
    
    function isVerifiedUser(address _user) external view returns (bool) {
        return verifiedUsers[_user];
    }
    
    function isAgeVerified(address _user) external view returns (bool) {
        return ageVerifiedUsers[_user];
    }
    
    function getContractInfo() external view returns (address, uint256, uint256) {
        return (owner, address(this).balance, block.timestamp);
    }
}
