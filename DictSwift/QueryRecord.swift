//
//  QueryRecord.swift
//  DictSwift
//
//  Created by Hank Bao on 16/4/18.
//  Copyright © 2016 zTap Studio. All rights reserved.
//

import Foundation

struct QueryRecord {
    let term: String
    let date: NSDate
    var queryCount: Int

    init(term: String) {
        self.term = term
        date = NSDate()
        queryCount = 1
    }
}