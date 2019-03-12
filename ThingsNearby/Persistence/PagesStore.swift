//
//  PagesStore.swift
//  ThingsNearby
//
//  Created by Simon Haycock on 3/12/19.
//  Copyright © 2019 Expedia. All rights reserved.
//

import Foundation

class PagesStore {
    
    let pagesKey = "PagesKey"
    
    func pages() -> Pages? {
        
        guard let pagesData = UserDefaults.standard.object(forKey: pagesKey) as? Data else { return nil }
        
        let pages = try? JSONDecoder().decode(Pages.self, from: pagesData)
        
        return pages
    }
    
    func store(_ pages: Pages) {
        
        let pagesJSON = try? JSONEncoder().encode(pages)
        UserDefaults.standard.set(pagesJSON, forKey: pagesKey)
        UserDefaults.standard.synchronize()
    }
}
