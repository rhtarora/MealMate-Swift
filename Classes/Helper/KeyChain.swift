//
//  KeyChain.swift
//  Alamofire
//
//  Created by Macintosh on 01/06/22.
//

import Foundation

class Keychain {
    class func save(key: String, data: Data) -> OSStatus {
        let query : [String:Any] = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    class func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as CFDictionary
        
        var dataTypeRef:AnyObject? = nil
        
        let status: OSStatus = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == noErr {
            return (dataTypeRef! as! Data)
        } else {
            return nil
        }
    }
    
    class func stringToData(string : String)->Data
    {
        let data = string.data(using: .utf8)
        return data!
        
    }
    
    class func CreateUniqueID() -> String
    {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr:CFString = CFUUIDCreateString(nil, uuid)
        
        let nsTypeString = cfStr as NSString
        let swiftString:String = nsTypeString as String
        return swiftString
    }
}
