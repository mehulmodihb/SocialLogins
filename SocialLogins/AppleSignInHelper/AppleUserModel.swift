//
//  AppleUserModel.swift
//  SocialLogins
//
//  Created by hb on 18/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import Foundation
import AuthenticationServices

public struct AppleUserModel {
    public var id: String
    public var fullname: String
    public var email: String
    
    @available(iOS 13, *)
    init(credential: ASAuthorizationAppleIDCredential) {
        let given = credential.fullName?.givenName ?? ""
        let family = credential.fullName?.familyName ?? ""
        self.id = credential.user
        self.fullname = "\(given) \(family)"
        self.email = credential.email ?? ""
        
    }
}
