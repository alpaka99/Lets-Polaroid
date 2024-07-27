//
//  TopicType.swift
//  MySplashed
//
//  Created by user on 7/26/24.
//

enum TopicType: String, CaseIterable {
    case goldenHour = "golden-hour"
    case business = "business-work"
    case architecture = "architecture-interior"
    
    static func sectionNumberInit(_ sectionNumber: Int) -> Self? {
        switch sectionNumber {
        case 0:
            return .goldenHour
        case 1:
            return .business
        case 2:
            return .architecture
        default:
            return nil
        }
    }
}
