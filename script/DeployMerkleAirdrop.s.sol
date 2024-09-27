// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {DeathToken} from "../src/DeathToken.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {Script} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract DeployMerkleAirdrop is Script {
    bytes32 Merkleroot = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    uint256 AmountToClaim = 4 * 25 * 1e18;

    function deployMerkleAirdrop() public returns (DeathToken, MerkleAirdrop) {
        vm.startBroadcast();
        DeathToken deathToken = new DeathToken();
        MerkleAirdrop airdrop = new MerkleAirdrop(Merkleroot, IERC20(address(deathToken)));
        deathToken.mint(deathToken.owner(), AmountToClaim);
        deathToken.transfer(address(airdrop), AmountToClaim);
        vm.stopBroadcast();
        return (deathToken, airdrop);
    }

    function run() public returns (DeathToken, MerkleAirdrop) {
        return deployMerkleAirdrop();
    }
}
