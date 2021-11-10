//
//  SettingTableViewController.swift
//  ForgetItNot
//
//  Created by 박정현 on 06/08/2019.
//  Copyright © 2019 박정현. All rights reserved.
//

import UIKit
import UserNotifications

class SettingTableViewController: UITableViewController {

    var settingList: [(name: String, height: CGFloat, identifier: String)] = [("Theme", 160, "SetColorCell"), ("Remove category", 160, "RemoveCategoryCell"), ("Enable badge", 80, "SwitchCell"), ("Remove ads", 80, "SimpleCell"), ("Clear data", 80, "SimpleCell"), ("About app", 80, "SimpleCell")]
    var categories: [String]?
    var delegate: FinDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = NSLocalizedString("Settings", comment: "")
        tableView.separatorStyle = .none
        
        Settings.settings.delegate = self
        Settings.setUI()
        
    }
    
    func setNavBar() {
            
        guard let navigationBar = navigationController?.navigationBar else {fatalError()}

        let bar = Settings.background()
        let tint = Settings.tint()
        let navigationBarAppearance = UINavigationBarAppearance()
        
        navigationBar.barTintColor = bar
        navigationBar.tintColor = tint
            
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [.foregroundColor:tint]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor:tint]
        navigationBarAppearance.backgroundColor = bar
            
        navigationBar.standardAppearance = navigationBarAppearance
        navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
    }
    
    // MARK: - Table view 관련 함수
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: settingList[indexPath.row].identifier) else {fatalError()}
        
        let background = Settings.cellColors()[indexPath.row % 6]
        let tint = Settings.adjustTint(background)
        
        cell.backgroundColor = background
        
        switch indexPath.row {
        case 0:
            setCell(cell as! SetColorTableViewCell, tint: tint)
        case 1:
            setCell(cell as! RemoveCategoryTableViewCell, tint: tint)
        case 2:
            setCell(cell as! EnableNotifyCell, tint: tint)
        case 3:
            setCell(cell as! SimpleCell, text: Settings.defaults.isPurchased ? NSLocalizedString("Ads have been gone", comment: "") : NSLocalizedString("Remove ads", comment: ""), tint: tint)
        case 4:
            setCell(cell as! SimpleCell, text: NSLocalizedString("Remove all data", comment: ""), tint: tint)
        default:
            setCell(cell as! SimpleCell, text: NSLocalizedString("About this app", comment: ""), tint: tint)
        }
        
        return cell
        
    }
    
    func setCell(_ cell: SetColorTableViewCell, tint: UIColor) {
        
        cell.titleLabel.text = NSLocalizedString("Themes", comment: "")
        
        cell.picker.delegate = cell.picker
        cell.picker.dataSource = cell.picker
        
        cell.picker.themeList = Settings.themeList()
        
        cell.titleLabel.textColor = tint
        cell.picker.tint = tint
        
        cell.picker.selectRow(Settings.defaults.theme, inComponent: 0, animated: false)
        
    }
    
    func setCell(_ cell: RemoveCategoryTableViewCell, tint: UIColor) {
        
        cell.titleLabel.text = NSLocalizedString("Categories", comment: "")
        cell.removeButton.setTitle(NSLocalizedString("Remove", comment: ""), for: .normal)
        
        cell.picker.delegate = cell.picker
        cell.picker.dataSource = cell.picker
        
        cell.picker.categories = categories
        
        cell.picker.tint = tint
        cell.removeButton.tintColor = tint
        cell.titleLabel.textColor = tint
        cell.delegate = self
        
        cell.removeButton.isEnabled = cell.picker.isCategoryExist()
        
    }
    
    func setCell(_ cell: EnableNotifyCell, tint: UIColor) {
        
        cell.titleLabel.textColor = tint
        
        cell.titleLabel.text = NSLocalizedString("Enable notify(6pm)", comment: "")
        cell.delegate = self
        
        cell.cellSwitch.isEnabled = Settings.auth
        cell.cellSwitch.isOn = Settings.getNotification()
        
    }
    
    func setCell(_ cell: SimpleCell, text: String, tint: UIColor) {
        
        cell.titleLabel.textColor = tint
        cell.titleLabel.text = text
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 3:
            Settings.defaults.isPurchased ? tableView.deselectRow(at: indexPath, animated: false) : askRemoveAds()
        case 4:
            askRemoveData()
        case 5:
            showAboutApp()
        default:
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return settingList[indexPath.row].height
        
    }
    
    // 알림 관련 함수
    
    func setNotification() {
        
        let content = UNMutableNotificationContent()
        
        content.title = NSLocalizedString("Review of Today", comment: "")
        content.body = NSLocalizedString("Review is the best way to memorize!", comment: "")
        
        var dateComponents = DateComponents()
        
        dateComponents.calendar = Calendar.current
        dateComponents.hour = 18
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        
        UNUserNotificationCenter.current().add(request) {(error) in
            if let warning = error {
                print(warning)
            }
        }
        
        Settings.defaults.notifyIdentifier = request.identifier
        Settings.setNotification(true)
        
    }
    
    func askRemoveAds() {
        
        let alert = UIAlertController(title: NSLocalizedString("Do you want to purchase?", comment: ""), message: NSLocalizedString("Ads will be gone.", comment: ""), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil)
        let buyAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: { (buyAction) in
            
        })
        
        alert.addAction(buyAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    //MARK: - 데이터 초기화 관련 함수
    
    func askRemoveData() {
        
        let alert = UIAlertController(title: NSLocalizedString("Are you sure to clear data?", comment: ""), message: NSLocalizedString("You have to confirm that you finished semester or all exam.", comment: ""), preferredStyle: .alert)
        let reAlert = UIAlertController(title: NSLocalizedString("Your data will be deleted.", comment: ""), message: NSLocalizedString("You agree with deleting all data from app.", comment: ""), preferredStyle: .alert)
        
        let preserveAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive, handler: { (deleteAction) in
            self.delegate?.deleteAll()
            self.navigationController?.popViewController(animated: true)
        })
        let confirmAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive, handler: { (confirmAction) in
            reAlert.addAction(deleteAction)
            reAlert.addAction(preserveAction)
            self.present(reAlert,animated: true)
        })
        
        alert.addAction(confirmAction)
        alert.addAction(preserveAction)
        
        present(alert, animated: true)
        
    }
    
    //MARK: - 앱 정보 관련 함수
    
    func showAboutApp() {
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        Defaults().isPurchased = true
        
        let alert = UIAlertController(title: "Forget It Not", message: NSLocalizedString("version : ", comment: "") + version, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
}

//MARK: - SettingDelegate 관련 함수

extension SettingTableViewController: SettingDelegate {
    func adjustColor() {
        setNavBar()
        tableView.backgroundColor = Settings.background()
        tableView.reloadData()
    }
}

extension SettingTableViewController: removeCategoryCellDelegate {
    
    func removeCategory(_ row: Int) {
        
        guard let categoryArray = categories else {fatalError()}
        
        let alert = UIAlertController(title: String.localizedStringWithFormat(NSLocalizedString("Are you sure to remove \n%@\n from category List?", comment: ""), categoryArray[row]), message: NSLocalizedString("You should confirm that it isn't needed anymore or has typing error.", comment: ""), preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive, handler: { (deleteAction) in
            self.categories!.remove(at: row)
            self.delegate?.getCategories(self.categories!)
            self.tableView.reloadData()
        })
        let preserveAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: {(preserveAction) in
        })
        
        alert.addAction(deleteAction)
        alert.addAction(preserveAction)
        
        present(alert, animated: true)
        
    }
    
}

extension SettingTableViewController: EnableNotifyCellDelegate {
    
    func turn(_ prev: Bool){
        
        if Settings.auth == false {
            tableView.reloadData()
            return
        }
        
        if prev {
            setNotification()
        } else {
            guard let identifier = Settings.defaults.notifyIdentifier else{fatalError()}
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            Settings.setNotification(false)
        }
        
    }
    
}
