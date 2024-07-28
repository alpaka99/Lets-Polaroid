//
//  MBTI.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import Foundation

enum MBTIGroup: CaseIterable {
    case first
    case second
    case third
    case fourth
}

enum MBTIComponent: String, CaseIterable {
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
}


