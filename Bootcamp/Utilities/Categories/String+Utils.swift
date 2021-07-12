//
//  String+Utils.swift
//  Bootcamp
//
//  Created by Atul Khatri on 22/03/21.
//

import Foundation

extension String {
    var toUrl: URL? {
        return URL(string: self)
    }
}
