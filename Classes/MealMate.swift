//
//  MealMate.swift
//  MealMate-Swift
//
//  Created by Macintosh on 19/05/22.
//



import Foundation
import SwiftyJSON


public class Nutrition {
    
    /// `Nutrition` Properties
    public static let shared    = Nutrition()
    
    ///`textEntry` this String property is used to pass the processing meal Data.
    public var textEntry        : String?
    
    /// `UserID` this is the current user's id. which is used to track the meal history of that user.
    public var UserID           : String?
    
    /// `mealType` this property is used to specify the type of the meal
    /// e.g. 'mealType.Lunch'
    /// or for short you can use only '.Lunch'.
    public var mealtype         : MealType?
    
    public let APIManager       = NetworkManager.shared
    //
    
    
}

class User {
    
    public var name        : String?
    public var email        : String?
    
}
