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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var heroesTableView: UITableView!
    
    @IBOutlet weak var horizontalCollectionView: UICollectionView!
    let viewModel:HeroesListViewModel = HeroesListViewModel()
    private var cancellables: Set<AnyCancellable>=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loadingCellNib = UINib(nibName: "LoadingCell", bundle: nil)
        heroesTableView.register(loadingCellNib, forCellReuseIdentifier: "loadingCellid")
        let loadingCollectionCellNib = UINib(nibName: "LoadingCollectionCell", bundle: nil)
        horizontalCollectionView.register(loadingCollectionCellNib, forCellWithReuseIdentifier: "loadingCollectionCell")
        heroesTableView.tag = 1;
        horizontalCollectionView.tag=2;
        bindViewModel()
        viewModel.fetchHeroList()
        viewModel.fetchHorizontal()
    }
    
    private func bindViewModel(){

        viewModel.$heroes.sink{[weak self] heroes in
            DispatchQueue.main.async {
                self!.heroesTableView.reloadData()
            }
        }.store(in: &cancellables)
        viewModel.$heroesHorizontal.sink{[weak self] heroes in
            DispatchQueue.main.async {
                self!.horizontalCollectionView.reloadData()
            }
        }.store(in: &cancellables)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail",
            let destination = segue.destination as? HeroDetailView,
            let index = heroesTableView.indexPathForSelectedRow?.row{
            destination.hero = viewModel.heroes[index]
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView.tag {
        case heroesTableView.tag:
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height

            if (offsetY > contentHeight - scrollView.frame.height * 1.5) && viewModel.status != .loading  {
                
                viewModel.loadMore()
            }
            break
        case horizontalCollectionView.tag:
            let offsetX = scrollView.contentOffset.x
            let contentWidth = scrollView.contentSize.width

            if (offsetX > contentWidth - scrollView.frame.width) && viewModel.status != .loading  {
                viewModel.loadMoreHorizontal()
            }
            break
        default:
            break
        }
        
        
    }
}

extension HeroesListView: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return viewModel.heroes.count
        } else if section == 1{
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "heroCell", for: indexPath) as! HeroTableViewCell
            cell.heroName.text = viewModel.heroes[indexPath.row].name
            cell.heroImage.load(url:URL(string:viewModel.heroes[indexPath.row].image!.url)! )
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCellid", for: indexPath) as! LoadingCell
            cell.activityIndicator.startAnimating()
            return cell
        }
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension HeroesListView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return viewModel.heroesHorizontal.count
        }
        else {
            return 1
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "heroHorizontalCell", for: indexPath) as! HeroHorizontalViewCell
            cell.heroName.text = viewModel.heroesHorizontal[indexPath.row].name
            cell.heroImage.asCircle()
            cell.heroImage.load(url:URL(string:viewModel.heroesHorizontal[indexPath.row].image!.url)! )
                return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCollectionCell", for: indexPath) as! LoadingCollectionCell
            cell.activityIndicator.startAnimating()
            return cell
        }
    }
   
    
}

extension HeroesListView:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.hero = searchText
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}


class HeroTableViewCell: UITableViewCell {
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    
}


class HeroHorizontalViewCell: UICollectionViewCell{
    
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    
}
extension UIImageView{
    func asCircle(){
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.masksToBounds = true
    }
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
