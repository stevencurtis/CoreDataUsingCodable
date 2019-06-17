//
//  Commit.swift
//  CoreDataUsingCodable
//
//  Created by Steven Curtis on 16/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

struct GitCommit: Codable {
    var message: String
    var committer: Committer
}
