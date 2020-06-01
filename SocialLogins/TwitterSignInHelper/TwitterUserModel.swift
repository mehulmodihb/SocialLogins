//
//  TwitterUserModel.swift
//  SocialLogins
//
//  Created by hb on 18/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import Foundation

public struct TwitterUserModel: Codable {
    public var email: String?
    public var id: String?
    public var name: String?
    public var profileImageURL: String?
    public var username: String?
    public var oauthToken: String?
    
    private enum CodingKeys: String, CodingKey {
        case email
        case id = "id_str"
        case name
        case profileImageURL = "profile_image_url"
        case username = "screen_name"
        case oauthToken = "oauth_token"
    }
}
