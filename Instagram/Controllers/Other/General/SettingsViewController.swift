//
//  SettingsViewController.swift
//  Instagram
//
//  Created by Mina on 26/04/2023.
//

import UIKit
import SafariServices
struct SetttingCellModel {
    let title : String
    let handler : (() -> Void)
}
/// View controller to show user settings
final class SettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SetttingCellModel]]() //2d array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureModels() {
        
        data.append([
            SetttingCellModel(title: "Edit Profile", handler: { [weak self] in
                self?.didTapEditProfile()
            }) ,
            SetttingCellModel(title: "Invite Friends", handler: { [weak self] in
                self?.didTapInviteFriends()
            }) ,
            SetttingCellModel(title: "Save Original Post", handler: { [weak self] in
                self?.didTapSaveOriginalPosts()
            })
        ])
        
        data.append([
            SetttingCellModel(title: "Terms of Service", handler: { [weak self] in
                self?.OpenURL(type: .terms)
            }) ,
            
            SetttingCellModel(title: "Privacy Policy", handler: { [weak self] in
                self?.OpenURL(type: .privacy)
            }) ,
            
            SetttingCellModel(title: "Help / Feedback", handler: { [weak self] in
                self?.OpenURL(type: .help)
            })
        ])
        
        data.append([
            SetttingCellModel(title: "Log Out", handler: { [weak self] in
                self?.didTapLogOut()
            })
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func didTapEditProfile() {
        let vc = EditViewController()
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func didTapInviteFriends() {
        // Show share sheet to invite friends
    }
    
    private func didTapSaveOriginalPosts() {
        
    }
    
    enum SettingsURLType {
        case terms , privacy , help
    }
    
    private func OpenURL(type: SettingsURLType) {
        let urlString: String
        switch type {
        case .terms: urlString = "https://help.instagram.com/581066165581870"
        case .privacy: urlString = "https://help.instagram.com/155833707900388"
        case .help: urlString = "https://help.instagram.com"
        }
        
        guard let url = URL(string: urlString ) else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
    
    private func didTapLogOut() {
        let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive , handler: { _ in
            AuthManager.shared.logOut { success in
                DispatchQueue.main.async {
                    if success {
                      // present log in
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                    }
                    else {
                        // error occured
                        fatalError("Could not log out user")
                    }
                }
            }
        }))
        
        actionSheet.popoverPresentationController?.sourceView = tableView // 3shan lo sh8tlo 3la ipad me3mlsh crach
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
        
    }
    

    
}
extension SettingsViewController : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let modal = data[indexPath.section][indexPath.row]
        modal.handler()
    }
}
