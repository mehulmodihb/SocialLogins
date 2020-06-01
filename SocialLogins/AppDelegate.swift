//
//  AppDelegate.swift
//  SocialLogins
//
//  Created by hb on 16/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.absoluteString.contains("google") {
            return GoogleSignInHelper.openURL(url)
        } else if url.absoluteString.contains("fb") {
            return FacebookSignInHelper.openURL(app: application, url: url, options: [:])
        } else if url.absoluteString.contains("twitter-") {
            return TwitterSignInHelper.openURL(url)
        } else if url.absoluteString.contains("linkedin") {
            return LinkedInSignInHelper.openURL(url)
        }
        return true
    }
    
    // add openURL method
    func  application(_ application:  UIApplication, open url:  URL, options:  [UIApplication.OpenURLOptionsKey  :  Any]  =  [:])  ->  Bool  {
        if url.absoluteString.contains("google") {
            return GoogleSignInHelper.openURL(url)
        } else if url.absoluteString.contains("fb") {
            return FacebookSignInHelper.openURL(app: application, url: url, options: options)
        } else if url.absoluteString.contains("twitterkit-") {
            return TwitterSignInHelper.openURL(url)
        } else if url.absoluteString.contains("linkedin") {
            return LinkedInSignInHelper.openURL(url)
        }
        return true
    }
    
    /*
     if url.absoluteString.contains("google") {
         return DTGoogleLogin.openURL(url, options: options)
     }
     else if url.absoluteString.contains("fb") {
         return DTFacebook.openURL(app: app, url: url, options: options)
     }
     else if url.absoluteString.contains("dttwitter-") {
         return DTTwitter.openURL(url)
     }
     
     return true
     */

}

