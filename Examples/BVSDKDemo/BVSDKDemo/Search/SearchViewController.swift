//
//  SearchViewController.swift
//  BVSDKDemo
//
//  Created by Abhinav Mandloi on 04/11/2019.
//  Copyright © 2019 Bazaarvoice. All rights reserved.
//

import UIKit

//For manage the availabe options.
struct RadioButton {
    var buttonName: String = ""
    var isSelected: Bool = false
}

class SearchViewController: UIViewController {
    
    var radioButtonArray: [RadioButton] = []
    
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_Upper: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.cellRegistration()
        self.setRadioButton()
    }
    
    //Create Array for search Options.
    private func setRadioButton() {
        self.radioButtonArray = []
        
        self.radioButtonArray.append(RadioButton(buttonName: "Products", isSelected: true))
        self.radioButtonArray.append(RadioButton(buttonName: "Comments", isSelected: false))
        self.radioButtonArray.append(RadioButton(buttonName: "Reviews", isSelected: false))
        self.radioButtonArray.append(RadioButton(buttonName: "Questions", isSelected: false))
    }
    
    //Registration of TableView and CollectionView Cell
    private func cellRegistration() {
        
        let nib11 = UINib(nibName: "SearchContentCollectionViewCell", bundle: nil)
        self.collectionView.register(nib11, forCellWithReuseIdentifier: "SearchContentCollectionViewCell")
        
        let nib2 = UINib(nibName: "ReviewCommentTableViewCell", bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: "ReviewCommentTableViewCell")
    }
}

//Extension for UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // return UITableViewCell()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCommentTableViewCell") as! ReviewCommentTableViewCell
        
        //cell.comment = self.comments[indexPath.row]
        
        cell.onAuthorNickNameTapped = { (authorId) -> Void in
          let authorVC = AuthorProfileViewController(authorId: authorId)
          self.navigationController?.pushViewController(authorVC, animated: true)
        }
        
        return cell
    }
}

//Extension for UICollectionViewDataSource and UICollectionDelegateFlowLayout
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.radioButtonArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchContentCollectionViewCell", for: indexPath) as! SearchContentCollectionViewCell
        cell.buttonData = self.radioButtonArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width/2) - 20, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Removing the selected option
        for i in 0..<self.radioButtonArray.count {
            self.radioButtonArray[i].isSelected = false
        }
        
        //Enable the selected option.
        self.radioButtonArray[indexPath.row].isSelected = true
        
        //Refresh the Data
        self.collectionView.reloadData()
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
