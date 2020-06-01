//
//  TwitterError.swift
//  SocialLogins
//
//  Created by hb on 18/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import Foundation

protocol TwitterErrorProtocol: LocalizedError  {
    var title: String? { get }
    var code: Int { get }
}

struct TwitterError: TwitterErrorProtocol {

    var title: String?
    var code: Int
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }

    private var _description: String

    init(title: String?, description: String, code: Int) {
        self.title = title ?? "Error"
        self._description = description
        self.code = code
    }
}
