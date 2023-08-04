// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract VerifyDB {
    struct Verification {
        string updateID;
        string updateHash;
    }

    address owner;

    uint verification_count;
    mapping(uint => Verification) verifications;

    event HashRegistered(string updateId);

    function registerVerification(
        string memory id,
        string memory uhash
    ) public restrictPublisher {
        for (uint i = 0; i < verification_count; i++) {
            if (
                (keccak256(abi.encodePacked(verifications[i].updateID)) ==
                    keccak256(abi.encodePacked(id)))
            ) {
                return;
            }
        }
        verifications[verification_count] = Verification(id, uhash);
        verification_count++;

        emit HashRegistered(id);
    }

    modifier restrictPublisher() {
        require(msg.sender == owner);
        _;
    }

    function checkVerification(
        string memory updateID,
        string memory updateHash
    ) public view returns (bool success) {
        for (uint i = 0; i < verification_count; i++) {
            if (
                (keccak256(abi.encodePacked(verifications[i].updateID)) ==
                    keccak256(abi.encodePacked(updateID))) &&
                (keccak256(abi.encodePacked(verifications[i].updateHash)) ==
                    keccak256(abi.encodePacked(updateHash)))
            ) {
                return true;
            }
        }
        return false;
    }

    function getUpdateCount() public view returns (uint) {
        return verification_count;
    }

    constructor(address owneraddress) {
        owner = owneraddress;
    }
}
