//
//  User+CoreDataProperties.swift
//  iosProject
//
//  Created by iosdev on 23.4.2017.
//  Copyright © 2017 iosdev. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var device: String?
    @NSManaged public var lose: Int16
    @NSManaged public var password: String?
    @NSManaged public var tie: Int16
    @NSManaged public var win: Int16
    @NSManaged public var username: String?
    @NSManaged public var user: NSSet?

}

// MARK: Generated accessors for user
extension User {

    @objc(addUserObject:)
    @NSManaged public func addToUser(_ value: Score)

    @objc(removeUserObject:)
    @NSManaged public func removeFromUser(_ value: Score)

    @objc(addUser:)
    @NSManaged public func addToUser(_ values: NSSet)

    @objc(removeUser:)
    @NSManaged public func removeFromUser(_ values: NSSet)

}
