//
//  ChatData+CoreDataProperties.swift
//  DemoChat
//
//  Created by Lucideus  on 11/22/17.
//  Copyright © 2017 RIL. All rights reserved.
//
//

import Foundation
import CoreData


extension ChatData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatData> {
        return NSFetchRequest<ChatData>(entityName: "ChatData")
    }

    @NSManaged public var chat: String?
    @NSManaged public var chatTime: Double

}
