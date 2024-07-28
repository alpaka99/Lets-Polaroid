//
//  MBTI.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import Foundation

enum MBTIGroup: CaseIterable, Codable {
    case first
    case second
    case third
    case fourth
}

enum MBTIComponent: String, CaseIterable, Codable {
    case e
    case i
    case s
    case n
    case t
    case f
    case j
    case p
    
    static func initialMBTI() -> [MBTIGroup : MBTIComponent?] {
        var mbti = [MBTIGroup:MBTIComponent]()
        MBTIGroup.allCases.forEach { group in
            mbti[group] = nil
        }
        return mbti
    }
    
    var group: MBTIGroup {
        switch self {
        case .e, .i:
            return .first
        case .s, .n:
            return .second
        case .t, .f:
            return .third
        case .j, .p:
            return .fourth
        }
    }
    
    var index: Int {
        switch self {
        case .e:
            return 0
        case .i:
            return 1
        case .s:
            return 2
        case .n:
            return 3
        case .t:
            return 4
        case .f:
            return 5
        case .j:
            return 6
        case .p:
            return 7
        }
    }
}



struct MBTIData: Hashable {
    let mbtiComponent: MBTIComponent
    var isSelected: Bool
}
