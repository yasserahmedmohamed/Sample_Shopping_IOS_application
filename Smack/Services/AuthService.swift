//
//  AuthService.swift
//  Smack
//
//  Created by yasser ahmed on 4/15/19.
//  Copyright © 2019 yasser ahmed. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard // like shared prefrance in android
    
    var isloggedin : Bool{
        get{
            return defaults.bool(forKey: LOGGED_IN_KEY )
        }
        set{
            defaults.set(newValue, forKey: LOGGED_IN_KEY )
        }
        
    }
    
    var authtoken : String {
        get{
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set{
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail : String {
        get{
            return defaults.value(forKey: USER_MAIL) as! String
        }
        set{
            defaults.set(newValue, forKey: USER_MAIL)
        }
    }
    
    
    func registerUser(email:String,password:String, copmlition: @escaping CompilationHandler)
    {
        let loweremail = email.lowercased()
        
        let body : [String : Any ]=[
        
            "email" : loweremail,
            "password" : password
        ]
        Alamofire.request(url_register, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER ).responseString { (responce) in
            
            if responce.error == nil {
                copmlition(true)
            }
            else{
            copmlition(false)
            debugPrint(responce.result.error as Any)
            }
        }
    }
    func LoginUSer(foremail email : String ,forpassowrd password : String, copmlition: @escaping CompilationHandler)
    {
        let loweremail = email.lowercased()
        
        let body : [String : Any ]=[
            
            "email" : loweremail,
            "password" : password
        ]
        Alamofire.request(url_login, method: .post, parameters: body, encoding: JSONEncoding.default , headers: HEADER).responseJSON { (responce) in
            if responce.result.error == nil {
//                if let json = responce.result.value as? Dictionary<String, Any>
//                {
//                    if let email = json["user"] as? String {
//                        self.userEmail = email
//                    }
//                    if let token = json["token"] as? String {
//                        self.authtoken = token
//                    }
//
//                }
                guard let data = responce.data else { return }
                
                let json = try? JSON(data: data)
                
                 self.authtoken = json?["token"].stringValue ?? ""
                self.userEmail = json?["user"].stringValue ?? ""
                self.isloggedin = true
                copmlition(true)
            }else
            {
                copmlition(false)
                debugPrint(responce.result.error as Any)
            }
        }

        
    }
}
