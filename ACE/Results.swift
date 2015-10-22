//
//  File.swift
//  ARC
//
//  Created by David Morrison on 22/10/2015.
//  Copyright © 2015 David Morrison. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
    func toArray() -> [Results.Generator.Element] {
        return map { $0 }
    }
}