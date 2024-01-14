//
//  MemoryGame.swift
//  Memorize
//
//  Created by Julian Miño on 20/09/2023.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    private(set) var score = 0
     
    private var indexOfSelectedCard: Int? {
        get { cards.indices.filter { index in cards[index].isFaceUp }.only }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            cards.append(Card(content: cardContentFactory(pairIndex), id: "\(pairIndex+1)a"))
            cards.append(Card(content: cardContentFactory(pairIndex), id: "\(pairIndex+1)b"))
        }
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex = cards.firstIndex(of: card) {
            if !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
                if let potentialMatchingCardIndex = indexOfSelectedCard {
                    checkMatch(for: chosenIndex, and: potentialMatchingCardIndex)
                }
                else {
                    indexOfSelectedCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func restart() {
        score = 0
        cards.indices.forEach { index in
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
    }
    
    mutating func checkMatch(for firstIndex: Int, and secondIndex: Int) {
        if cards[firstIndex].content == cards[secondIndex].content {
            cards[firstIndex].isMatched = true
            cards[secondIndex].isMatched = true
            score += 2 + cards[firstIndex].bonus + cards[secondIndex].bonus
        }
        else {
            if cards[firstIndex].hasBeenSeen || cards[secondIndex].hasBeenSeen {
                score -= 1
            }
        }
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var debugDescription: String {
            return "\(id) with FaceUp set to \(isFaceUp), Matched set to \(isMatched) and content \(content)"
        }
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
                if oldValue && !isFaceUp {
                    hasBeenSeen = true
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        var hasBeenSeen: Bool = false
        let content: CardContent
        
        // MARK: - Bonus time
        
        private mutating func startUsingBonusTime() {
            if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }
        
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
        }
        
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        var bonusTimeLimit: TimeInterval = 6
        
        var lastFaceUpDate: Date?
        
        var pastFaceUpTime: TimeInterval = 0
        
        let id: String
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
