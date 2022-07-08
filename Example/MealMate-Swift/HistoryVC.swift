//
//  HistoryVC.swift
//  nutrition_Example
//
//  Created by Macintosh on 02/06/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import MealMate_Swift
import SwiftyJSON

class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var historyTable: UITableView!
    var tableData: [[String: Any]]?
    var id = ""
    let cp = Nutrition.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tableData?.count == 0 {
            self.getMealsHistory("65EBB3C9-2CD1-46A0-90BE-B35EFE4E3625")
            self.historyTable.reloadData()
        }
        self.historyTable.reloadData()
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.getMealsHistory("id")
    }
    // MARK: - Get Meal Histories API Call
    func getMealsHistory(_ id: String){
        print("Calling get History")
        cp.APIManager.GetMealsHistory(by: "91685CDE-7263-4756-BA31-73164FF0147A") { [self] success, _ in
            guard let responseJson = success else { return }
            print(responseJson)
//            self.mealsHistory = responseJson
            print("Meal History Data :", responseJson)
            self.tableData = responseJson
            self.historyTable.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else {
            return UITableViewCell.init()
        }
        let data = tableData![indexPath.row]
        cell.mealId.text = "\((data )["mealId"]!)"
        
        let jsonData = JSON(data).dictionary!
//        let details = JSON(data).dictionary!["data"]
        let details = JSON(jsonData["data"] as Any).dictionary!
        let date = JSON(details["date"] as Any).stringValue
        cell.time.text = "\( getDate(from: date))"
        cell.category.text = JSON(details["category"] as Any).stringValue
        var foodItem =  ""
        JSON(details["foods"] as Any).array?.forEach({ item in
            let itemJSON = JSON(item).dictionary!
            foodItem += JSON(itemJSON["foodText"]!).stringValue + " "
        })
        cell.foodItems.text = foodItem
        return cell
    }
    
    func getDate(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        //        6_2_2022_16_7
        dateFormatter.dateFormat = "MM'_'dd'_'yyyy'_'HH'_'mm'"
        if let date = dateFormatter.date(from: dateString) {

            var calendar = Calendar.current

            if let timeZone = TimeZone(identifier: "EST") {
                calendar.timeZone = timeZone
            }

            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            let second = calendar.component(.second, from: date)

            print("\(hour):\(minute):\(second)")

            let timeString = "\(hour) : \(minute)"
            return timeString
        } else {
            return ""
        }
    }
}
