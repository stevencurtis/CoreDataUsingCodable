//
//  CommitNode.swift
//  CoreDataUsingCodable
//
//  Created by Steven Curtis on 16/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

struct CommitNode: Codable {
    var commit : GitCommit
    var sha: String
    var html_url: String
}
