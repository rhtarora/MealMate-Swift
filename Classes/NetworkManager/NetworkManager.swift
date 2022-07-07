//
//  NetworkManager..swift
//  cp_Example
//
//  Created by Macintosh on 16/05/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreImage


public class NetworkManager {
    static let shared = NetworkManager()
    /// `BASE URL`
    private let BASE_URL = "https://fuzzy-wuzzy.csail.mit.edu/Coco/coco/api/v1.0/"
    /// `Get Tags` endpoint
    private let getTags = "get_tags?raw_text="
    /// `Get Meal Id` endpoint
    private let NewMeal = "new_meal?"
    /// ``
    private let addUser = "add_user?"
    /// ``
    private let GetHistory = "get_meals?"
    let userID = "91685CDE-7263-4756BA31-73164FF0147A"
    
    
    //    MARK:- Add New User and Get UserId
    public func GetUserIdByAddingNewUser(name:String, email:String,date:Date, Completion: @escaping(_ success:String?, _ error: Error?)->()){
        let query = "user_id="+self.userID+"&name="+name+"&email="+email+"&date="+Helper.shared.getDate(date: date)
        let urlWithParameter = self.BASE_URL+self.addUser+query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        print("GetUserIdByAddingNewUser :",urlWithParameter)
        Alamofire.request(urlWithParameter,method: .get,parameters: nil,encoding: URLEncoding.default,headers: nil)
            .validate()
            .responseJSON { response in
                print(response)
                if response.result.isSuccess{
                    let userID = ((JSON(response.result.value as Any).object as AnyObject).value(forKey:"userid")!)
                    print(userID)
                    
                    UserDefaults.standard.setValue(userID, forKey: "userID")
                    Completion((userID as! String),nil)
                }else{
                    Completion(nil,response.result.error)
                }
            }
    }
    
