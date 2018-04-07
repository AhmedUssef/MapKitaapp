//
//  ViewController.swift
//  Mapkitapp
//
//  Created by Ahmed on 4/2/18.
//  Copyright © 2018 Ahmed. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData
class ViewController: UIViewController , MKMapViewDelegate ,CLLocationManagerDelegate{

    @IBOutlet weak var Mymapview: MKMapView!
    
    @IBOutlet weak var nametext: UITextField!
    @IBOutlet weak var commenttext: UITextField!
    
    
    var locationmanger = CLLocationManager()
    
    var Latitude:Double = 0
    var Longtude:Double = 0
    var transmittedtitle = ""
    var transmittedsubtitle = ""
    var transmittedlat:Double = 0
    var transmittedlon:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       Mymapview.delegate = self
        locationmanger.delegate = self
        locationmanger.desiredAccuracy = kCLLocationAccuracyBest
        locationmanger.requestWhenInUseAuthorization()
        locationmanger.startUpdatingLocation()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.choosingLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 2
        self.Mymapview.addGestureRecognizer(gestureRecognizer)
        
        if transmittedtitle != nil {
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude:transmittedlat , longitude: transmittedlon)
            annotation.coordinate = coordinate
            annotation.title = self.transmittedtitle
            annotation.subtitle = self.transmittedsubtitle
            self.Mymapview.addAnnotation(annotation)
            self.nametext.text = self.transmittedtitle
            self.commenttext.text = self.transmittedsubtitle
            
            
        }
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.Mymapview.setRegion(region, animated: true)
    }
    
    @objc func choosingLocation(gestureRecognizer:UILongPressGestureRecognizer)
    {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began{
            let Touchedpoint = gestureRecognizer.location(in: self.Mymapview)
            let Choosencordinate = self.Mymapview.convert(Touchedpoint, toCoordinateFrom: self.Mymapview)
            
            self.Latitude = Choosencordinate.latitude
            self.Longtude = Choosencordinate.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = Choosencordinate
            annotation.title = nametext.text
            annotation.subtitle = commenttext.text
            self.Mymapview.addAnnotation(annotation)
            
        }
    }
    
    @IBAction func Save(_ sender: Any) {
        
        let location = NSEntityDescription.insertNewObject(forEntityName: "Locations", into: Context)
        location.setValue(nametext.text!, forKey: "title")
        location.setValue(commenttext.text!, forKey: "subtitle")
        location.setValue(Latitude, forKey: "lat")
        location.setValue(Longtude, forKey: "lon")
        
        do{
            try Context.save()
            
        }catch{
            
        }
        
    }
    


}
