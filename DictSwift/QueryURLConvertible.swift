//
//  QueryURLConvertible.swift
//  DictSwift
//
//  Created by Hank Bao on 16/4/22.
//  Copyright © 2016 zTap Studio. All rights reserved.
//

import Foundation

protocol QueryURLConvertible {
    var zt_queryURL: NSURL? { get }
}

extension String: QueryURLConvertible {
    var zt_queryURL: NSURL? {
        let charset = NSCharacterSet.URLQueryAllowedCharacterSet()
        if let encoded = stringByAddingPercentEncodingWithAllowedCharacters(charset) {
            let str = "https://cn.bing.com/dict/search?q=" + encoded
            return NSURL(string: str)
        } else {
            return nil
        }
    }
}