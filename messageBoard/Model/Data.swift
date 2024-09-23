//
//  Data.swift
//  messageBoard
//
//  Created by imac-2626 on 2024/9/12.
//

import UIKit
import RealmSwift

class Message: Object {
    @Persisted(primaryKey: true) var uuid: ObjectId
    @Persisted var name: String = ""
    @Persisted var messageContent: String = ""
    @Persisted var messageTime: String = ""
    
    convenience init(name: String, messageContent: String, messageTime: String) {
        self.init()
        self.name = name
        self.messageContent = messageContent
        self.messageTime = messageTime
    }
}
