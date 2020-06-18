//
//  HeroDetailView.swift
//  heroes-uikit
//
//  Created by Jorge Guzman on 17/06/20.
//  Copyright © 2020 mruelas. All rights reserved.
//

import UIKit

class HeroDetailView: UIViewController {
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet var lblHeroData: [UILabel]!
   
    
    
    var hero : Hero?
    override func viewDidLoad() {
        heroImage.contentMode = .scaleAspectFill
        heroImage.asCircle()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    
    func fetchData(){
        heroImage.load(url: URL(string: (hero?.image!.url)!)!)
        lblName.text = hero?.name
        lblHeroData[0].text = "Real name: \(hero?.biography?.fullName ?? "??")"
        lblHeroData[1].text = "Alteregos: \(hero?.biography?.alterEgos ?? "??") "
        lblHeroData[2].text = "Place of birth: \(hero?.biography?.placeOfBirth ?? "??")"
        lblHeroData[3].text = "Publisher: \(hero?.biography?.publisher ?? "??")"
        lblHeroData[4].text = "Intelligence: \(hero?.powerstats?.intelligence ?? "??")"
        lblHeroData[5].text = "Power: \(hero?.powerstats?.power ?? "??")"
        lblHeroData[6].text = "Speed: \(hero?.powerstats?.speed ?? "??")"
        lblHeroData[7].text = "Strength: \(hero?.powerstats?.strength ?? "??")"
    }
}
