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
    
    @IBOutlet var lbName: UILabel!
    
    @IBOutlet var lbMessage: UILabel!
    
    @IBOutlet var txfName: UITextField!
    
    @IBOutlet var txvMessage: UITextView!
    
    @IBOutlet var btnSent: UIButton!
    
    @IBOutlet var btnSort: UIButton!
    
    
    
    // MARK: - Property
    
    var messageArray: [Message] = []
    var deleteArr_cell : Message?
    var edit_cell : Message?
    var editCell_Time : Message?

    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUi()
    }
    
    // MARK: - UI Settings
    func setUi() {
        tbvMessage.register(UINib(nibName: "MainTableViewCell", bundle: nil),
                            forCellReuseIdentifier: MainTableViewCell.identifier)
        tbvMessage.delegate = self
        tbvMessage.dataSource = self
        
        
        lbName.text = "留言人:"
        lbMessage.text  = "留言內容"
        
        let realm = try! Realm()
        let message_Boards = realm.objects(Message.self)
        for message in message_Boards {
            messageArray.append(message)
        }
        print("file: \(realm.configuration.fileURL!)")
        
        tbvMessage.layer.cornerRadius = 10  // 設定圓角半徑
        tbvMessage.layer.masksToBounds = true
    }
    
    // MARK: - IBAction
    @IBAction func send(_ sender: Any) {
        
        let realm = try! Realm()
        
        
        
        if btnSent.currentTitle == "編輯" {
            
            try! realm.write {
                edit_cell?.name = self.txfName.text ?? ""
                edit_cell?.messageContent = self.txvMessage.text ?? ""
                edit_cell?.messageTime = formattedCurrentDate()
                
                self.editCell_Time?.name = self.edit_cell?.name ?? ""
                self.editCell_Time?.messageContent = self.edit_cell?.messageContent ?? ""
                self.editCell_Time?.messageTime = edit_cell?.messageTime ?? ""
                
                self.btnSent.setTitle("", for: .normal)
            }
        } else {
            // 原本的送出
            guard txfName.text != "" , txvMessage.text != "" else {
                // 創建警示框
                let alertController = UIAlertController(title: "輸入錯誤",
                                                            message: "名稱和訊息不能為空",
                                                            preferredStyle: .alert)
                    
                // 添加確認按鈕
                let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
                alertController.addAction(okAction)
                    
                // 顯示警示框
                self.present(alertController, animated: true, completion: nil)
                return
            }
            let message: Message = Message(name: txfName.text ?? "",
                                           messageContent: txvMessage.text ?? "",
                                           messageTime: formattedCurrentDate())
            
            try! realm.write{
                realm.add(message)
            }
            
            messageArray.append(message)
            
    //        if let user = txfName.text, let message = txvMessage.text {
    //            if user != "" && message != "" {
    //                let new_message = Message(name: user, messageContent: message, messageTime: dateString)
    //                try! realm.write{
    //                    realm.add(new_message)
    //                }
    //            }
    //        }
            
            
        }
        txfName.text = ""
        txvMessage.text = ""

        tbvMessage.reloadData()
        
    }
    
    
    @IBAction func sort(_ sender: Any) {
        let realm = try! Realm()
        let messageBoards = realm.objects(Message.self)
        
        // 如果還沒有留言
        // UIAlertController是顯示警告對話框或選擇對話框的類別
        // .alert是警示框
        if messageBoards.count == 0 {
            let controller = UIAlertController(title: "沒有輸入留言", message: "請留言", preferredStyle: .alert)
            
            // UIAlertAction定義當使用者點擊提示框中的按鈕時應該執行的動作
            // .default: 一般樣式按鈕
            // handler：當按鈕被點擊時執行的程式碼區塊
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            controller.addAction(okAction)
            present(controller, animated: true)
        }
        else {
            // .actionSheet：從畫面底部滑入,提供選項讓使用者選擇
            let alertController = UIAlertController(title: "請選擇留言排序", message: "送出/更新留言時間", preferredStyle: .actionSheet)
            let newToOldAction = UIAlertAction(title: "新到舊", style: .default) {_ in
                let sortResult = messageBoards.sorted(byKeyPath: "messageTime", ascending: false)
                self.messageArray = []
                guard sortResult.count > 0 else {
                    self.tbvMessage.reloadData()
                    return
                }
                for i in 0..<sortResult.count {
                    self.messageArray.append(Message(name: sortResult[i]["name"] as! String,
                                                     messageContent: sortResult[i]["messageContent"] as! String,
                                                     messageTime: sortResult[i]["messageTime"] as! String))
                }
                self.tbvMessage.reloadData()
            }
            let oldToNewAction = UIAlertAction(title: "舊到新", style: .default) {_ in
                let sortResult = messageBoards.sorted(byKeyPath: "messageTime", ascending: true)
                self.messageArray = []
                guard sortResult.count > 0 else {
                    self.tbvMessage.reloadData()
                    return
                }
                for i in 0..<sortResult.count {
                    self.messageArray.append(Message(name: sortResult[i]["name"] as! String,
                                                     messageContent: sortResult[i]["messageContent"] as! String,
                                                     messageTime: sortResult[i]["messageTime"] as! String))
                }
                self.tbvMessage.reloadData()
            }
            let closeAction = UIAlertAction(title: "close", style: .cancel, handler: nil)
            
            alertController.addAction(newToOldAction)
            alertController.addAction(oldToNewAction)
            alertController.addAction(closeAction)
            
            self.present(alertController, animated: true)
            
            
            
        }
        
    }
    
    
    // MARK: - Function
    func formattedCurrentDate() -> String {
        let currentData = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: currentData)
    }

}
// MARK: - Extensions
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, 
                                                 for: indexPath) as! MainTableViewCell
        
        cell.lbName.text = messageArray[indexPath.row].name
        cell.lbContent.text = messageArray[indexPath.row].messageContent
        
        return cell
    }
    
    
    // Realm資料刪除
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") {
            (_, _, completionHandler) in
            //print("delet")
            let realm = try! Realm()
            
            if indexPath.row < self.messageArray.count {
                self.deleteArr_cell = self.messageArray[indexPath.row]
                let edit_CurrentTime = self.deleteArr_cell?.messageTime
                let delete_cell = realm.objects(Message.self).where {
                    $0.messageTime == edit_CurrentTime ?? ""
                }[0]
                try! realm.write {
                    realm.delete(delete_cell)
                }
                self.messageArray.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // Realm編輯留言
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "edit") { [self]
            (_, _, completionHandler) in
            
            self.btnSent.setTitle("編輯", for: .normal)
            if indexPath.row < messageArray.count {
                self.edit_cell = messageArray[indexPath.row]
                self.txfName.text = self.edit_cell?.name
                self.txvMessage.text = self.edit_cell?.messageContent
                
                let edit_CurrentTime = self.edit_cell?.messageTime
                let realm = try! Realm()
                
                
                self.editCell_Time = realm.objects(Message.self).where {
                    $0.messageTime == edit_CurrentTime ?? ""
                }[0]
            }
            tableView.reloadData()
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [editAction])
        
    }
    
}

