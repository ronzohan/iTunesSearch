//
//  Article.swift
//  Psychia
//
//  Created by Ron Daryl Magno on 26/07/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation

struct Article: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case htmlContent = "html_content"
        case imageURL = "image_url"
        case videoURL = "video_url"
        case externalURL = "external_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    enum AlternateCodingKeys: String, CodingKey {
        case description
        case file
    }

    let id: Int
    let title: String
    let htmlContent: String
    let imageURL: String?
    let videoURL: String?
    let externalURL: String?
    let createdAt: String
    let updatedAt: String

    init(id: Int,
         title: String,
         htmlContent: String,
         imageURL: String?,
         videoURL: String?,
         externalURL: String?,
         createdAt: String,
         updatedAt: String) {

        self.id = id
        self.title = title
        self.htmlContent = htmlContent
        self.imageURL = imageURL
        self.videoURL = videoURL
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.externalURL = externalURL
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let alternateContainer = try decoder.container(keyedBy: AlternateCodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        htmlContent = try container.decodeIfPresent(String.self, forKey: .htmlContent) ??
            (try alternateContainer.decode(String.self, forKey: .description))
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        videoURL = try container.decodeIfPresent(String.self, forKey: .videoURL) ??
            (try alternateContainer.decodeIfPresent(String.self, forKey: .file))
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        externalURL = try container.decodeIfPresent(String.self, forKey: .externalURL)
    }
}
