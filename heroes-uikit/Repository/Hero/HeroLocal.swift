//
//  HeroLocal.swift
//  heroes-uikit
//
//  Created by Jorge Guzman on 15/06/20.
//  Copyright © 2020 mruelas. All rights reserved.
//

import Foundation
import RealmSwift

class HeroLocal{
    let realm = try! Realm()
    
    func getHero(){}
    func getHeroes(skip:Int, limit:Int )-> [Hero]{
        let heroes = realm.objects(Hero.self).sorted(byKeyPath: "name")
        let remaining =  heroes.count - skip
        if remaining >= limit{
            return Array(heroes[skip...skip+limit - 1])
        } else{
            if remaining <= 0{
                return []
            } else{
                return Array(heroes[skip...skip+remaining-1])
            }
        }
    }
    func saveHero(hero:Hero){
        try! realm.write{
            realm.add(hero)
        }
    }
    func saveHeroes(heroes:[Hero]){
       
        try! realm.write{
            for hero in heroes{
                realm.add(hero,update: .all)
            }
            
        }
       
        
    }
}
