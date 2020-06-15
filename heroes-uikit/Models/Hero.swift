//
//  Hero.swift
//  heroes-uikit
//
//  Created by Jorge Guzman on 15/06/20.
//  Copyright © 2020 mruelas. All rights reserved.
//

import Foundation
import RealmSwift

class Hero:Object, Decodable {
    @objc dynamic var id:String
    @objc dynamic var name: String
    @objc dynamic var powerstats: Powerstats?
    @objc dynamic var biography: Biography?
    @objc dynamic var image: Img?
    
    override static func primaryKey() -> String? {
      return "id"
    }
   
    private enum CodingKeys:String,CodingKey{
        case id
        case name
        case image
        case powerstats
        case biography
    }
}

class Img:Object, Decodable {
    @objc dynamic var url: String
    
    private enum CodingKeys:String,CodingKey{
        case url
    }
}

// MARK: - Biography
class Biography:Object, Decodable {
     @objc dynamic var fullName:String
     @objc dynamic var alterEgos: String
     @objc dynamic var placeOfBirth:String
     @objc dynamic var firstAppearance: String
     @objc dynamic var publisher:String
     @objc dynamic var alignment: String
    
    enum CodingKeys: String, CodingKey{
        case fullName = "full-name"
        case alterEgos = "alter-egos"
        case placeOfBirth = "place-of-birth"
        case firstAppearance = "first-appearance"
        case publisher
        case alignment
    }
}


// MARK: - Powerstats
class Powerstats:Object, Decodable {
     @objc dynamic var intelligence: String
     @objc dynamic var strength:String
     @objc dynamic var speed: String
     @objc dynamic var durability: String
     @objc dynamic var power: String
     @objc dynamic var combat: String
    
    enum CodingKeys:String,CodingKey{
        case intelligence
        case strength
        case speed
        case durability
        case power
        case combat
    }
}
