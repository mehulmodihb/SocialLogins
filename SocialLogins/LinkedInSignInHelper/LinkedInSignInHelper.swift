//
//  LinkedInSignInHelper.swift
//  SocialLogins
//
//  Created by hb on 19/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit
import OAuthSwift
import SafariServices
import WebKit

class LinkedInSignInHelper: NSObject {

    static let shared = LinkedInSignInHelper()
    
    private var key: String = ""
    private var secret: String = ""
    private var viewController: UIViewController!
    private var loggedIn: ((_ error: LinkedInError?, _ user: LinkedInUserModel?) -> Void)?

    private var oauth: OAuth2Swift!
    
    private func configure(with key: String, and secret: String) {
        self.key = key
        self.secret = secret

        oauth = OAuth2Swift(
            consumerKey:    key,
            consumerSecret: secret,
            authorizeUrl:   "https://www.linkedin.com/uas/oauth2/authorization",
            accessTokenUrl: "https://www.linkedin.com/uas/oauth2/accessToken",
            responseType:   "code"
        )
        
        oauth?.authorizeURLHandler = getURLHandler()
    }

    // MARK: handler
    private func getURLHandler() -> OAuthSwiftURLHandlerType {
        let handler = SafariURLHandler(viewController: viewController, oauthSwift: self.oauth!)
        handler.presentCompletion = {
            print("Safari presented")
        }
        handler.dismissCompletion = {
            print("Safari dismissed")
        }
        handler.factory = { url in
            let controller = SFSafariViewController(url: url)
            // Customize it, for instance
            if #available(iOS 10.0, *) {
                //  controller.preferredBarTintColor = UIColor.red
            }
            return controller
        }
        return handler
    }
    
    static func openURL(_ url: URL) -> Bool {
        OAuthSwift.handle(url: url)
        return true
    }
    
    private func getLinkedinProfile(_ oauthswift: OAuth2Swift) {
        let _ = oauthswift.client.get(
        "https://api.linkedin.com/v2/me?projection=(id,localizedFirstName,localizedLastName,profilePicture(displayImage~:playableStreams))", parameters: [:]) { result in
            switch result {
            case .success(let resp):
                let jsonString = (resp.dataString(encoding: .utf8) ?? "").replacingOccurrences(of: "displayImage~", with: "displayImageDetail")
                if let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let decoder = JSONDecoder()
                        let profile = try decoder.decode(LinkedInUserModel.self, from: jsonData)
                        self.loggedIn?(nil, profile)
                    } catch {
                        let err = LinkedInError(title: "JSON format", description: error.localizedDescription, code: -1)
                        self.loggedIn?(err, nil)
                    }
                }
            case .failure(let error):
                print(error)
                self.loggedIn?(LinkedInError(title: "LinkedIn Error", description: error.description, code: -3), nil)
            }
        }
    }
    
    func login(with key: String, and secret: String, redirectUrl: String, viewController: UIViewController, callback: @escaping(_ error: LinkedInError?, _ user: LinkedInUserModel?) -> Void) {
        self.viewController = viewController
        self.loggedIn = callback
        configure(with: key, and: secret)
        let state = generateState(withLength: 20)
        let _ = oauth.authorize(
        withCallbackURL: URL(string: redirectUrl)!, scope: "r_liteprofile", state: state) { result in
            switch result {
            case .success((_, _, _)):
                self.getLinkedinProfile(self.oauth)
            case .failure(let error):
                print(error.description)
                self.loggedIn?(LinkedInError(title: "LinkedIn Error", description: error.description, code: -3), nil)
            }
        }
    }
    
    func logout() {
        let dataTypes = Set([WKWebsiteDataTypeCookies,
                             WKWebsiteDataTypeLocalStorage, WKWebsiteDataTypeSessionStorage,
                             WKWebsiteDataTypeWebSQLDatabases, WKWebsiteDataTypeIndexedDBDatabases])
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypes, modifiedSince: Date().addingTimeInterval(-100000), completionHandler: {
            
        })
    }
}
