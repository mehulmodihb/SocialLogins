//
//  LinkedInUserModel.swift
//  SocialLogins
//
//  Created by hb on 19/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import Foundation

public struct LinkedInUserModel: Codable {
    let id : String?
    let firstName : String?
    let lastName : String?
    let profilePicture : ProfilePicture?
    
    var profilePictureUrls: [String]? {
        if let elements = profilePicture?.displayImageDetail?.elements {
            return elements.compactMap({$0.identifiers?.first?.identifier})
        }
        return nil
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case localizedFirstName = "localizedFirstName"
        case localizedLastName = "localizedLastName"
        case profilePicture
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        firstName = try values.decodeIfPresent(String.self, forKey: .localizedFirstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .localizedLastName)
        profilePicture = try values.decodeIfPresent(ProfilePicture.self, forKey: .profilePicture)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .localizedFirstName)
        try container.encode(lastName, forKey: .localizedLastName)
        try container.encode(profilePicture, forKey: .profilePicture)
    }
}

struct ProfilePicture : Codable {

    let displayImage : String?
    let displayImageDetail : DisplayImageDetail?


    enum CodingKeys: String, CodingKey {
        case displayImage = "displayImage"
        case displayImageDetail
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        displayImage = try values.decodeIfPresent(String.self, forKey: .displayImage)
        displayImageDetail = try values.decodeIfPresent(DisplayImageDetail.self, forKey: .displayImageDetail)
    }
}

struct DisplayImageDetail : Codable {
    let elements : [Element]?

    enum CodingKeys: String, CodingKey {
        case elements = "elements"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        elements = try values.decodeIfPresent([Element].self, forKey: .elements)
    }

}

struct Element : Codable {
    let artifact : String?
    let authorizationMethod : String?
    let identifiers : [Identifier]?

    enum CodingKeys: String, CodingKey {
        case artifact = "artifact"
        case authorizationMethod = "authorizationMethod"
        case identifiers = "identifiers"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        artifact = try values.decodeIfPresent(String.self, forKey: .artifact)
        authorizationMethod = try values.decodeIfPresent(String.self, forKey: .authorizationMethod)
        identifiers = try values.decodeIfPresent([Identifier].self, forKey: .identifiers)
    }

}

struct Identifier : Codable {
    let file : String?
    let identifier : String?
    let identifierExpiresInSeconds : Int?
    let identifierType : String?
    let index : Int?
    let mediaType : String?

    enum CodingKeys: String, CodingKey {
        case file = "file"
        case identifier = "identifier"
        case identifierExpiresInSeconds = "identifierExpiresInSeconds"
        case identifierType = "identifierType"
        case index = "index"
        case mediaType = "mediaType"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        file = try values.decodeIfPresent(String.self, forKey: .file)
        identifier = try values.decodeIfPresent(String.self, forKey: .identifier)
        identifierExpiresInSeconds = try values.decodeIfPresent(Int.self, forKey: .identifierExpiresInSeconds)
        identifierType = try values.decodeIfPresent(String.self, forKey: .identifierType)
        index = try values.decodeIfPresent(Int.self, forKey: .index)
        mediaType = try values.decodeIfPresent(String.self, forKey: .mediaType)
    }

}
