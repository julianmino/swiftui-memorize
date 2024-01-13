//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Julian Miño on 20/09/2023.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    private static let emojis: [String] = ["🎃", "👻", "🦇", "🕷️", "🕸️", "🧙‍♀️", "🧛‍♂️", "🧟‍♀️", "🌕", "🌑", "🌙", "🔥", "🍂", "🍁", "🍫"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: emojis.count) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                return "❓"
            }
        }
    }
        
    @Published private var model = createMemoryGame()

    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    var color: Color {
        .orange
    }
    
    var score: Int {
        model.score
    }
    
    // MARK: - Intents
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func shuffle() {
        model.shuffle()
    }
}
