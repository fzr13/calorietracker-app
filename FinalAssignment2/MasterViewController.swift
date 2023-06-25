//
//  MasterViewController.swift
//  FinalAssignment2
//
//  Created on 6/30/22.
//

import UIKit

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var newFlag = false;
    var objects:[DetailObject] = []
    var newArray: [String] = []
  

   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        objects.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let objectToBeMoved = objects[sourceIndexPath.row]
        objects.remove(at: sourceIndexPath.row)
        objects.insert(objectToBeMoved, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.reloadData();
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = objects[indexPath.row]
        cell.textLabel!.text = object.meal
        cell.detailTextLabel!.text = object.calories

        
        return cell
        
        
    }
    
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let fileURL = dataFileURL()
        print(fileURL)
       
        if (FileManager.default.fileExists(atPath: fileURL.path)) {
            //objects = ((NSArray(contentsOfFile: file.path)) as? [[String:String]])!
                print("found file")
                do {
                    let data = try Data(contentsOf: fileURL)
                    let decoder = JSONDecoder()
                    objects = try decoder.decode(Array<DetailObject>.self, from: data)
                    newArray = objects.compactMap({$0.calories})
                    print(newArray)
                    
                    
                                    
                }
            
                    
                catch{
                    print("error finding file")
                }
        } else {
            print("file not found")
        }
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(notification:)),name: UIApplication.willResignActiveNotification, object: nil)
        
        
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        
        //tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
   
    @IBOutlet weak var totalCalLabel: UILabel!
    
    
    
    @IBAction func calcTotalButton(_ sender: UIButton) {
        
        calc()
    }
    
    
   
    func calc() {
        
        var totalCal: Int = 0
        for items in newArray {
             
            totalCal += (Int(items)!)
             
         }
         
         totalCalLabel.text! = String(totalCal)
         
     
    }
    
    
    
    
    @IBAction func newPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func editPressed(_ sender: UIButton) {
        tableView.isEditing = !tableView.isEditing
        if sender.currentTitle != "Done Editing" {
            sender.setTitle("Done Editing", for: .normal)
        } else  {
            sender.setTitle("Edit", for: .normal)
        }
    }
    override func prepare(for segue:UIStoryboardSegue, sender:Any?) {
        let controller = (segue.destination as! DetailViewController)
        controller.masterViewController = self
        if segue.identifier == "ShowDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                controller.itemIndex = indexPath.row
            }
        } else {
            controller.itemIndex = 0
            let newObject = DetailObject()
            newObject.meal = "New Meal"
            newObject.calories = "0"
            objects.insert(newObject, at:0)
            newFlag = true
            
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
}
