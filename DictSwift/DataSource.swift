//
//  DataSource.swift
//  DictSwift
//
//  Created by Hank Bao on 16/4/18.
//  Copyright © 2016 zTap Studio. All rights reserved.
//

import UIKit


class DataSource: NSObject, UITableViewDataSource {

    typealias CellConfigure = (cell: UITableViewCell, record: QueryRecord) -> UITableViewCell

    private var queryRecords: [QueryRecord] = []
    private let configure: CellConfigure
    private let reuseIdentifier: String

    init(configure: CellConfigure, reuseIdentifier: String) {
        self.configure = configure
        self.reuseIdentifier = reuseIdentifier
    }

    func addTerm(term: String) -> (indexPath: NSIndexPath, isNewTerm: Bool) {
        var row: Int?

        for (idx, rec) in queryRecords.enumerate() {
            if term == rec.term {
                row = idx
                break
            }
        }

        if let row = row {
            queryRecords[row].queryCount += 1
            return (NSIndexPath(forRow: row, inSection: 0), false)
        } else {
            queryRecords.append(QueryRecord(term: term))
            return (NSIndexPath(forRow: queryRecords.count - 1, inSection: 0), true)
        }
    }

    func moveTermAtIndexPath(from: NSIndexPath, toIndexPath to: NSIndexPath) {
        let record = queryRecords[from.row]
        queryRecords.removeAtIndex(from.row)
        queryRecords.insert(record, atIndex: to.row)
    }

    func termAtIndexPath(indexPath: NSIndexPath) -> String {
        return queryRecords[indexPath.row].term
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queryRecords.count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let record = queryRecords[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)

        return configure(cell: cell, record: record)
    }
}