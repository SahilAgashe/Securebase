//
//  SecureMgr.swift
//  Securebase
//
//  Created by SAHIL AMRUT AGASHE on 22/06/24.
//

import Foundation

private let kDebugSecureMgr = "DEBUG SecureMgr: "
class SecureMgr {
    
    static func addToKeychain(query: [String: Any]) -> Bool {
        let resultantOSStatus = SecItemAdd(query as CFDictionary, nil)
        let cfMsg = SecCopyErrorMessageString(resultantOSStatus, nil)
        print("cfMsg ==> ", cfMsg ?? "\(kDebugSecureMgr) Unable to get cfMsg")
        return resultantOSStatus == errSecSuccess
    }
    
    static func storeLogin(username: String, password: String) -> Bool {
        // TODO : Store in Keychain
        guard let pwData = password.data(using: .utf8) else {
            print(kDebugSecureMgr, "Guard let error for unwrapping password data")
            return false
        }
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: username,
                                    kSecValueData as String: pwData]
        return addToKeychain(query: query)
    }
}
