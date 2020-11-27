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
    
    
    // struct of a foodItem entity
    struct FoodItem {
        var foodName = "";
        var cals = 0
        var protein = 0;
        var carbs = 0;
        var fat = 0;
        var date = ""
        var identifier = UUID().uuidString
    }

    // dictionary of dates : array of food for that day
    var dateDict: [String: Array<FoodItem>] = [:];

    override func viewDidLoad() {
        super.viewDidLoad()
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
        updateTotal(date: getDate())
        
        
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
        
        if (!dateDict.keys.contains(date)) {return}
        
        // sum up the values
        for foodItem in dateDict[date]! {
            cals += foodItem.cals
            carbs += foodItem.carbs
            fat += foodItem.fat
            protein += foodItem.protein
        }
        // change the labels to the summed values
        calsOutputLabel.text = String(cals);
        fatOutputLabel.text = String(fat) + "g";
        carbsOutputLabel.text = String(carbs) + "g";
        proteinOutputLabel.text = String(protein) + "g";
    }
    
    
    @IBAction func addFoodTap(_ sender: UIButton) {
        let currDate = getDate();
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

        // determine if the key is present in hashmap
        // add the key:val to dict if not present
        if (!dateDict.keys.contains(currDate)) {
            dateDict[currDate] = Array<FoodItem>()
        }
        // create food item and assign values
        var fItem = FoodItem();
        fItem.date = currDate
        // assign the values to the 'FoodItem' struct
        if (calsInputField.text != "") {
            fItem.cals = Int(calsInputField.text ?? "0")!
        }
        if (fatInputField.text != "") {
            fItem.fat = Int(fatInputField.text ?? "0")!
        }
        if (carbsInputField.text != "") {
            fItem.carbs = Int(carbsInputField.text ?? "0")!
        }
        if (proteinInputField.text != "") {
            fItem.protein = Int(proteinInputField.text ?? "0")!
        }
        if (foodNameInputField.text != "") {
            fItem.foodName = foodNameInputField.text!
        }
        //append the item to proper Array in the dateDict
        dateDict[currDate]?.append(fItem)
        // update the labels
        updateTotal(date: currDate)

        self.tableView.reloadData()
        
        // reset the input fields to placeholders
        calsInputField.text = ""
        fatInputField.text = ""
        carbsInputField.text = ""
        proteinInputField.text = ""
        foodNameInputField.text = ""

    }
    
    // table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dateDict[getDate()]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let foodCell = tableView.dequeueReusableCell(withIdentifier: "TableViewFoodCell", for: indexPath) as! TableViewFoodCell
        // fill the labels of the custom cell
        let currDate = getDate()
        foodCell.foodName?.text = dateDict[currDate]?[indexPath.row].foodName
        foodCell.calorieLabel?.text = String(dateDict[currDate]?[indexPath.row].cals ?? 0)
        foodCell.fatLabel?.text = String(dateDict[currDate]?[indexPath.row].fat ?? 0)
        foodCell.carbLabel?.text = String(dateDict[currDate]?[indexPath.row].carbs ?? 0)
        foodCell.proteinLabel?.text = String(dateDict[currDate]?[indexPath.row].protein ?? 0)

        return foodCell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

            if editingStyle == .delete {
                // remove the item from the data model (date dictionary)
                dateDict[getDate()]?.remove(at: indexPath.row)
                // delete the table view row
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                updateTotal(date: getDate())
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
