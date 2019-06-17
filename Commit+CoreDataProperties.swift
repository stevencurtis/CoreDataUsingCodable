//
//  Commit+CoreDataProperties.swift
//  CoreDataUsingCodable
//
//  Created by Steven Curtis on 17/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//
//

import Foundation
import CoreData


extension Commit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Commit> {
        return NSFetchRequest<Commit>(entityName: "Commit")
    }

    @NSManaged public var sha: String?
    @NSManaged public var url: String?
    @NSManaged public var html_url: String?
    @NSManaged public var gitcommit: GitCommit?
}