    public func GetMealsHistory(by id: String,Completion:@escaping(_ success: [[String:Any]]?,_ error : Error?)->()) {
        let urlWithParameter = BASE_URL+self.GetHistory+"user_id="+self.userID.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        print("get Meal History : ",urlWithParameter)
        Alamofire.request(urlWithParameter, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON { response in
                print("History Response",response)
                if response.result.isSuccess{
                    do{
//                        let jsonData = try JSON(response.result.value!).rawData(options: [])
//                        let mealHistory = try? JSONDecoder().decode(Dictionary<String,MealHistoryValue>.self, from: jsonData)
                        var data = [[String:Any]]()
//                        mealHistory?.forEach { (key: String, value: MealHistoryValue) in
//                            data.append([
//                                "mealId":key,
//                                "data": value,
//                            ])
//                        }
                        JSON(response.result.value!).dictionary?.forEach({ (key: String, value: JSON) in
                            print("key,",key,"\nValue",value)
                            data.append([
                                "mealId":key,
                                "data": value,
                            ])
                        })
                        print("History after Processing",data)
                        Completion(data,nil)
                    }catch let error{
                        Completion(nil,error)
                    }
                }else{
                    print(response.result.error as Any)
                    Completion(nil,response.result.error)
                }
                
            }
    }
    
    
    //    MARK:- Get Tags API
    public func GetTags(for RawText: String,Completion:@escaping(_ success:[JSON]?,_ error: Error?)->()){
        let urlWithParameters = self.BASE_URL+self.getTags+RawText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        Alamofire.request(urlWithParameters, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON { response in
                if response.result.isSuccess{
                    let foodList = JSON(response.result.value!).array!
                    Completion(foodList, nil)
                    return
                }else{
                    Completion(nil, response.result.error)
                }
            }
    }
    
    //    MARK:- Get MealID API
    public func GetMealID(category:MealType,rawText:String, date: Date,Completion:@escaping(_ success:(Int?,Int?),_ error: Error?)->()){
        let dateString :String = Helper.shared.getDate(date: date).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let query = "user_id=" + self.userID + "&date=" + dateString + "&category=" + category.rawValue
        let urlWithParameter  = self.BASE_URL+self.NewMeal + query
        print("Get MealId")
        print("url withParamerter :",urlWithParameter)
        Alamofire.request(urlWithParameter, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON(completionHandler: { response in
                print("Get MealId Response :",response)
                if response.result.isSuccess {
                    let newID = JSON(response.result.value!)["mealID"].int!
                    self.getLogID(for: "\(newID)", rawText: rawText, user_ID: "91685CDE-7263-4756-BA31-73164FF0147A", date: Date()) { success, error in
                        guard let logId = success else {
                            return
                        }
                        
                        Completion((newID, logId), nil)
                    }
                }else{
                    Completion((nil,nil),response.result.error)
                }
                
            })
    }
    
    //    MARK:- Get Log ID
    func getLogID(for mealID: String,rawText:String,user_ID:String?,date:Date,Completion:@escaping(_ success:Int?,_ error: Error?)->()){
        let date : String = Helper.shared.getDate(date: date).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let queries =  "\(mealID)&raw_text=\(rawText)&user_id=\(self.userID)&date=\(date)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlWithParameters = self.BASE_URL + "new_log?meal_id=" + queries!
        print("Get Log ID urlWithParameters : ",urlWithParameters)
        // get new meal ID
        Alamofire.request(urlWithParameters, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON(completionHandler: { response in
                print("Get LogId Response :",response)
                if response.result.isSuccess {
                    print("successfully added new log")
                    let logID = JSON(response.result.value!)["logID"].int!
                    print(logID)
                    Completion(logID,nil)
                } else {
                    Completion(nil,response.result.error)
                    return
                }
            })
    }
    
    public func ProcessData(mealId: String,logID:String,rawText:String,origText:String,user_id:String,already_tagged:String ,Completion:@escaping(_ reponse:JSON?,_ error:Error?)->()){
        let query = "log_id=\(logID)&raw_text=\(rawText)&user_id=\(user_id)&already_tagged=\(already_tagged)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = "https://fuzzy-wuzzy.csail.mit.edu/Coco/coco/api/v1.0/query?"
        let urlWithParameters = url+query!
        print("process Data URl :",urlWithParameters)
        Alamofire.request(urlWithParameters, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON { response in
                if response.result.isSuccess {
                    let swiftyJSON = JSON(response.result.value!)
                    self.getFoodFromJsonToAddNew(processedJson: swiftyJSON,mealId:mealId,logId:logID)
                    Completion(swiftyJSON,nil)
                }else{
                    Completion(nil,response.result.error)
                }
            }
        
    }
    
    
    func getFoodFromJsonToAddNew(processedJson:JSON,mealId:String,logId:String){
        let allData = processedJson.array
        var n = 0.0
        allData?.forEach({ singeleItem in
            print(singeleItem)
            let dic = singeleItem.dictionary
            let hits = dic!["hits"]?.array!
            let meal_id = mealId
            let log_id = logId
            let orig_food_id = hits![0][0].string
            let orig_quant = hits![0][1].string
            let orig_num = n
            n += 1
            //Date
            _ = Helper.shared.getDate(date: Date())
            let foodText = dic!["foodText"]!.string
            let quantText = dic!["quantityText"]!.string
//            userID
            _ = Nutrition.shared.UserID
            let unitArray = dic!["units"]?.array
//            var top_n = ""
//            unitArray!.forEach({ item in
//                let dic = item.dictionary
//                dic?.forEach({(key: String, value: JSON) in
////                    print("Key is:",key,"value is: ",value)
//                    top_n += key
//                    top_n +=  "|"
//                })
//            })
//            let q1 = "meal_id="+mealId+"&log_id="+logId
//            let q2 = "&orig_food_id="+orig_food_id!
//            let q3 = "&orig_quant="+orig_quant!+"&orig_num="+"\(orig_num)"
//            let q4 = "&date="+date+"&foodText="+foodText!
//            let q5 = "&quantText="+quantText!+"&user_id="+userID!+"&top_n="+top_n
//            let query = q1 + q2 + q3 + q4 + q5
            
//            self.addNewFood(query: query)
            self.addNewF(mealId: meal_id, logID: log_id, id: orig_food_id!, unit: orig_quant!, quantity: "\(orig_num)", rowNum: "1", foodText: foodText!, quantText: quantText!, unitArray: unitArray!)
                
        })

    }
    
    public func addNewF(mealId:String,logID:String,id:String,unit:String,quantity:String,rowNum:String,foodText:String,quantText:String,unitArray:[JSON]){
        
        let primaryURL: String = self.BASE_URL+"new_food?"// LanaAPI.shared.host + "/coco/api/v1.0/new_food?"
        let mealIDParam: String = "meal_id=" + mealId
        let logIDParam: String = "&log_id=" + logID
        let foodIDParam: String = "&orig_food_id=" + id
        let quantParam: String = "&orig_quant=" + unit.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let numParam: String = "&orig_num=" + quantity
        let rowParam: String = "&row=" + rowNum
        let dateParam: String =  "&date=" + String(Helper.shared.getDate(date: Date())).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let foodTextParam: String = "&foodText=" + foodText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let quantTextParam: String = "&quantText=" + quantText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let userIDParam: String = "&user_id=" + self.userID
        var alternates: String = ""
//        var alternates = ""
        let arr = JSON(unitArray).array!
        for item in arr {
            if item.count > 0 {
                alternates += "|"
            }
            let i = JSON(item).dictionary!.keys
            alternates += "\(i)"
        }
        let params = mealIDParam + logIDParam + foodIDParam + quantParam + numParam + rowParam + dateParam + foodTextParam + quantTextParam + userIDParam + "&top_n=" + alternates.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlWithParameters = primaryURL + params
        
        print("addNewFood urlWithParameters: ",urlWithParameters)
        // add new food
        Alamofire.request(urlWithParameters, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON(completionHandler: { response in
                if response.result.isSuccess {
                    /*print("added new food")
                     print(item.id)
                     print(item.title)
                     print(rowNum)*/
                }
            })
    }

    
    public func addNewFood(query:String){
        let urlWithParameters = self.BASE_URL+"new_food?"+query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        print("Add New Food params : ",urlWithParameters)
        Alamofire.request(urlWithParameters, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON { response in
//                print("Add New Food Response: ",response)
                if let status = response.response?.statusCode {
                    if status == 200 {
                        print("Food added successfully.")
                    }else{
                        print("Add food failed with Status Code :",status)
                    }
                }
            }
    }
    
    
    
    
}


class Helper {
    static let shared = Helper()
    public var uuid = UUID().uuidString
    func getDate(date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let year = calendar.component(.year, from: date)
        let dateString = String(month)+"_"+String(day)+"_"+String(year)+"_"+String(hour)+"_"+String(minutes)
        return dateString
    }
}

