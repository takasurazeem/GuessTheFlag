//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Takasur Azeem on 19/02/2022.
//

import SwiftUI

struct FlagImage: View {
    let flagName: String
    
    var body: some View {
        Image(flagName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    let maxNumberOfQuestions = 8
    @State private var showingScore = false
    @State private var scroreTitle = ""
    @State private var score = 0
    @State private var lastClicked = 0
    @State private var numberOfQuestionsAsked = 0
    @State private var showEndGameAlert = false
    
    @State private var countries = ["Pakistan", "Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    
    @State private var animationAmount = 0.0
    @State private var opacity = 1.0
    @State private var scaleAmount = 1.0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [Gradient.Stop(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3), .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(flagName: countries[number])
                                .rotation3DEffect(.degrees(number == lastClicked ? animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                                .opacity(number == lastClicked ? 1.0 : opacity)
                                .scaleEffect(number == lastClicked ? 1.0 : scaleAmount)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
            
        }
        .alert(scroreTitle, isPresented: $showingScore) {
            Button("Continue") {
                askQuestion()
            }
        } message: {
            Text("You clicked flag of \(countries[lastClicked]).\nScore penalty -1")
            
        }
        .alert("Your final score is \(score)/\(maxNumberOfQuestions)", isPresented: $showEndGameAlert) {
            Button("Reset") {
                resetGame()
            }
        }
    }
    
    func resetGame() {
        score = 0
        lastClicked = 0
        numberOfQuestionsAsked = 0
    }
    
    func flagTapped(_ number: Int) {
        lastClicked = number
        withAnimation(.linear(duration: 0.5)) {
            animationAmount += 360
            opacity = 0.25
            scaleAmount = 0.75
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            opacity = 1.0
            scaleAmount = 1.0
            if number == correctAnswer {
                scroreTitle = "Correct"
                score += 1
                askQuestion()
            } else {
                showingScore = true
                scroreTitle = "Wrong"
                score -= 1
            }
        }
    }
    
    func askQuestion() {
        correctAnswer = Int.random(in: 0...2)
        countries.shuffle()
        numberOfQuestionsAsked += 1
        if numberOfQuestionsAsked == 8 {
            showEndGameAlert = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
