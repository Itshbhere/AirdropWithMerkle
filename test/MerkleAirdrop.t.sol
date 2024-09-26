// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {DeathToken} from "../src/DeathToken.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";

contract MerkleAirdropTest is Test {
    //Contract Variables
    MerkleAirdrop public t_MerkleAirdrop;
    DeathToken public t_DeathToken;

    //New User Created
    address public user;
    uint256 public userPrvKey;

    //Claiming Variables
    uint256 public claimAmount = 25 * 1e18;

    // Proofs
    bytes32 Proof1 = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 Proof2 = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;

    bytes32[] public merkleProof = [Proof1, Proof2];
    bytes32 public merkleRoot = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;

    function setUp() public {
        t_DeathToken = new DeathToken();
        t_MerkleAirdrop = new MerkleAirdrop(merkleRoot, t_DeathToken);
        (user, userPrvKey) = makeAddrAndKey("user");
    }

    function testUsers() public {
        console.log(user);
        uint256 StartingBalance = t_DeathToken.balanceOf(user);
        console.log("Starting Banlance is ", StartingBalance);

        vm.prank(user);
        t_MerkleAirdrop.claim(user, claimAmount, merkleProof);

        uint256 EndingBalance = t_DeathToken.balanceOf(user);
        console.log("Ending Balnace is ", EndingBalance);
        assertEq(StartingBalance, EndingBalance - claimAmount);
    }
}
