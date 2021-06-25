//
//  SettingsViewController.swift
//  QueritelPractical
//
//  Created by Bright Ahedor on 24/06/2021.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    
    let settings = [
        SettingsItem(image: "person.circle", name: "Show Profile", action: SettingAction.PROFILE),
        SettingsItem(image: "music.note", name: "Audio Recorder", action: SettingAction.RECORD),
        SettingsItem(image: "message.circle", name: "Notification Management", action: SettingAction.NOTIFICATION),
    ]

    override func viewDidLoad() {
        
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        
        self.settingsTableView.register(UINib.init(nibName: AppConstants.settingsTableViewCellId, bundle: nil), forCellReuseIdentifier: AppConstants.settingsTableViewCellId)
        
    }
}

extension SettingsViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feed = self.settings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.settingsTableViewCellId, for: indexPath) as! SettingsTableViewCell
        cell.feed = feed
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.settings[indexPath.row]
        switch item.action {
        case SettingAction.NOTIFICATION:
            self.startNotificationPage()
        case SettingAction.PROFILE:
            self.startProfilePage()
        default:
            self.startRecorderPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = UIColor.clear
        cell!.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath as IndexPath)
        cell!.contentView.backgroundColor = UIColor.clear
        cell!.selectionStyle = .none
    }
    
    func startNotificationPage()  {
        if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
    }

    func startProfilePage()  {
        let storyboard = UIStoryboard(name: AppConstants.mainStoryBoardId, bundle: nil)
        let destination = storyboard.instantiateViewController(withIdentifier: AppConstants.profileControllerStoryBoardId)
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    func startRecorderPage()  {
        let storyboard = UIStoryboard(name: AppConstants.mainStoryBoardId, bundle: nil)
        let destination = storyboard.instantiateViewController(withIdentifier: AppConstants.audioControllerStoryBoardId)
        self.navigationController?.pushViewController(destination, animated: true)
    }

}
