//
//  groupBy.swift
//  ARC
//
//  Created by David Morrison on 21/10/2015.
//  Copyright © 2015 David Morrison. All rights reserved.
//

/*

internal extension Array {

    func groupBy <U> (groupingFunction group: (Element) -> U) -> [U: Array] {
        
        var result = [U: Array]()
        
        for item in self {
            
            let groupKey = group(item)
            
            // If element has already been added to dictionary, append to it. If not, create one.
            // if result.has(groupKey) {
            if result.indexForKey(groupKey) != nil {
                result[groupKey]! += [item]
            } else {
                result[groupKey] = [item]
            }
        }
        
        return result
    }

}

*/