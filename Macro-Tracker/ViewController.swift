//
//  ViewController.swift
//  Macro-Tracker
//
//  Created by Sherwin on 7/13/20.
//  Copyright © 2020 Sherwin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //input textFields
    @IBOutlet weak var calsInputField: UITextField!
    
    @IBOutlet weak var fatInputField: UITextField!
    
    @IBOutlet weak var carbsInputField: UITextField!
    
    @IBOutlet weak var proteinInputField: UITextField!
    
    //output labels
    @IBOutlet weak var calsOutputLabel: UILabel!
    
    @IBOutlet weak var fatOutputLabel: UILabel!
    
    @IBOutlet weak var carbsOutputLabel: UILabel!
    
    @IBOutlet weak var proteinOutputLabel: UILabel!
    
    
    
    
    // struct of a foodItem entity
    struct FoodItem {
        var foodName = "";
        var cals = 0
        var protein = 0;
        var carbs = 0;
        var fat = 0;
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
        // Do any additional setup after loading the view.
        
        // add done button to numericPad textFields
        calsInputField.addDoneButtonOnKeyboard()
        fatInputField.addDoneButtonOnKeyboard()
        carbsInputField.addDoneButtonOnKeyboard()
        proteinInputField.addDoneButtonOnKeyboard()
        // load the current day and display the proper
        // contents of the food based on the day
        updateTotal(date: getDate())
        
        
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = "1234567890"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        return allowedCharacterSet.isSuperset(of: typedCharacterSet)
    }
    
    func getDate() -> String {
        let dateWithTime = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short

        let date = dateFormatter.string(from: dateWithTime)
        
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
        // change the labels to the updates values
        calsOutputLabel.text = String(cals)
        fatOutputLabel.text = String(fat)
        carbsOutputLabel.text = String(carbs)
        proteinOutputLabel.text = String(protein)
        
        
    }
    
    
    @IBAction func addFoodTap(_ sender: UIButton) {
        
        //dismiss the keyboard if not already dismissed
        self.view.endEditing(true)
        
        
        let currDate = getDate();
        // determine if the key is present in hashmap
        // add the key:val to dict if not present
        if (!dateDict.keys.contains(currDate)) {
            dateDict[currDate] = Array<FoodItem>()
        }
        
        var fItem = FoodItem();
        // assign the values to the 'FoodItem' struct
        fItem.cals = Int(calsInputField.text ?? "0")!
        fItem.fat = Int(fatInputField.text ?? "0")!
        fItem.carbs = Int(carbsInputField.text ?? "0")!
        fItem.protein = Int(proteinInputField.text ?? "0")!
        
        //append the item to proper Array in the dateDict
        dateDict[currDate]?.append(fItem)
        // update the labels
        updateTotal(date: currDate)
        
        
        
        
        // reset the input fields to placeholders
        calsInputField.text = ""
        fatInputField.text = ""
        carbsInputField.text = ""
        proteinInputField.text = ""

        
        
    }
    
}

