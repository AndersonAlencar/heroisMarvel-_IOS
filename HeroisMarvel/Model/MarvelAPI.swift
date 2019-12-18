//
//  MarvelAPI.swift
//  HeroisMarvel
//
//  Created by Anderson Alencar on 12/12/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Foundation
import SwiftHash
import Alamofire


class MarvelAPI {
    
    static private let basepath = "https://gateway.marvel.com/v1/public/characters?"
    static private let privateKey = "3fd663cc6e9afe8660100aedc91e97a83340f767"
    static private let publicKey = "01833e6199e03ac6ce0dae96cc53711e"
    static private let limit = 50
    
    class func loadHeros(name: String?, page: Int = 0, onComplete: @escaping(MarvelInfo?) -> Void){
     
        let offset = page * limit
        let startsWith: String
        if let name = name, !name.isEmpty {
            startsWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))&"
        } else {
            startsWith = ""
        }
         
        let url = basepath + "offset=\(offset)&limit=\(limit)&" + startsWith + getCredentials()
        print("A url é igual a: \(url)")
        let request = AF.request(url).responseJSON { (response) in
            guard let data = response.data,
                let marvelInfo = try? JSONDecoder().decode(MarvelInfo.self, from: data),
                marvelInfo.code == 200 else {
                    onComplete(nil)
                    return
            }
            onComplete(marvelInfo)
        }
    }
    
     
    private class func getCredentials() -> String{
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(ts+privateKey+publicKey).lowercased()
        return "ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
    }

    
    
}
