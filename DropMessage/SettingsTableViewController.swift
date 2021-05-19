//
//  SettingsTableViewController.swift
//  DropMessage
//
//  Created by Mostafa Zidan on 5/17/21.
//  Copyright © 2021 Mostafa Zidan. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    
    //MARK: - Outlet
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showUserInfo()
    }
    //MARK: - IBActions
    @IBAction func tellAFriendButtonPressed(_ sender: Any) {
        print("tell a friend was pressed")
    }
    
    @IBAction func termsAndConditionsButtonPressed(_ sender: Any) {
        print("terms and conditions was pressed")
    }
    @IBAction func logOutButtonPressed(_ sender: Any) {
        FirebaseUserLestiner.shared.logOutCurrentUser { (error) in
            if error == nil {
                let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginView")
                DispatchQueue.main.async {
                    loginView.modalPresentationStyle = .fullScreen
                    self.present(loginView, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    //MARK: - UpdateUI
    private func showUserInfo() {
        if let user = User.currentUser {
            usernameLabel.text = user.username
            statusLabel.text = user.status
            appVersionLabel.text = "App Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)"
            
            if user.avatarLink != "" {
                //download and set avatar image
            }
        }
    }
    
    
    //MARK: - TableView Delegates
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgoundColor")
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 20.0
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "settingsToEditProfile", sender: self)
        }
    }
}
