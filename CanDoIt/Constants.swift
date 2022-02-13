//
//  Constants.swift
//  CanDoIt
//
//  Created by Роман Предеин on 11.02.2022.
//

import Foundation

struct K {
    static let entityName = "Task"
    static let persistentContainerName = "DataModel"
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy"
        return formatter
    }()
}
