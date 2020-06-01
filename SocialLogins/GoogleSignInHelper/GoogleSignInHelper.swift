//
//  GoogleSignIn.swift
//  SocialLogins
//
//  Created by hb on 16/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit
import GoogleSignIn

class GoogleSignInHelper: NSObject {
    
    static let shared: GoogleSignInHelper = GoogleSignInHelper()
    
    private var loggedIn: ((_ status: Bool, _ error: String, _ user: GoogleUserModel?) -> Void)?
    private var scopes: [String] = []
    
    private var viewController: UIViewController? {
        didSet {
            GIDSignIn.sharedInstance()?.presentingViewController = viewController
        }
    }
    
    private func login() {
        if scopes.count > 0 {
            GIDSignIn.sharedInstance()?.scopes = scopes
        }
        GIDSignIn.sharedInstance().signIn()
    }
    
    static func openURL(_ url: URL) -> Bool {
        return GIDSignIn.sharedInstance()?.handle(url) ?? false
    }
    
    func login(with clientId:String, scopes:[String] = [], from viewController: UIViewController, callback: @escaping(_ error: GoogleError?, _ user: GoogleUserModel?) -> Void) {
        GIDSignIn.sharedInstance()?.clientID = clientId
        GIDSignIn.sharedInstance()?.delegate = self
        self.scopes = scopes
        self.viewController = viewController
        self.loggedIn = { status, message, user in
            if let user = user {
                callback(nil, user)
            }
            else {
                let error =  GoogleError(title: "Google Error", description: message, code: -3)
                callback(error, nil)
            }
        }
        self.login()
    }
    
    func logout() {
        GIDSignIn.sharedInstance()?.signOut()
    }
    
}

extension GoogleSignInHelper: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            self.loggedIn?(false, error.localizedDescription, nil)
        }
        else {
            let user = GoogleUserModel(from: user)
            self.loggedIn?(true, "", user)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        self.loggedIn?(false, error.localizedDescription, nil)
    }
}
