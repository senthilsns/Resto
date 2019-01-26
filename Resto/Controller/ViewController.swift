//
//  ViewController.swift
//  Resto
//
//  Created by SENTHILKUMAR on 19/01/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import GoogleMaps


class ViewController: UIViewController,UITextFieldDelegate {
  
    @IBOutlet var longitudeField: UITextField!
    @IBOutlet var latitudeField: UITextField!
    @IBOutlet var baseView: UIView!
    @IBOutlet var mapView: GMSMapView!
    
    @IBOutlet var findButton: UIButton!
    @IBAction func findAction(_ sender: Any) {
        
        if latitudeField.text == "" || longitudeField.text == "" {
            
        AlertManager.SharedInstance.showAlert(alertTitle: "Latitude & Logitude Field Empty", alertMessage: nil, alertButtonTitle: "OK")
            
        }else {
            
            let coordinates = InputModel(latitude: latitudeField.text!, longitude: longitudeField.text!)
            findNearerRestaurent(Latitude:coordinates.latitude!, Longitude:coordinates.longitude!, Radious: 500)
            
        }
        
        
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        findButton.setTitle("Search", for: .normal)
        //findNearerRestaurent(Latitude: 34.34511, Longitude: 54.34535, Radious: 500)

        
        findNearerRestaurent()
        
    }
    
   func clearTextField() {
    DispatchQueue.main.async {
    self.latitudeField.text = ""
    self.longitudeField.text = ""
     }
    }
    
    func findNearerRestaurent(Latitude:String,Longitude:String,Radious:Int) {
        
        if  NetworkManager.SharedInstance.isNetworkReachable() == false {
            
            AlertManager.SharedInstance.internetAlert()
            
        }else {

            let urlString :String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(Latitude),\(Longitude)&radius=\(Radious)&rankby=prominence&sensor=true&types=restaurant&key=\(Google_MapKey)"

            guard let url = URL(string: urlString) else {return}
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let dataResponse = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        self.clearTextField()
                        return }
                
                do{
                    
                    self.clearTextField()
                    //here dataResponse received from a network request
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        dataResponse, options: []) as AnyObject
                    
                    print(jsonResponse)
                    
//                    guard let name = jsonResponse["name"] as? String else { return }
//                    guard let gender = jsonResponse["gender"] as? String else { return }
//                    guard let born = jsonResponse["born"] as? String else { return }
//                    guard let culture = jsonResponse["culture"] as? String else { return }
//                    guard let father = jsonResponse["father"] as? String else { return }
//                    guard let mother = jsonResponse["mother"] as? String else { return }
//                    guard let titles = jsonResponse["titles"] as? [String] else { return }
//                    guard let aliases = jsonResponse["aliases"] as? [String] else { return }
//                    guard let died = jsonResponse["died"] as? String else { return }
//                    guard let playedBy = jsonResponse["playedBy"] as? [String] else { return }
//
//                    let detail = DetailModel(name: name, gender: gender, culture: culture, born: born, died: died, titles: titles, aliases: aliases, father: father, mother: mother, playedBy: playedBy)
//                    self.characterDetailList.append(detail)
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
            }
            
            task.resume()
            
        }
        
    }
    
    
    
    func findNearerRestaurent() {
        
        let camera = GMSCameraPosition.camera(withLatitude:12.9592, longitude: 77.6974, zoom: 8.0)
        mapView = GMSMapView.map(withFrame:CGRect(x: 0, y: 0, width:self.view.frame.width, height: self.view.frame.height - 100), camera: camera)
        mapView.mapType = .normal
        mapView.animate(toZoom: 8)
        self.view.addSubview(baseView)
        self.baseView.addSubview(mapView)
        
        
        //12.9592  77.6974
        var latArr :[Double] = [12.9592,12.3434,12.3434,13.4545]
        var longArr :[Double] = [77.6974,76.2344,76.34543,78.6934]

        for i in 0 ... latArr.count-1 {
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: latArr[i], longitude: longArr[i])
            marker.title = "Sydney"
            marker.snippet = "Australia"
            marker.icon = UIImage(named: "pin")
            marker.map = mapView
            
        }
        
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 12.9592, longitude: 77.6974)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.icon = UIImage(named: "pin")
//        marker.map = mapView
    }
    
    
    
    
    
    
    
    //MARK: TextField Delegate
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    

}





