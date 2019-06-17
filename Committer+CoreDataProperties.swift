//
//  Committer+CoreDataProperties.swift
//  CoreDataUsingCodable
//
//  Created by Steven Curtis on 17/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//
//

import Foundation
import CoreData


extension Committer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Committer> {
        return NSFetchRequest<Committer>(entityName: "Committer")
    }

    // Automatically created as NSDate, changed to Date
    @NSManaged public var date: Date?
    @NSManaged public var name: String?

}
