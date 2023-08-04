package com.evilbas.ethverify.service;

import java.security.InvalidAlgorithmParameterException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;

import org.web3j.crypto.Credentials;
import org.web3j.crypto.Keys;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.http.HttpService;
import org.web3j.tx.gas.DefaultGasProvider;

import com.evilbas.ethverify.contracts.generated.VerifyDB;

import lombok.Builder;

@Builder
public class Verifier {

    private String address;
    private Web3j ethereumClient;
    private String contractAddress;

    public Boolean verifyUpdate(String updateID, String updateHash)
            throws Exception {
        ethereumClient = Web3j.build(new HttpService(address));
        Credentials dummyCredentials = Credentials.create(Keys.createEcKeyPair());
        VerifyDB verifyDB = VerifyDB.load(contractAddress, ethereumClient,
                dummyCredentials,
                new DefaultGasProvider());
        return verifyDB.checkVerification(updateID, updateHash).send();
    }

    public void registerVerification(String updateID, String updateHash, Credentials credentials) throws Exception {
        ethereumClient = Web3j.build(new HttpService(address));
        VerifyDB verifyDB = VerifyDB.load(contractAddress, ethereumClient,
                credentials,
                new DefaultGasProvider());
        var res = verifyDB.registerVerification(updateID, updateHash).send();
        System.out.println(res);

    }
}
