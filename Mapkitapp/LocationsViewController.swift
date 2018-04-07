//
//  LocationsViewController.swift
//  Mapkitapp
//
//  Created by Ahmed on 4/2/18.
//  Copyright © 2018 Ahmed. All rights reserved.
//

import UIKit
import CoreData
class LocationsViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mytableview: UITableView!
    
    var titleArr = [String]()
    var subtitleArr = [String]()
    var latArr = [Double]()
    var longArr = [Double]()
    
    var chosentitle = ""
    var chosensubtitle = ""
    var chosenlat:Double = 0
    var chosenlong:Double = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mytableview.delegate = self
        mytableview.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FetchFromCoredata()
    }
    
    func FetchFromCoredata(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Locations")
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try Context.fetch(request)
            if results.count > 0{
                
                self.titleArr.removeAll(keepingCapacity: false)
                self.subtitleArr.removeAll(keepingCapacity: false)
                self.longArr.removeAll(keepingCapacity: false)
                self.latArr.removeAll(keepingCapacity: false)
                
                for result in results as! [NSManagedObject]
                {
                    if let title = result.value(forKey: "title") as? String
                    {
                        self.titleArr.append(title)
                    }
                    
                    if let subtitle = result.value(forKey: "subtitle") as? String
                    {
                        self.subtitleArr.append(subtitle)
                    }
                    if let latit = result.value(forKey: "lat") as? Double
                    {
                        self.latArr.append(latit)
                    }
                    if let long = result.value(forKey: "lon") as? Double
                    {
                        self.longArr.append(long)
                    }
                    self.mytableview.reloadData()
                    

                    
                }
             
            }
            
        }catch{
            print("error")
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        chosentitle = titleArr[indexPath.row]
        chosensubtitle = subtitleArr[indexPath.row]
        chosenlat = latArr[indexPath.row]
        chosenlong = longArr[indexPath.row]
        performSegue(withIdentifier: "go", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go" {
            
            let destination = segue.destination as! ViewController
            destination.transmittedtitle = chosentitle
            destination.transmittedsubtitle = chosensubtitle
            destination.transmittedlat = chosenlat
            destination.transmittedlon = chosenlong
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = titleArr[indexPath.row]
        
        return cell
        
        
        
        
    }
    

    var bo:Bool=false
    @IBAction func add(_ sender: Any) {
        bo = true
    }
    
  
}
