//
//  HeroesListViewModel.swift
//  heroes-uikit
//
//  Created by Jorge Guzman on 15/06/20.
//  Copyright © 2020 mruelas. All rights reserved.
//

import Foundation
import Combine

class HeroesListViewModel: ObservableObject {
    private let heroRepository:HeroRepository
    @Published var heroes:[Hero] = []
    @Published var hero: String = ""
    @Published var heroesHorizontal: [Hero] = []
    
    var status: StatusEnum = .loading
    private var disposables = Set<AnyCancellable>()
    private var scheduler: DispatchQueue  = DispatchQueue(label: "HeroesListViewModel")
    
    init(heroRepository:HeroRepository = HeroRepository()) {
        self.heroRepository = heroRepository
        observeSearchField()
    }
    private func observeSearchField(){
        $hero
        .dropFirst(1)
            .debounce(for: .seconds(0.5), scheduler: scheduler)
        .receive(on: DispatchQueue.main)
        .sink(receiveValue:{ name in
                self.heroes.removeAll()
            if(name.isEmpty){
                self.fetchHeroList()
            }else{
                
                self.searchHero(by: name)
            }
        })
        .store(in: &disposables)
    }
    
    func fetchHeroList(){
        heroRepository.getHeroes(skip: heroes.count,limit: 10)
            .sink(receiveCompletion:{value in
            },
                receiveValue:{ heroes in
                    self.heroes.append(contentsOf: heroes.sorted(by: { (prvHero, hero) -> Bool in
                        return (Int(prvHero.id) ?? 0) < (Int(hero.id) ?? 0)
                    }))
                    self.status = .ready
            }).store(in: &disposables)
    }
    
    func fetchHorizontal(){
        heroRepository.getHeroes(skip: heroesHorizontal.count,limit: 5)
            .sink(receiveCompletion:{value in
            },
                receiveValue:{ heroes in
                    self.heroesHorizontal.append(contentsOf: heroes.sorted(by: { (prvHero, hero) -> Bool in
                        return (Int(prvHero.id) ?? 0) < (Int(hero.id) ?? 0)
                    }))
                    self.status = .ready
            }).store(in: &disposables)
    }
    
    func searchHero(by name:String){
        heroRepository
            .searchHero(by: name)
            .sink(receiveCompletion: {value in
                self.status = .ready
            },
              receiveValue: { heroes in
                    self.status = .ready
                    self.heroes.removeAll()
                    self.heroes.append(contentsOf: heroes)
            }).store(in: &disposables)
    }
    
    func loadMore() -> Void {
        if(status == .ready ){
            status = .loading
            
            fetchHeroList()
        }
    }
    func loadMoreHorizontal() -> Void {
        if(status == .ready ){
            status = .loading
            fetchHorizontal()
        }
    }
    
}

enum StatusEnum{
    case ready
    case loading
}
