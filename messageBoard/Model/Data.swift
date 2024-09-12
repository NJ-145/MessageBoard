//
//  Data.swift
//  messageBoard
//
//  Created by imac-2626 on 2024/9/12.
//

import UIKit
import RealmSwift

class Message: Object {
    
    @Persisted var name: String = ""
    @Persisted var messageContent: String = ""
    @Persisted var messageTime: String = ""
}
