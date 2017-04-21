//
//  User+CoreDataProperties.swift
//  iosProject
//
//  Created by iosdev on 21.4.2017.
//  Copyright © 2017 iosdev. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var password: String?
    @NSManaged public var win: Int16
    @NSManaged public var lose: Int16
    @NSManaged public var tie: Int16
    @NSManaged public var device: String?
    @NSManaged public var username: NSSet?

}

// MARK: Generated accessors for username
extension User {

    @objc(addUsernameObject:)
    @NSManaged public func addToUsername(_ value: Score)

    @objc(removeUsernameObject:)
    @NSManaged public func removeFromUsername(_ value: Score)

    @objc(addUsername:)
    @NSManaged public func addToUsername(_ values: NSSet)

    @objc(removeUsername:)
    @NSManaged public func removeFromUsername(_ values: NSSet)

}
