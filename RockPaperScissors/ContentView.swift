//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Nitish on 3/10/25.
//

import SwiftUI

enum GameMove: CaseIterable {
	case rock, paper, scissors
}

enum UserGoal: CaseIterable {
	case Win, Lose
}

func getGameMoveEmoji(gameMove: GameMove) -> String {
	switch gameMove {
	case .rock:
		return "🪨"
	case .paper:
		return "📜"
	case .scissors:
		return "✂️"
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
	@State private var currentRound = 1 {
		willSet {
			if (newValue == 11) {
				currentRound = 10
				isEndGameAlertVisible = true
			}
		}
	}
	@State private var goal: UserGoal = UserGoal.allCases.randomElement()!
	@State private var score = 0
	@State private var isEndGameAlertVisible = false

	func advanceRound(userGameMove: GameMove) {
		let isUserCorrect = checkAnswer(answer: userGameMove)

		if isUserCorrect {
			score += 1
		} else {
			score -= 1
		}

		currentMove = GameMove.allCases.randomElement()!
		goal = UserGoal.allCases.randomElement()!
		currentRound += 1

	}

	func checkAnswer(answer userGameMove: GameMove) -> Bool {
		switch currentMove {
		case .rock:
			return goal == .Win ? userGameMove == .paper : userGameMove == .scissors
		case .paper:
			return goal == .Win ? userGameMove == .scissors : userGameMove == .rock
		case .scissors:
			return goal == .Win ? userGameMove == .rock : userGameMove == .paper
		
		}
	}

	var body: some View {
		NavigationStack {
			VStack {
				Spacer()
				Spacer()
				Text(getGameMoveEmoji(gameMove: currentMove))
					.font(.system(size: 64))
				Spacer()
				Divider().padding()
				Spacer()
				HStack(spacing: 24) {
					Button(getGameMoveEmoji(gameMove: .rock)) {
						advanceRound(userGameMove: .rock)
					}
					.buttonStyle(GameMoveButton())
					Button(getGameMoveEmoji(gameMove: .paper)) {
						advanceRound(userGameMove: .paper)
					}
					.buttonStyle(GameMoveButton())
					Button(getGameMoveEmoji(gameMove: .scissors)) {
						advanceRound(userGameMove: .scissors)
					}
					.buttonStyle(GameMoveButton())
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
