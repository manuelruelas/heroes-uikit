//
//  HeroRepository.swift
//  heroes-uikit
//
//  Created by Jorge Guzman on 15/06/20.
//  Copyright © 2020 mruelas. All rights reserved.
//

import Foundation
import Combine

class HeroRepository{
    let heroService:HeroService = HeroService()
    let heroLocal:HeroLocal = HeroLocal()
    private var disposables = Set<AnyCancellable>()
    
    func getHero(id:Int)-> Future<Hero,Error>{
        return Future{promise in
            self.heroService.getHero(byId: id)
                .sink(receiveCompletion: { _ in },
                receiveValue: { promise(.success($0))})
                    .store(in: &self.disposables)
        }
    }
    
    func searchHero(by name:String)-> Future<[Hero],Error>{
        return Future{ promise in
            self.heroService.searchHero(byName: name)
                .sink(receiveCompletion: { value in
                },
                      receiveValue: { searchResponse in
                        promise(.success(searchResponse.results))
                        
                })
                .store(in: &self.disposables)
        }
            
    }
    
    func getHeroes(skip:Int, limit:Int) -> Future<[Hero],Error >{
        return Future<[Hero], Error>{ promise in
            var localHeroes = self.heroLocal.getHeroes(skip: skip, limit: limit)
            if localHeroes.count == limit {
                promise(.success(localHeroes))
            } else{ //fetch remaining remote heroes, save and return
                let remaining = limit - localHeroes.count
                if(remaining > 0){
                    let requests = (skip+1...skip+remaining).compactMap(self.heroService.getHero(byId:))
                    Publishers.MergeMany(requests)
                    .collect()
                        .sink(receiveCompletion: { _ in},
                              receiveValue: {heroes in
                                self.heroLocal.saveHeroes(heroes: heroes)
                                localHeroes.append(contentsOf: heroes)
                                promise(.success(localHeroes))
                        })
                    .store(in: &self.disposables)
                }else{
                    return promise(.success([]))
                }
                
            }
        }
    }
}
