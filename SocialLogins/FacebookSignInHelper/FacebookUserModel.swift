//
//  FacebookUserModel.swift
//  SocialLogins
//
//  Created by hb on 18/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit

public struct FacebookUserModel {
    public var id: String
    public var fullname: String
    public var email: String
    
    init(fb: [String: Any]) {
        self.id = fb["id"] as? String ?? "0"
        self.fullname = fb["name"] as? String ?? ""
        self.email = fb["email"] as? String ?? ""
    }
}
