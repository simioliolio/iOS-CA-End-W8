//
//  ThingsViewController.swift
//  ThingsNearby
//
//  Created by Simon Haycock on 2/19/19.
//  Copyright © 2019 Expedia. All rights reserved.
//

import UIKit

class ThingsViewController: UITableViewController {
    
    var pages: Pages?
    
    let location = Location()
    let mediaWiki = MediaWiki()
    let pagesStore = PagesStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pages = pagesStore.pages()
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        
        guard let userLocation = location.current else {
            let errorVC = UIAlertController(title: "Error", message: "No location!", preferredStyle: .alert)
            errorVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(errorVC, animated: true, completion: nil)
            return
        }
        
        mediaWiki.pagesNear(location: userLocation) { (query: GeoQuery?, error: Error?) in
            
            guard error == nil else {
                let errorVC = UIAlertController(title: "Error", message: "Error from API: \(String(describing: error))", preferredStyle: .alert)
                self.present(errorVC, animated: true, completion: nil)
                return
            }
            
            guard let pages = query?.query else {
                fatalError("no query despite no error")
            }
            
            self.pages = pages
            
            self.pagesStore.store(pages)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let numberOfPages = pages?.pages.count else {
            return 0
        }
        
        return numberOfPages
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell", for: indexPath)
        // Configure the cell...
        
        guard let pages = self.pages else {
            return cell
        }
        
        let page = pages.pages[indexPath.row]
        
        cell.textLabel?.text = page.title
        
        if let detailText = page.terms?.description?.first {
            cell.detailTextLabel?.text = detailText
        }
        
        if let thumbnail = page.thumbnail?.source {
            cell.imageView?.downloaded(from: thumbnail, contentMode: .scaleAspectFit, completion: {
                cell.setNeedsLayout()
            })
        }
        
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let source = segue.source as? ThingsViewController else {
            return
        }
        
        guard let destination = segue.destination as? DetailViewController else {
            return
        }
        
        guard let indexPath = source.tableView.indexPathForSelectedRow else {
            return
        }
        
        let page = source.pages!.pages[indexPath.row]
        destination.page = page
    }

}
