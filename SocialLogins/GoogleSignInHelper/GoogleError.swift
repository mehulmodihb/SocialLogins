//
//  GoogleError.swift
//  SocialLogins
//
//  Created by hb on 16/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import Foundation

protocol GoogleErrorProtocol: LocalizedError  {
    var title: String? { get }
    var code: Int { get }
}

struct GoogleError: GoogleErrorProtocol {

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
