//
//  AspectVGrid.swift
//  Memorize
//
//  Created by Julian Miño on 24/09/2023.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    var items: [Item]
    var aspectRatio: CGFloat = 1
    var content: (Item) -> ItemView
    
    init(with items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let gridItemSize = gridItemWidthThatFits(count: items.count,
                                                     size: geometry.size,
                                                     aspectRatio: aspectRatio)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                ForEach(items) { item in
                    content(item)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }
    
    private func gridItemWidthThatFits(count: Int, size: CGSize, aspectRatio: CGFloat) -> CGFloat {
        let count = CGFloat(count)
        var columnsCount = 1.0
        repeat {
            let width = size.width / columnsCount
            let height = width / aspectRatio
            
            let rowCount = (count / columnsCount).rounded(.up)
            if rowCount * height < size.height {
                return (size.width / columnsCount).rounded(.down)
            }
            columnsCount += 1
        } while columnsCount < count
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
}
