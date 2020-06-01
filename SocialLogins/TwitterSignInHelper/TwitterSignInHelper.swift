//
//  TwitterSignInHelper.swift
//  SocialLogins
//
//  Created by hb on 18/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit
import OAuthSwift
import WebKit

struct TwitterHelperURL {
    struct OAuth1 {
        static let RequestToken = "https://api.twitter.com/oauth/request_token"
        static let Authorize = "https://api.twitter.com/oauth/authorize"
        static let Authenticate = "https://api.twitter.com/oauth/authenticate"
        static let AccessToken = "https://api.twitter.com/oauth/access_token"
        static let Invalidate = "https://api.twitter.com/oauth/invalidate_token"
        static let Account = "https://api.twitter.com/1.1/account/verify_credentials.json?include_email=true&skip_status=1&include_entities=false"
    }
    struct OAuth2 {
        static let BearerToken = "https://api.twitter.com/oauth2/token"
        static let InvalidateBearerToken = "https://api.twitter.com/oauth2/invalidate_token"
    }
}

class TwitterSignInHelper: NSObject {
    
    static let shared = TwitterSignInHelper()
    
    private var key: String = ""
    private var secret: String = ""
    private var callbackUrl: String = ""
    
    private var oauth: OAuth1Swift?
    
    private func configure(with key: String, and secret: String) {
        self.key = key
        self.secret = secret

        oauth = OAuth1Swift(
            consumerKey:    key,
            consumerSecret: secret,
            requestTokenUrl: TwitterHelperURL.OAuth1.RequestToken,
            authorizeUrl:    TwitterHelperURL.OAuth1.Authorize,
            accessTokenUrl:  TwitterHelperURL.OAuth1.AccessToken
        )
    }
    
    private func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch _ {
            return []
        }
    }
    
    static func openURL(_ url: URL) -> Bool {
        OAuthSwift.handle(url: url)
        return true
    }
    
    func login(with key: String, and secret: String, callback: @escaping (_ error: TwitterError?, _ user: TwitterUserModel?) -> Void) {
        if key.count > 0 && secret.count > 0 {
            callbackUrl = "twitterkit-\(key)://"
            configure(with: key, and: secret)
            let _ = self.oauth?.authorize(withCallbackURL: self.callbackUrl, completionHandler: { (result) in
                    
                switch result {
                case .success(let (credential, _, _)):
                    
                    self.oauth?.client.get(TwitterHelperURL.OAuth1.Account, completionHandler: { (resultClient) in
                        switch (resultClient) {
                        case .success(let  resp):
                            if let jsonData = (resp.dataString(encoding: .utf8) ?? "").data(using: .utf8) {
                                do {
                                    let decoder = JSONDecoder()
                                    var profile = try decoder.decode(TwitterUserModel.self, from: jsonData)
                                    profile.oauthToken = credential.oauthToken
                                    callback(nil, profile)
                                } catch {
                                    let err = TwitterError(title: "JSON format", description: error.localizedDescription, code: -1)
                                    callback(err, nil)
                                }
                            }
                        case .failure(let err):
                            let error = TwitterError(title: "OauthSwift Problem", description: err.description, code: err.errorCode)
                            callback(error, nil)
                        }
                    })
                case .failure(let error):
                    let err = TwitterError(title: "OauthSwift Problem", description: error.description, code: error.errorCode)
                    callback(err, nil)
                }
            })
        }
        else {
            let err = TwitterError(title: "Twitter Key & Secret", description: "Please provide twitter app key and twitter app secret", code: -2)
            callback(err, nil)
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
