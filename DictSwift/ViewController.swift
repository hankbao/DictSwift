//
//  ViewController.swift
//  DictSwift
//
//  Created by Hank Bao on 16/4/17.
//  Copyright © 2016 zTap Studio. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UITableViewController {

    private var toolbar: UIToolbar!
    private weak var textField: UITextField!

    private var dataSource: DataSource!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupUI()

        tableView.keyboardDismissMode = .OnDrag
        view.becomeFirstResponder()
    }

    private func setupData() {
        let configure: DataSource.CellConfigure = { cell, record in
            cell.textLabel?.text = record.term
            cell.detailTextLabel?.text = NSDateFormatter
                .localizedStringFromDate(record.date, dateStyle: .ShortStyle, timeStyle: .ShortStyle)

            var countLabel: UILabel? = cell.accessoryView as? UILabel
            if countLabel == nil {
                countLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                cell.accessoryView = countLabel
            }
            countLabel?.text = String(format: "%ld", record.queryCount)

            return cell
        }

        dataSource = DataSource(configure: configure, reuseIdentifier: "dict.swift.cell.simple")
        tableView.dataSource = dataSource
        tableView.delegate = self
    }

    private func setupUI() {
        toolbar = UIToolbar(frame: toolbarFrame)
        toolbar.items = [textItem, spaceItem, searchItem]
    }

    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    private var textFrame: CGRect {
        return CGRect(x: 0, y: 0, width: 300, height: 40)
    }

    private var toolbarFrame: CGRect {
        let screenBounds = UIScreen.mainScreen().bounds
        return CGRect(x: 0, y: 0, width: screenBounds.size.width, height: 44)
    }

    private var textItem: UIBarButtonItem {
        let textField = UITextField(frame: textFrame)
        textField.placeholder = "Input word here."
        textField.clearButtonMode = .WhileEditing

        textField.delegate = self
        self.textField = textField
        return UIBarButtonItem(customView: textField)
    }

    private var spaceItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    }

    private var searchItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(query))
    }

    override var inputAccessoryView: UIView? {
        return toolbar
    }

    private func showTerm(term: String) {
        let charSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        guard let encoded = term.stringByAddingPercentEncodingWithAllowedCharacters(charSet),
            url = NSURL(string: "https://cn.bing.com/dict/search?q=\(encoded)") else {
                preconditionFailure("invalid url.")
        }
        let libViewController = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
        presentViewController(libViewController, animated: true, completion: nil)
    }

    private func queryTerm(term: String) {
        textField.text = nil

        let (indexPath, isNewTerm) = dataSource.addTerm(term)
        if (isNewTerm) {
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
        } else {
            let to = NSIndexPath(forRow: 0, inSection: 0)
            dataSource.moveTermAtIndexPath(indexPath, toIndexPath: to)
            tableView.moveRowAtIndexPath(indexPath, toIndexPath: to)
            tableView.reloadRowsAtIndexPaths([to], withRowAnimation: .Automatic)
        }

        showTerm(term)
    }

    @objc private func query(sender: AnyObject) {
        if let term = textField.text {
            queryTerm(term)
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let term = dataSource.termAtIndexPath(indexPath)
        queryTerm(term)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        query(textField)
        return false
    }
}
