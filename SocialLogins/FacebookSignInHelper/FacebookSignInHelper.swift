//
//  FacebookSignInHelper.swift
//  SocialLogins
//
//  Created by hb on 18/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookSignInHelper: NSObject {
    static let shared = FacebookSignInHelper()
    //private var scopes: [String] = ["email", "public_profile"]
    private var scopes: [String] = []
    
    static func setup(app: UIApplication, options: [UIApplication.LaunchOptionsKey: Any]?) {
        FBSDKCoreKit.ApplicationDelegate.shared.application(app, didFinishLaunchingWithOptions: options)
    }
    
    static func openURL(app: UIApplication, url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return  FBSDKCoreKit.ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func login(with scopes:[String] = [], from viewController: UIViewController, callback: @escaping(_ error: FacebookError?, _ user: FacebookUserModel?) -> Void) {
        self.scopes = scopes
        self.login(from: viewController) { (status, message, user) in
            if let user = user {
                callback(nil, user)
            }
            else {
                let error = FacebookError(title: "Facebook Error", description: message, code: -3)
                callback(error, nil)
            }
        }
    }
    
    func logout() {
        FBSDKLoginKit.LoginManager().logOut()
    }
    
    private func login(from viewController: UIViewController, done: @escaping(_ status: Bool, _ message: String, _ user: FacebookUserModel?) -> Void) {
        
        let login = FBSDKLoginKit.LoginManager()
        login.defaultAudience = .everyone
        
        if scopes.count == 0 {
            scopes = ["email", "public_profile"]
        }
        
        login.logIn(permissions: scopes, from: viewController) { (result, error) in
            DispatchQueue.main.async {
                if error != nil {
                    done(false, error!.localizedDescription, nil)
                }
                else if let result = result {
                    if result.isCancelled && result.declinedPermissions.count > 0 {
                        done(false, "facebook_cancel_declined", nil)
                    }
                    else {
                        //let userID = result.token?.userID
                        self.graph(str: "/me?fields=email,name", done: done)
                    }
                }
            }
        }
    }
    
    private func graph(str: String, done: @escaping(_ status: Bool, _ message: String, _ user: FacebookUserModel?) -> Void) {
        let connection = FBSDKCoreKit.GraphRequestConnection()
        let request = FBSDKCoreKit.GraphRequest(graphPath: str)
        connection.add(request) { (conn, result, error) in
            if error != nil {
                done(false, error!.localizedDescription, nil)
            }
            else if let resultData = result as? [String: Any] {
                let fb = FacebookUserModel(fb: resultData)
                done(true, "", fb)
            }
            else {
                done(false, "facebook_failed", nil)
            }
        }
        connection.start()
    }
}
