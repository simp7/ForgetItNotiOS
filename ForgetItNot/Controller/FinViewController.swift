//
//  ViewController.swift
//  ForgetItNot
//
//  Created by 박정현 on 30/07/2019.
//  Copyright © 2019 박정현. All rights reserved.
//

import UIKit
import SwipeCellKit

class FinTableViewController: UITableViewController {
    
    let date = DateManager()
    var db = Database.getInstance()
    
    var categories = Settings.defaults.categories {
        didSet {
            Settings.defaults.categories = categories
        }
    }
    
    //MARK: - tableView 관련 함수
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initializeData()
        
        tableView.separatorStyle = .none
        
        Settings.settings.getTheme()
        
        detectDayChange()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return db.sizeOfTodo()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinCell") as! FinTableViewCell
        guard let selected = db.getTodo(from: indexPath.row) else {fatalError("Invalid index in finToday")}
        var color = Settings.cellColors()[0]
        if let repetition = selected.repetition.value {
            color = Settings.cellColors()[repetition]
        }
        
        cell.categoryLabel.text = selected.category
        cell.rangeLabel.text = selected.range
        
        cell.categoryLabel.textColor = Settings.adjustTint(color)
        cell.rangeLabel.textColor = Settings.adjustTint(color)
        cell.backgroundColor = color
        
        cell.delegate = self
        
        return cell
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFinData", sender: self)
    }
    
    //MARK: - 앱 실행 관련 함수
    
    func initializeData() {
        db = Database.getInstance()
        if date.loadLastDate() == nil {
            initFirstTime()
        }
        date.updateLastDate()
        
    }
    
    func initFirstTime() {
        
        debugPrint("This is first time to run app.")
        
        Settings.settings.changeTheme(to: 0)
        Settings.setNotification(false)
        
        insert(FinData(category: NSLocalizedString("Swipe the cell", comment: ""), range: "<-------------------------------"))
        tableView.reloadData()
        
    }
    
    //MARK: - 화면 전환 관련 함수
    
    override func viewWillAppear(_ animated: Bool) {
        Settings.settings.delegate = self // 자식 뷰에서 나올 때 SettingDelegate 재적용
        Settings.setUI()
    }
    
    //MARK: - Navigation Bar 관련 함수
    
    func setNavBar() {
        
        guard let navigationBar = navigationController?.navigationBar else {fatalError()}

        let bar = Settings.background()
        let tint = Settings.tint()
        
        navigationBar.barTintColor = bar
        navigationBar.tintColor = tint
        
        if #available(iOS 13.0, *) {
            
            let navigationBarAppearance = UINavigationBarAppearance()
            
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.titleTextAttributes = [.foregroundColor:tint]
            navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor:tint]
            navigationBarAppearance.backgroundColor = bar
            
            
            navigationBar.standardAppearance = navigationBarAppearance
            navigationBar.scrollEdgeAppearance = navigationBarAppearance
            
        } else {
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : tint]
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : tint]
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addNewFinData", sender: self)
    }
    
    @IBAction func settingButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "changeSettings", sender: self)
    }
    
    //MARK: - Segue 관련 함수
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "addNewFinData":
            prepare(to: segue.destination as! AddFinViewController)
        case "showFinData":
            prepare(to: segue.destination as! FinInfoViewController)
        case "changeSettings":
            prepare(to: segue.destination as! SettingTableViewController)
        default:
            debugPrint("Cannot find matching identifier.")
        }
        
    }
    
    func prepare(to destination: AddFinViewController) {
        destination.delegate = self
        destination.categories = categories
    }
    
    func prepare(to destination: FinInfoViewController) {
        
        guard let indexPath = tableView.indexPathForSelectedRow else {fatalError()}
        
        if let selectedFin = db.getTodo(from: indexPath.row) {
            destination.currentFin = selectedFin
            destination.selectedRow = indexPath.row
            destination.delegate = self
        }
        
    }
    
    func prepare(to destination: SettingTableViewController) {
        destination.categories = categories
        destination.delegate = self
    }
    
    func clear(_ data: FinData) {
        db.clear(data)
        //TODO: 통계에 활용할 자료 추가
    }
    
    //MARK: - 날짜 관련 함수
    
    func detectDayChange() {
        
        let notificationArray = [UIApplication.significantTimeChangeNotification, UIApplication.didBecomeActiveNotification]
        
        for notification in notificationArray {
            NotificationCenter.default.addObserver(forName: notification, object: nil, queue: nil) {_ in
                
                Settings.today = Date()
                
                self.initializeData()
                self.tableView.reloadData()
                
            }
        }
        
    }
}
//MARK: - SwipeTableView 라이브러리

extension FinTableViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .right {
            
            let clearAction = SwipeAction(style: .destructive, title: NSLocalizedString("Clear", comment: "")) { action, indexPath in
                guard let cleared = self.db.getTodo(from: indexPath.row) else {fatalError()}
                self.clear(cleared)
            }
            
            setSwipeAction(clearAction, img: "done-icon")
            
            return [clearAction]
            
        }
        
        return nil
        
    }
    
    func setSwipeAction (_ action: SwipeAction, img imgName: String) {
        
        action.image = UIImage(named: imgName)!.withRenderingMode(.alwaysTemplate)
        
        action.backgroundColor = Settings.background()
        action.textColor = Settings.tint()
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        
        return options
        
    }
    
}

//MARK:- FinDelegate 관련 함수

extension FinTableViewController: FinDelegate {
    
    func insert(_ data: FinData) {
        db.insert(data)
        tableView.reloadData()
        
    }
    
    func getCategories(_ list: [String]) {
        categories = list
    }
    
    func isAlreadyExist(_ data: FinData) -> Bool {
        return db.isThere(data)
    }
    
    func delete(_ data: FinData) {
        db.delete(fin: data)
        tableView.reloadData()
    }
    
    func deleteAll() {
        db.deleteAll()// Realm 저장소 초기화
        categories = [] // 이름 목록 삭제(Userdefaults에도 자동 적용)
        initializeData()
    }

}

//MARK: - SettingDelegate 관련 함수

extension FinTableViewController: SettingDelegate {
    
    func adjustColor() {
        setNavBar()
        tableView.backgroundColor = Settings.background()
        tableView.reloadData()
    }
    
}

protocol FinDelegate {
    func insert(_ data: FinData)
    func getCategories(_ list: [String])
    func delete(_ data: FinData)
    func deleteAll()
    func isAlreadyExist(_ data: FinData) -> Bool
}
