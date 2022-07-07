//
//  LogID.swift
//  cp_Example
//
//  Created by Macintosh on 18/05/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//



import Foundation

// MARK: - Tag
public struct Tag: Codable {
    let quant, food, other: [String]
    
    enum CodingKeys: String, CodingKey {
        case quant = "Quant"
        case food = "Food"
        case other = "Other"
    }
}

public typealias Tags = [Tag]



// MARK: - LogID
struct LogID: Codable {
    let logID: Int
}


// MARK: - MealID
struct MealIDModel: Codable {
    let mealID: Int
}
