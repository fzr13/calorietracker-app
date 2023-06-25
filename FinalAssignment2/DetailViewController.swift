//
//  DetailViewController.swift
//  FinalAssignment2
//
//  Created on 6/30/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    var objects:[DetailObject] = []
    var addCal:Int = 0
    var masterViewController: MasterViewController!
    var itemIndex = 0
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mealTextField.text = masterViewController.objects[itemIndex].meal
        calorieLabel.text = masterViewController.objects[itemIndex].calories
        
        
    }
    
    
    
    
    @IBAction func savedPressed(_ sender: Any) {
        masterViewController.objects[itemIndex].meal = mealTextField.text!
        masterViewController.objects[itemIndex].calories = calorieLabel.text!
        
        
        newJson()
        masterViewController.tableView.reloadData()
        
        
        
        
        
    }
    
    
    
    
    
    
    func newJson(){
        
        let fileURL = dataFileURL()
        print(fileURL)
       
        if (FileManager.default.fileExists(atPath: fileURL.path)) {
            //objects = ((NSArray(contentsOfFile: file.path)) as? [[String:String]])!
                print("found file")
                do {
                    let data = try Data(contentsOf: fileURL)
                    let decoder = JSONDecoder()
                    objects = try decoder.decode(Array<DetailObject>.self, from: data)
                   // newArray = objects.compactMap({$0.calories})
                    //print(newArray)
                    print(objects)
                    
                    
                                    
                }
            
                    
                catch{
                    print("error finding file")
                }
        } else {
            print("file not found")
        }
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(notification:)),name: UIApplication.willResignActiveNotification, object: nil)
        
        
    }
   
    
    
    @IBOutlet weak var mealTextField: UITextField!
    
    
    @IBOutlet weak var calorieLabel: UILabel!
    
    
   
    
    @IBAction func calorieSlider(_ sender: UISlider) {
        addCal = Int((sender.value))
       
         
         calorieLabel.text = String(Int(sender.value))
        
        
    }
    
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        if masterViewController.newFlag {
        masterViewController.objects.remove(at: itemIndex)
        masterViewController.tableView.reloadData()
            masterViewController.newFlag = false
        }
    }
    
    func dataFileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var url:URL?
        url = URL(fileURLWithPath: "")
        url = urls.first!.appendingPathComponent("data.json")
        return url!
    }
    
    @objc func applicationWillResignActive(notification:NSNotification){
       let fileURL = self.dataFileURL()
        //let array = (self.objects as NSArray)
        //array.write(to: fileURL as URL, atomically: true)
        print("data saved")
        
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self.objects) {
            do { try data.write(to: fileURL)
            print("Wrote data using coding")
            
            
        }
        catch{
            print("error wiritng to data file")
        }
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
