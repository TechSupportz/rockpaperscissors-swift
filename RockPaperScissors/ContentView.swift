//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Nitish on 3/10/25.
//

import SwiftUI

enum GameMove: CaseIterable {
	case rock, paper, scissors

	var emoji: String {
		switch self {
		case .rock: return "🪨"
		case .paper: return "📜"
		case .scissors: return "✂️"
		}
	}
}

enum UserGoal: CaseIterable, CustomStringConvertible {
	case win, lose

	var description: String {
		switch self {
		case .win: return "Win"
		case .lose: return "Lose"
		}
	}
}

struct GameMoveButton: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.font(.system(size: 48))
			.padding()
			.background(.blue.opacity(configuration.isPressed ? 0.3 : 0.2))
			.clipShape(.rect(cornerRadius: 8))
	}
}

struct ContentView: View {
	@State private var currentMove: GameMove = GameMove.allCases.randomElement()!
	@State private var currentRound = 1
	@State private var goal: UserGoal = UserGoal.allCases.randomElement()!
	@State private var score = 0
	@State private var isEndGameAlertVisible = false

	func advanceRound(userGameMove: GameMove) {
		let isUserCorrect = checkAnswer(answer: userGameMove)
		score += isUserCorrect ? 1 : -1

		if currentRound == 10 {
			isEndGameAlertVisible = true
			return
		}

		currentMove = GameMove.allCases.randomElement()!
		goal = UserGoal.allCases.randomElement()!
		currentRound += 1

	}

	func checkAnswer(answer userGameMove: GameMove) -> Bool {
		switch (currentMove, goal) {
		case (.rock, .win): return userGameMove == .paper
		case (.rock, .lose): return userGameMove == .scissors
		case (.paper, .win): return userGameMove == .scissors
		case (.paper, .lose): return userGameMove == .rock
		case (.scissors, .win): return userGameMove == .rock
		case (.scissors, .lose): return userGameMove == .paper
		}
	}

	var body: some View {
		NavigationStack {
			VStack {
				Spacer()
				Spacer()
				Text(currentMove.emoji)
					.font(.system(size: 64))
				Spacer()
				Divider().padding()
				Spacer()
				HStack(spacing: 24) {
					ForEach(GameMove.allCases, id: \.self) { move in
						Button(move.emoji) {
							advanceRound(userGameMove: move)
						}
						.buttonStyle(GameMoveButton())
					}
				}
				Spacer()
				Spacer()
				Text("Goal: \(goal)")
					.font(.largeTitle.bold().monospaced())
					.padding()

			}
			.navigationTitle("Round \(currentRound >= 10 ? 10 : currentRound)")
			.alert("You have scored: \(score) / 10", isPresented: $isEndGameAlertVisible) {
				Button("Try again!") {
					currentRound = 1
					currentMove = GameMove.allCases.randomElement()!
					goal = UserGoal.allCases.randomElement()!
					score = 0
				}
			}
		}
	}
}

#Preview {
	ContentView()
}
