//
//  Models.swift
//  ThingsNearby
//
//  Created by Simon Haycock on 2/6/19.
//  Copyright © 2019 Expedia. All rights reserved.
//

import Foundation

struct PageImage: Codable {
    let source: String
    let width: Int
    let height: Int
    init(source: String) {
        self.source = source
        self.width = 30
        self.height = 30
    }
}

struct Terms: Codable {
    let description: [String]?
}

struct Coordinate: Codable {
    let lat: Double
    let lon: Double
}

struct Page: Codable {
    let pageid: Int
    let title: String
    let thumbnail: PageImage?
    let original: PageImage?
    let coordinates: [Coordinate]
    let terms: Terms?
    let fullurl: String
}

struct Pages: Codable {
    let pages: [Page]
    func pagesInTitleOrder() -> Pages {
        let sortedPages = pages.sorted { (first: Page, second: Page) -> Bool in
            if first.title < second.title {
                return true
            } else {
                return false
            }
        }
        return Pages(pages: sortedPages)
    }
}

struct GeoQuery: Decodable {
    let query: Pages
}
