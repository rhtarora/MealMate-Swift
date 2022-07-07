//
//  ProcessResponseModel.swift
//  cp_Example
//
//  Created by Macintosh on 18/05/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let processResponseModel = try? newJSONDecoder().decode(ProcessResponseModel.self, from: jsonData)

import Foundation

// MARK: - ProcessResponse
public struct ProcessResponse: Codable {
    let quantity, quantityText, foodText: String
    let hits: [[String]]
    let units: [[String: [Unit]]]
    let nutrition100_Gram: [Nutrition100_Gram]
    let logID: Int
    let funMessage: String
    
    enum CodingKeys: String, CodingKey {
        case quantity, quantityText, foodText, hits, units
        case nutrition100_Gram = "nutrition_100_gram"
        case logID = "log_id"
        case funMessage = "fun_message"
    }
}

// MARK: - Nutrition100_Gram
public struct Nutrition100_Gram: Codable {
    let ironMg: Double
    let vitaminB12Mcg: Int
    let shortDesc: String
    let seleniumMcg, cholesterolMg, magnesiumMg, vitaminDMcg: Int
    let units: String
    let vitaminCMg: Int
    let totalSugarG: Double
    let phosphorusMg: Int
    let vitaminEMg: Double
    let kcal: Int
    let thiaminMg: Double
    let omega3_FattyAcidsG, potassiumMg, vitaminKMcg: Int
    let proteinG, riboflavinMg: Double
    let descProc: String
    let sodiumMg: Int
    let totalSatFatG, totalFatG, niacinMg: Double
    let brand: Brand
    let zincMg, totalMonounsatFatG, totalCarbG: Double
    let pantothenicAcidMg: Int
    let barcode: String
    let copperMg: Int
    let totalPolyUnsatFatG, totalDietFiberG, vitaminB6Mg: Double
    let foodID: String
    let manganeseMg, totalTransFatG, calciumMg, totalFolateMcg: Int
    
    public  enum CodingKeys: String, CodingKey {
        case ironMg = "iron_mg"
        case vitaminB12Mcg = "vitamin_b12_mcg"
        case shortDesc = "short_desc"
        case seleniumMcg = "selenium_mcg"
        case cholesterolMg = "cholesterol_mg"
        case magnesiumMg = "magnesium_mg"
        case vitaminDMcg = "vitamin_d_mcg"
        case units
        case vitaminCMg = "vitamin_c_mg"
        case totalSugarG = "total_sugar_g"
        case phosphorusMg = "phosphorus_mg"
        case vitaminEMg = "vitamin_e_mg"
        case kcal
        case thiaminMg = "thiamin_mg"
        case omega3_FattyAcidsG = "omega_3_fatty_acids_g"
        case potassiumMg = "potassium_mg"
        case vitaminKMcg = "vitamin_k_mcg"
        case proteinG = "protein_g"
        case riboflavinMg = "riboflavin_mg"
        case descProc = "desc_proc"
        case sodiumMg = "sodium_mg"
        case totalSatFatG = "total_sat_fat_g"
        case totalFatG = "total_fat_g"
        case niacinMg = "niacin_mg"
        case brand
        case zincMg = "zinc_mg"
        case totalMonounsatFatG = "total_monounsat_fat_g"
        case totalCarbG = "total_carb_g"
        case pantothenicAcidMg = "pantothenic_acid_mg"
        case barcode
        case copperMg = "copper_mg"
        case totalPolyUnsatFatG = "total_poly_unsat_fat_g"
        case totalDietFiberG = "total_diet_fiber_g"
        case vitaminB6Mg = "vitamin_b6_mg"
        case foodID = "food_id"
        case manganeseMg = "manganese_mg"
        case totalTransFatG = "total_trans_fat_g"
        case calciumMg = "calcium_mg"
        case totalFolateMcg = "total_folate_mcg"
    }
}

public enum Brand: String, Codable {
    case arizonaBeverageCo = "Arizona Beverage Co."
    case empty = ""
    case lipton = "Lipton"
}

// MARK: - Unit
public struct Unit: Codable {
    let unitDesc: String
    let gramsPerUnit: Double
    
    enum CodingKeys: String, CodingKey {
        case unitDesc = "unit_desc"
        case gramsPerUnit = "grams_per_unit"
    }
}

public typealias ProcessResponseModel = [ProcessResponse]

