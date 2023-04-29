
import SwiftUI
import AVFAudio


struct TriviaView: View {
    @StateObject var triviaViewModel = TriviaViewViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var currentQuestionIndex = 0
    @State private var isCorrect = false
    @State private var score = 0
    @State private var isGameOver = false
    @State private var turnOff = false
    @State private var isSoundPlaying = false
    @State private var audioPlayer: AVAudioPlayer!
    @State private var correctAudioPlayer: AVAudioPlayer!
    @State private var wrongAudioPlayer: AVAudioPlayer!
    
    
    var body: some View {
        
        NavigationView {
            
            
            if triviaViewModel.questions.isEmpty {
                ProgressView()
                
            } else {
                VStack {
                    
                    let q = triviaViewModel.questions[currentQuestionIndex].question
                    Text(triviaViewModel.removingHTMLEntities(from:q))
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding(.top, 32)
                        .padding(.horizontal, 16)
                        .lineLimit(nil)
                    
                    
                    Spacer()
                    VStack(spacing: 16) {
                        ForEach(triviaViewModel.questions[currentQuestionIndex].all_answers.shuffled(), id: \.self) { answer in
                            Button(action: {
                                print(currentQuestionIndex)
                                if triviaViewModel.removingHTMLEntities(from: answer) == triviaViewModel.questions[currentQuestionIndex].correct_answer {
                                    isCorrect = true
                                    score += 1
                                    playCorrect(soundName: "correct")
                                } else {
                                    if score > 0 {
                                        score -= 1
                                        playWrong(soundName: "wrong")
                                    } else {
                                        playWrong(soundName: "wrong")
                                    }
                                    isCorrect = false
                                }
                                if currentQuestionIndex + 1 < triviaViewModel.questions.count {
                                    currentQuestionIndex += 1
                                    if score >= 3 {
                                        turnOff = true
                                    }
                                } else {
                                    isGameOver = true
                                }
                            }, label: {
                                Text(triviaViewModel.removingHTMLEntities(from: answer))
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            })
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            
                        }
                        
                    }
                    Spacer()
                    
                    HStack{
                        Text("Score: \(score)")
                            .font(.title2)
                        Spacer()
                        
                    }
                    .padding()
                    
                    
                }
                .navigationBarTitle(Text("Score of 3 Turns of the Noise!"))
                .navigationBarTitleDisplayMode(.inline)
                
                
                .alert(isPresented: $turnOff) {
                    if score >= 3 || currentQuestionIndex >= 29 {
                        return Alert(
                            title: Text("ALARM OFF"),
                            message: Text("Have a great morning!"),
                            dismissButton: .default(Text("Click me "), action: {
                                triviaViewModel.questions.shuffle()
                                presentationMode.wrappedValue.dismiss()
                                triviaViewModel.returnfunc()
                                
                            })
                        )
                    } else {
                        return Alert(
                            title: Text("GAME OVER"),
                            message: Text("Sorry, you didn't get 3 questions right. Better luck next time!"),
                            dismissButton: .default(Text("Turn Off"), action: {
                                triviaViewModel.questions.shuffle()
                                triviaViewModel.returnfunc()
                            })
                        )
                    }
                }
            }
        }
        .task {
            await triviaViewModel.getData()
            if !isGameOver {
                playSound(soundName: "gameSound ")
            }
        }
    }

    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("error")
            return
        }
        do {
            if !isSoundPlaying {
                audioPlayer = try AVAudioPlayer(data: soundFile.data)
                audioPlayer.play()
                isSoundPlaying = true
            }
            if turnOff {
                audioPlayer.stop()
                isSoundPlaying = false
            }
        } catch {
            print("error")
        }
    }
    func playCorrect(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("error")
            return
        }
        do {
            correctAudioPlayer = try AVAudioPlayer(data: soundFile.data)
            correctAudioPlayer.play()
        } catch {
            print("error")
        }
    }
    func playWrong(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("error")
            return
        }
        do {
            
            wrongAudioPlayer = try AVAudioPlayer(data: soundFile.data)
            wrongAudioPlayer.play()
            
        } catch {
            print("error")
        }
    }
    
    
}

struct TriviaView_Previews: PreviewProvider {
    static var previews: some View {
        TriviaView()
    }
}

