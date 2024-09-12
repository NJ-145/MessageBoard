//
//  MainViewController.swift
//  messageBoard
//
//  Created by imac-2626 on 2024/9/12.
//

import UIKit

import RealmSwift

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet var tbvMessage: UITableView!
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbvMessage.register(UINib(nibName: "MainViewControllerCell", bundle: nil), forCellReuseIdentifier: MainTableViewCell.identifier)
        
        
        let message: Message = Message()
        message.name = "N"
        message.messageContent = "123"
        message.messageTime = "10:00"
        
        let realm = try! Realm()
        try! realm.write{
            realm.add(message)
        }
        

    }
    
    // MARK: - UI Settings
    
    // MARK: - IBAction
    
    // MARK: - Function
    
}
// MARK: - Extensions
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        
        cell.lbName.text = "11111"
        
        return cell
        
    }
    
    
}

