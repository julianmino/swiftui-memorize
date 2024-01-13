//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Julian Miño on 12/09/2023.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    typealias Card = MemoryGame<String>.Card
    
    @ObservedObject var viewModel: EmojiMemoryGame
    private let aspectRatio: CGFloat = 2/3
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Memorize!")
                .font(.largeTitle.bold())
            cards
                .foregroundColor(viewModel.color)
            HStack {
                score
                Spacer()
                deck
                Spacer()
                shuffle
            }
            .font(.title)
        }
        .padding()
    }
    
    var cards: some View {
        AspectVGrid(with: viewModel.cards, aspectRatio: aspectRatio) { card in
            if isDealt(card) {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .aspectRatio(aspectRatio, contentMode: .fit)
                    .padding(2)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 100 : 0)
                    .onTapGesture {
                        choose(card)
                    }
            }
        }
    }
    
    @State private var dealt: Set<Card.ID> = []
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter { !self.isDealt($0) }
    }
    
    @Namespace private var dealingNamespace
    
    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        .onTapGesture {
            deal()
        }
    }
    
    private let deckWidth: CGFloat = 50
     
    private func deal() {
        var delay: TimeInterval = 0
        for card in viewModel.cards {
            withAnimation(.easeInOut(duration: 0.5).delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += 0.05
        }
    }
    
    private func choose(_ card: Card) {
        withAnimation {
            let scoreBeforeChoosing = viewModel.score
            viewModel.choose(card: card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }
    
    var score: some View {
        Text("Score: \(viewModel.score)")
            .animation(nil)
    }
    
    var shuffle: some View {
        Button("Shuffle", action: {
            withAnimation {
                viewModel.shuffle()
            }
        })
    }
    
    @State private var lastScoreChange = (0, causedByCardId: "")
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, id) = lastScoreChange
        return card.id == id ? amount : 0
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
