//
//  UILogin.swift
//  Securebase
//
//  Created by SAHIL AMRUT AGASHE on 22/06/24.
//

import UIKit

let LOGGEDIN = "LoggedIn"

extension UIViewController {
    
    /// Prompt the user for login.
    /// - parameter completion: Called with user credentials, if any
    /// - parameter username: The entered username or nil
    /// - parameter password: The entered password or nil
    func loginPrompt(completion : @escaping (_ username : String?,_ password : String?)->Void) {
        let alert = UIAlertController(title: "Login", message: "Enter Your Login Credentials", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            completion(nil,nil)
        }))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Username"
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        })

        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { action in
            print ("\(alert.textFields?.first?.text ?? "nil") \(alert.textFields?.last?.text ?? "nil")")
            // return the entered values
            completion(alert.textFields?.first?.text, alert.textFields?.last?.text)
        }))

        self.present(alert, animated: true)
    }
    
    // MARK: - Login/out
    
    func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: LOGGEDIN)
    }
    
    /// Auto log out when going to background in [sceneDidEnterBackground](x-source-tag://sceneDidEnterBackground)
    func logout() {
        UserDefaults.standard.set(false, forKey: LOGGEDIN)
    }
    
    func login(completion: @escaping (UserLogin?)->Void) {
        if !UserDefaults.standard.bool(forKey: LOGGEDIN) {
            
            // May want Biometric authentication

            self.loginPrompt { (username, password) in
                // verify
                guard let un = username, let pw = password else {
                    // if either are nil, log out and
                    // call completion handler w/ nil
                    self.logout()
                    print ("Login failed. Credentials NOT stored.")
                    completion(nil)
                    return
                }
                
                // Store login
                let stored = SecureMgr.storeLogin(username: un, password: pw)
                print ("Login was \(stored ? "" : "NOT") stored.")
                
                // logged in (even if not stored)
                UserDefaults.standard.set(true, forKey: LOGGEDIN)
                
                // create and send UserLogin
                let userlogin = UserLogin(username: un, password: pw)
                completion(userlogin)
            }
        }
    }
}

