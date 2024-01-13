//
//  CardView.swift
//  Memorize
//
//  Created by Julian Miño on 31/10/2023.
//

import SwiftUI

struct CardView: View {
    typealias Card = MemoryGame<String>.Card
    
    let card: Card
    
    var body: some View {
        TimelineView(.animation) { timeline in
            if card.isFaceUp || !card.isMatched {
                Pie(endAngle: .degrees(card.bonusPercentRemaining * 360))
                    .opacity(Constants.Pie.opacity)
                    .overlay {
                        cardContents
                            .padding(Constants.Pie.inset)
                    }
                    .padding(Constants.inset)
                    .cardify(isFaceUp: card.isFaceUp)
                    .transition(.scale)
            } else {
                Color.clear
            }
        }
        
    }
    
    private var cardContents: some View {
        Text(card.content)
            .font(.system(size: Constants.FontSize.largest))
            .minimumScaleFactor(Constants.FontSize.scaleFactor)
            .multilineTextAlignment(.center)
            .aspectRatio(1, contentMode: .fit)
            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: card.isMatched)
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
        static let inset: CGFloat = 5
        
        struct FontSize {
            static let smallest: CGFloat = 10
            static let largest: CGFloat = 200
            static let scaleFactor = smallest / largest
        }
        
        struct Pie {
            static let opacity: CGFloat = 0.4  
            static let inset: CGFloat = 5
        }
    }
}

struct CardView_Previews: PreviewProvider {
    typealias Card = CardView.Card
    
    static var previews: some View {
        VStack {
            HStack {
                CardView(card:Card(content: "X", id: "test1"))
                CardView(card:Card(content: "X", id: "test1"))
                CardView(card:Card(content: "X", id: "test1"))
            }
            HStack {
                CardView(card:Card(isFaceUp: true, content: "X", id: "test1"))
                CardView(card:Card(content: "X", id: "test1"))
                CardView(card:Card(content: "X", id: "test1"))
            }
        }
        .padding()
    }
}
