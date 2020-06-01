//
//  GoogleUserModel.swift
//  SocialLogins
//
//  Created by hb on 16/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import Foundation
import GoogleSignIn

public struct GoogleUserModel {
    
    public var userID: String
    public var fullname: String
    public var email: String
    public var token: String
    public var imageURL: URL?
    public var user:  GIDGoogleUser
    
    init(from user: GIDGoogleUser) {
        self.userID = user.userID ?? "0"
        self.token = user.authentication.idToken ?? ""
        self.fullname = user.profile.name ?? ""
        self.email = user.profile.email ?? ""
        self.imageURL = user.profile.imageURL(withDimension: 100)
        self.user = user
    }
    
    func getImageUrl(withDimension dimension: CGFloat) {
        self.user.profile.imageURL(withDimension: UInt(dimension))
    }
}
