//
//  DetailViewController.swift
//  ThingsNearby
//
//  Created by Simon Haycock on 2/12/19.
//  Copyright © 2019 Expedia. All rights reserved.
//

import UIKit
import SafariServices
import MapKit

class DetailViewController: UIViewController {
    
    var page: Page?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print("view did load, with page id \(String(describing: page?.pageid))")§
        
        guard let page = self.page else { fatalError("no page set on detail view controller") }
        
        titleLabel.text = page.title
        
        if let imageURL = page.original?.source {
            imageView.downloaded(from: imageURL) {
                self.imageView.backgroundColor = .clear
            }
        }
        
        if let pageCoordinates = page.coordinates.first {
            let coordinates = CLLocationCoordinate2D(latitude: pageCoordinates.lat, longitude: pageCoordinates.lon)
            let annotation = SimpleAnnotation(coordinate: coordinates)
            mapView.addAnnotation(annotation)
            mapView.showAnnotations([annotation], animated: true)
            mapView.delegate = self
        }
    }
    
    @IBAction func openArticle(_ sender: Any) {
        
        // Show web view with image for now
        
        guard let fullURLString = page?.fullurl else { return }
        
        let url = URL(string: fullURLString)!
        
        let webViewController = SFSafariViewController(url: url)
        webViewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(webViewController, animated: true, completion: nil)
    }
    
    @IBAction func visitedToggled(_ sender: Any) {
        guard let visitedSwitch = sender as? UISwitch else { fatalError("sender is not a switch!") }
        if visitedSwitch.isOn {
            // modify storage to reflect switch being set to on
        } else {
            // modify storage to reflect switch being set to off
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return MKPinAnnotationView()
    }
}

private class SimpleAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
