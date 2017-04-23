//
//  Score+CoreDataProperties.swift
//  iosProject
//
//  Created by iosdev on 23.4.2017.
//  Copyright © 2017 iosdev. All rights reserved.
//

import Foundation
import CoreData


extension Score {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Score> {
        return NSFetchRequest<Score>(entityName: "Score");
    }

    @NSManaged public var lose: Int16
    @NSManaged public var player2: String?
    @NSManaged public var tie: Int16
    @NSManaged public var win: Int16
    @NSManaged public var user: User?

}
