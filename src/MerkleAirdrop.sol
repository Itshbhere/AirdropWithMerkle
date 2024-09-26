// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop {
    using SafeERC20 for IERC20;

    error MerkleAirdrop_InvalidProof();
    event Claim(address account, uint256 amount);

    address[] claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_DeathToken;

    constructor(bytes32 merkleRoot, IERC20 DeathToken) {
        i_merkleRoot = merkleRoot;
        i_DeathToken = DeathToken;
    }

    function claim(
        address account,
        uint256 amount,
        bytes32[] calldata merkleProof
    ) external {
        bytes32 leaf = keccak256(
            bytes.concat(keccak256(abi.encode(account, amount)))
        );
        if (MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert MerkleAirdrop_InvalidProof();
        }
        emit Claim(account, amount);
        i_DeathToken.safeTransfer(account, amount);
    }
}
