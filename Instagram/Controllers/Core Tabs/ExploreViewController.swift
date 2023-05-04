//
//  ExploreViewController.swift
//  Instagram
//
//  Created by Mina on 25/04/2023.
//

import UIKit

class ExploreViewController: UIViewController {

    private let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .secondarySystemBackground
        return searchBar
    }()
    
    private var models = [UserPost]()
    
    private var collectionView : UICollectionView?
    
    private var TabbedSearchCollectionView: UICollectionView?
    
    private let dimmedView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureSearhBar()
        configureExploreCollection()
        configureDimmedView()
        configureTabbedSearch()
    }
    
    private func configureTabbedSearch(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.width/3, height: 52)
        layout.scrollDirection = .horizontal
        TabbedSearchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        TabbedSearchCollectionView?.backgroundColor = .yellow
        TabbedSearchCollectionView?.isHidden = false
        guard let TabbedSearchCollectionView = TabbedSearchCollectionView else { return  }
        TabbedSearchCollectionView.delegate = self
        TabbedSearchCollectionView.dataSource = self
        view.addSubview(TabbedSearchCollectionView)
    }
    
    private func configureDimmedView(){
        view.addSubview(dimmedView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didCancelSearch))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        dimmedView.addGestureRecognizer(gesture)
    }
    
    private func  configureSearhBar(){
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
    }
    
    private func configureExploreCollection(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (view.width-4)/3, height: (view.width-4)/3)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        dimmedView.frame = view.bounds
        //TabbedSearchCollectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: 72)
    }
}

extension ExploreViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        didCancelSearch()
        guard let text = searchBar.text , !text.isEmpty else {
            return
        }
        
        query(text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didCancelSearch))
        
        dimmedView.isHidden = false
        UIView.animate(withDuration: 0.2, animations:  {
            self.dimmedView.alpha = 0.4
        }) { done in
            self.TabbedSearchCollectionView?.isHidden = false
        }
    }
    
    @objc private func didCancelSearch(){
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        self.TabbedSearchCollectionView?.isHidden = true
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmedView.alpha = 0.4
        }) { done in
            if done {
                self.dimmedView.isHidden = true
            }
            
        }
    }
    
    private func query(_ text : String){
        // perform the search in the back end
        
    }
}

extension ExploreViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == TabbedSearchCollectionView {
            return 0
        }
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == TabbedSearchCollectionView {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.configure(debug: "test")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == TabbedSearchCollectionView {
            return
        }
      //  let model = models[indexPath.row]
        let user = User(username: "joe", bio: "", name: (first: "", last: ""), profilePhoto: URL(string: "https://www.google.com")!, birthDate: Date(), gender: .male, counts: UserCount(followers: 1, following: 1, posts: 1), joinedDate: Date())
        
        let post = UserPost(identifier: "", postType: .photo, thumbnailImage: URL(string: "https://www.google.com/")!, postURL: URL(string: "https://www.google.com/")!, caption: nil, likeCount: [], createdDate: Date(), comments: [], taggedUsers: [], owner: user)
        let vc = PostViewController(model: post)
        vc.title = post.postType.rawValue
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
