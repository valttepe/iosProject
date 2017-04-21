//
//  Score+CoreDataProperties.swift
//  iosProject
//
//  Created by iosdev on 21.4.2017.
//  Copyright © 2017 iosdev. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Score {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Score> {
        return NSFetchRequest<Score>(entityName: "Score");
    }

    @NSManaged public var win: Int16
    @NSManaged public var tie: Int16
    @NSManaged public var lose: Int16
    @NSManaged public var player2: NSObject?
    @NSManaged public var user: User?

}
