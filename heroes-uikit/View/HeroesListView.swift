//
//  ViewController.swift
//  heroes-uikit
//
//  Created by Jorge Guzman on 14/06/20.
//  Copyright © 2020 mruelas. All rights reserved.
//

import UIKit
import Combine

class HeroesListView: UIViewController {
    let viewModel:HeroesListViewModel = HeroesListViewModel()
    private var cancellables: Set<AnyCancellable>=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.fetchHeroList()
    }
    
    private func bindViewModel(){
        viewModel.$heroes.sink{[weak self] heroes in
            
        }.store(in: &cancellables)
    }
    
}

extension HeroesListView: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! HeroTableViewCell
        cell.heroName.text = viewModel.heroes[indexPath.row].name
        cell.heroImage.load(url:URL(string:viewModel.heroes[indexPath.row].image!.url)! )
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = viewModel.heroes.count-1
        if(indexPath.row == lastElement){
            viewModel.loadMore(id: indexPath.row)
        }
    }
}

class HeroTableViewCell: UITableViewCell {
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    
}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
