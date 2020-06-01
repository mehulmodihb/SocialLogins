//
//  ViewController.swift
//  SocialLogins
//
//  Created by hb on 16/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction private func googleSignIntapped(_ sender: Any) {
        GoogleSignInHelper.shared.login(with: SocialCredentials.Google.clientId, from: self) { (error, user) in
            if let user = user {
                print(user)
            } else {
                print(error ?? "Unknown Error")
            }
        }
    }
    
    @IBAction private func facebookSignInTapped(_ sender: Any) {
        FacebookSignInHelper.shared.login(from: self) { (error, user) in
            if let user = user {
                print(user)
            } else {
                print(error ?? "Unknown Error")
            }
        }
    }
    
    @IBAction private func appleSignInTapped(_ sender: Any) {
        if #available(iOS 13, *) {
            AppleSignInHelper.shared.login(from: self) { (error, user) in
                if let user = user {
                    print(user)
                } else {
                    print(error ?? "Unknown Error")
                }
            }
        } else {
            // Fallback on earlier versions
            print("Sign in with Apple require iOS 13 and later")
        }
    }
    
    @IBAction private func twitterSignInTapped(_ sender: Any) {
        TwitterSignInHelper.shared.login(with: SocialCredentials.Twitter.kAPIKey, and: SocialCredentials.Twitter.kAPISecret) { (error, user) in
            if let user = user {
                print(user)
            } else {
                print(error ?? "Unknown Error")
            }
        }
    }
    
    @IBAction private func linkedInSignInTapped(_ sender: Any) {
        LinkedInSignInHelper.shared.login(with: SocialCredentials.LinkedIn.clientId, and: SocialCredentials.LinkedIn.clientSecret, redirectUrl: "http://localhost:8080/callback.php", viewController: self) { (error, user) in
            if let user = user {
                print(user)
                print(user.profilePictureUrls)
            } else {
                print(error ?? "Unknown Error")
            }
            LinkedInSignInHelper.shared.logout()
        }
    }
}

