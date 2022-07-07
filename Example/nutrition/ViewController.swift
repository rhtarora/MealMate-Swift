//
//  ViewController.swift
//  cp
//
//  Created by upworktinesh on 05/16/2022.
//  Copyright (c) 2022 upworktinesh. All rights reserved.

import UIKit
import nutrition
import SwiftyJSON

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var enteredText: UILabel!
    @IBOutlet var MealId: UILabel!
    @IBOutlet var tagsList: UILabel!
    @IBOutlet var TF: UITextField!
    @IBOutlet var logId: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var mealType: UISegmentedControl!

    // MARK: - Properties
    let meals: [MealType]    = [.Breakfast, .Lunch, .Snacks, .Dinner]
    var selectedMeal: MealType      = .Lunch
    var tags: [Tags]        = [Tags]()
    var cp: Nutrition     = Nutrition.shared
    var tagJson: [JSON]        = [JSON.null]
    var date: Date          = Date()
    var tagged_food_data = [String]()

    var mealsHistory: [[String: Any]] = [[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserId()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Send Request and Process Food API Call
    @IBAction func btnACtion(_ sender: Any) {
        UserDefaults.standard.set("91685CDE-7263-4756-BA31-73164FF0147A", forKey: "userID")
//        cp.UserID = "91685CDE-7263-4756-BA31-73164FF0147A"
//        self.TF.text = "1 mango, 2 bananas"
        if let text = self.TF.text, text != "" {
            self.enteredText.text = self.TF.text
            self.TF.placeholder = "Enter your diet and press send button"
            cp.textEntry = self.enteredText.text
            cp.mealtype = getMealType()
            getTags()
//            getMealID()
        } else {
            let alert = UIAlertController(title: "Error", message: "Please Enter the Meal you had. Textfield can't be empty.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true)
        }
    }

    // MARK: - Select Date Action
    @IBAction func DateSelection(_ sender: UIDatePicker) {
        print("print \(sender.date)")
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, YYYY"
        dateFormatter.locale = Locale.current
        self.date = sender.date
    }

    @IBAction func showHistory(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "HistoryVC") as? HistoryVC else {
            return
        }
//        vc.tableData = self.mealsHistory
        vc.id = cp.UserID!
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Get User ID from Local or Add New User API Call
    func getUserId() {
        if let id = UserDefaults.standard.value(forKey: "userID") as? String, id != "" {
            cp.UserID = id
            getMealsHistory(id)
        } else {
            cp.APIManager.GetUserIdByAddingNewUser(name: "test", email: "test@yopmail.com", date: self.date ) { success, _ in
                guard let id = success else {
                    return
                }
                self.cp.UserID = id
            }
        }
    }

    // MARK: - Get Meal Histories API Call
    func getMealsHistory(_ id: String) {
        cp.APIManager.GetMealsHistory(by: id) { [self] success, _ in
            guard let responseJson = success else { return }
            print(responseJson)
            self.mealsHistory = responseJson
        }
    }

    // MARK: - Get Meal Type from selected Segmented Control
    func getMealType() -> MealType {
        switch self.mealType.selectedSegmentIndex {
        case 0: return .Breakfast
        case 1: return .Lunch
        case 2: return .Snacks
        case 3: return .Dinner
        default: return .Breakfast
        }
    }

    // MARK: - Get Tags API Call
    func getTags() {
        cp.APIManager.GetTags(for: self.TF.text!) { [self] success, error in
            guard let json = success else {
                print(error as Any)
                return
            }
            print("Response json:", json)
            gettagss(json: json)
        }
    }

    // MARK: - Get MealId API Call
    func getMealID() {
        cp.APIManager.GetMealID(category: cp.mealtype!, rawText: self.TF.text!, date: self.date ) { [self] success, error in
            self.MealId.text = "\(String(describing: success.0!))"
            self.logId.text = "\(String(describing: success.1!))"
            print("Meal ID: \(String(describing: success.0))")
            print("Log ID: \(String(describing: success.1))")

            cp.APIManager.ProcessData(mealId: (success.0?.toString())!, logID: (success.1?.toString())!, rawText: self.tagged_food_data[0], origText: self.TF.text!, user_id: cp.UserID!, already_tagged: "1") { reponse, error in
                guard let reponse = reponse else {
                    print(error as Any)
                    return
                }
            }
        }
    }

    // MARK: - Get Tags to show from Get Tags API
    func gettagss(json: [JSON]) {
        var tg  = ""
        self.tagged_food_data = self.processTags(json)
        json.forEach { j in
            tg += "\(j["Quant"][0]) \(j["Food"][0]),"
        }
        self.tagsList.text = tg
        print(json)

        self.getMealID()
    }
    

    func processTags(_ foodList: [JSON]) -> [String] {
        var res = "Got it! You had:"
        var quant_array = [NSRange]()
        var food_array = [NSRange]()
        var tagged_foods_quants = ""
        var numFoods = 0
        for (index, food) in foodList.enumerated() {
            var quant_string = ""
            var food_string = ""
            if food["Quant"].count > 0 {
                res += "\n"+String(index+1)+")"
                for item in food["Quant"] {
                    let token = item.1
                    quant_string += " " + String(describing: token)
                }
                res += quant_string
                let quant_range = (res as NSString).range(of: quant_string)
                quant_array.append(quant_range)
            }

            for item in food["Other"] {
                let token = item.1
                res += " " + String(describing: token)
            }

            if food["Food"].count > 0 {
                numFoods += 1
                if food["Quant"].count == 0 {
                    res += "\n"+String(index+1)+")"
                }
                for item in food["Food"] {
                    let token = item.1
                    food_string += " " + String(describing: token)
                }
                res += food_string
                let food_range = (res as NSString).range(of: food_string)
                food_array.append(food_range)
            }

            // separate foods by | symbol, and foods and quants by tabs
            if tagged_foods_quants.characters.count > 0 {
                tagged_foods_quants += "|"
            }
            tagged_foods_quants += food_string+"\t"+quant_string

        }
        res += "\n\nLet me check the database..."
        // add colors for every quant and food string
        return [tagged_foods_quants, res, String(describing: numFoods)]
    }

}

extension Int {
    func toString() -> String {
        return "\(self)"
    }
}
