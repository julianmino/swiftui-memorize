//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Julian Miño on 12/09/2023.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var memoryGame = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: memoryGame)
        }
    }
}
