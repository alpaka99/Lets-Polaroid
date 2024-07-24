//
//  UICollectionViewLayout+.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import UIKit

extension UICollectionViewLayout {
    static func createLayout(rows: CGFloat, columns: CGFloat, spacing: CGFloat, direction: Direction) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/columns), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/rows))
        let group = switch direction {
        case .horizontal:
            NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        case .vertical:
            NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        }
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    static func createLayout(absoluteRowHeight: CGFloat, columns: CGFloat, spacing: CGFloat, direction: Direction) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/columns), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(absoluteRowHeight))
        let group = switch direction {
        case .horizontal:
            NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        case .vertical:
            NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        }
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

enum Direction {
    case horizontal
    case vertical
}
