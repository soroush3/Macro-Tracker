//
//  ViewController.swift
//  Macro-Tracker
//
//  Created by Sherwin on 7/13/20.
//  Copyright © 2020 Sherwin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //input textFields
    @IBOutlet weak var calsInputField: UITextField!
    
    @IBOutlet weak var fatInputField: UITextField!
    
    @IBOutlet weak var carbsInputField: UITextField!
    
    @IBOutlet weak var proteinInputField: UITextField!
    
    @IBOutlet weak var foodNameInputField: UITextField!
    
    //output labels
    @IBOutlet weak var calsOutputLabel: UILabel!
    
    @IBOutlet weak var fatOutputLabel: UILabel!
    
    @IBOutlet weak var carbsOutputLabel: UILabel!
    
    @IBOutlet weak var proteinOutputLabel: UILabel!
    
    // table view
    @IBOutlet var tableView : UITableView!
    
    // header above the table
    @IBOutlet var headerView : UIView!
    
    var currDate = "";

    //Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var foodItemArray:[FoodItem]?
    
    func fetchFoodItems() {
        // Fetch the food Items stored via Core Data for the given day
        let request = FoodItem.fetchRequest() as NSFetchRequest<FoodItem>
        
        // Set filtering for the request based on the date
        let pred = NSPredicate(format: "date CONTAINS %@", self.currDate)
        
        request.predicate = pred
        
        self.foodItemArray = try! self.context.fetch(request)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func updateView() {
        if (self.currDate != getDate()) {
            self.currDate = getDate()
            
            self.fetchFoodItems()
            self.updateTotal(date: self.currDate)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // runs updateView function every time app is back in foreground
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateView), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        self.currDate = getDate();
        // make the input fields only allow numeric values
        calsInputField.delegate = self
        fatInputField.delegate = self
        carbsInputField.delegate = self
        proteinInputField.delegate = self
        
        // table view
        tableView.delegate = self
        tableView.dataSource = self
        // adding border to bottom of header for tableview
        headerView.addBottomBorder(color: UIColor.darkGray, width: 1.0)
        // add done button to numericPad textFields
        calsInputField.addDoneButtonOnKeyboard()
        fatInputField.addDoneButtonOnKeyboard()
        carbsInputField.addDoneButtonOnKeyboard()
        proteinInputField.addDoneButtonOnKeyboard()
        foodNameInputField.addDoneButtonOnKeyboard()
        
        // load the current day and display the proper
        // contents of the food based on the day
        self.fetchFoodItems()
        self.updateTotal(date: self.currDate)
        
        
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let allowedCharacters = "1234567890"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        return allowedCharacterSet.isSuperset(of: typedCharacterSet)
    }
    
    func getDate() -> String {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd";

        let date = dateFormatter.string(from: Foundation.Date());
        return date;
    }
    
    func updateTotal(date: String) {
        // takes in a date(key) and calculates the macros
        // for that date(key)
        var cals = 0, carbs = 0, fat = 0, protein = 0
        
        // sum up the values
        for foodItem in self.foodItemArray! {
            cals += Int(foodItem.cals)
            carbs += Int(foodItem.carbs)
            fat += Int(foodItem.fat)
            protein += Int(foodItem.protein)
        }
        // change the labels to the summed values
        calsOutputLabel.text = String(cals);
        fatOutputLabel.text = String(fat) + "g";
        carbsOutputLabel.text = String(carbs) + "g";
        proteinOutputLabel.text = String(protein) + "g";
    }
    
    
    @IBAction func addFoodTap(_ sender: UIButton) {
        //dismiss the keyboard if not already dismissed
        self.view.endEditing(true)

        // foodName needs to be present to add food, alerts user if not
        if (foodNameInputField.text?.replacingOccurrences(of:" ", with: "").count == 0) {
            let alert = UIAlertController(title: "Error", message: "Food items must have a 'Food Name'", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            foodNameInputField.text = ""
            return
        }

        // create food item and assign values
        let newFoodItem = FoodItem(context: self.context)
        // assign the values to the 'FoodItem' struct
        if (calsInputField.text != "") {
            newFoodItem.cals = Int64(calsInputField.text ?? "0")!
        }
        if (fatInputField.text != "") {
            newFoodItem.fat = Int64(fatInputField.text ?? "0")!
        }
        if (carbsInputField.text != "") {
            newFoodItem.carbs = Int64(carbsInputField.text ?? "0")!
        }
        if (proteinInputField.text != "") {
            newFoodItem.protein = Int64(proteinInputField.text ?? "0")!
        }
        if (foodNameInputField.text != "") {
            newFoodItem.foodName = foodNameInputField.text!
        }
        newFoodItem.date = self.currDate
        newFoodItem.identifier = UUID()
        // Save the data
        try! self.context.save()
        
        self.fetchFoodItems()
        // update the labels
        self.updateTotal(date: self.currDate)
        
        // reset the input fields to placeholders
        calsInputField.text = ""
        fatInputField.text = ""
        carbsInputField.text = ""
        proteinInputField.text = ""
        foodNameInputField.text = ""

    }
    
    // table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.foodItemArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let foodCell = tableView.dequeueReusableCell(withIdentifier: "TableViewFoodCell", for: indexPath) as! TableViewFoodCell
        // fill the labels of the custom cell
        foodCell.foodName?.text = self.foodItemArray?[indexPath.row].foodName
        foodCell.calorieLabel?.text = String(self.foodItemArray?[indexPath.row].cals ?? 0)
        foodCell.fatLabel?.text = String(self.foodItemArray?[indexPath.row].fat ?? 0)
        foodCell.carbLabel?.text = String(self.foodItemArray?[indexPath.row].carbs ?? 0)
        foodCell.proteinLabel?.text = String(self.foodItemArray?[indexPath.row].protein ?? 0)

        return foodCell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

            if editingStyle == .delete {
                let foodToRemove = self.foodItemArray![indexPath.row]
                
                self.context.delete(foodToRemove)
                
                try! self.context.save()
                
                self.fetchFoodItems()

                self.updateTotal(date: self.currDate)
            }
        }
}

extension UIView {

    func createBorder(color: UIColor) -> UIView {
        let borderView = UIView(frame: CGRect.zero)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = color
        return borderView
    }

    func addBottomBorder(color: UIColor, width: CGFloat)
    {
        let bottomBorder = createBorder(color: color)
        self.addSubview(bottomBorder)
        NSLayoutConstraint.activate([
            bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: width)
        ])
    }

    func addTopBorder(color: UIColor, width: CGFloat) {
        let topBorderView = createBorder(color: color)
        self.addSubview(topBorderView)
        NSLayoutConstraint.activate([
            topBorderView.topAnchor.constraint(equalTo: self.topAnchor),
            topBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topBorderView.heightAnchor.constraint(equalToConstant: width)
        ])
    }
}
