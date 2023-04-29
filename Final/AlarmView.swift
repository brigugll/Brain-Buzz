//
//  AlarmView.swift
//  Final
//
//  Created by Luke Briguglio on 4/29/23.
//

import SwiftUI
import AVFAudio

struct AlarmView: View {
    @StateObject var viewModel = AlarmViewViewModel()
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        NavigationView {
            VStack {
                if !viewModel.alarm.reached && viewModel.alarm.timeDifference == "" {
                    Text("SET YOUR TIME")
                        .font(.custom("Menlo", size: 60))
                        .bold()
                        .multilineTextAlignment(.center)

                    DatePicker("", selection: $viewModel.alarm.time, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(.wheel)

                    Button("Set Alarm") {
                        viewModel.setAlarm()
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Spacer()

                    NavigationStack {
                        Spacer()

                        if viewModel.alarm.reached {
                            Text("ALARM REACHED")
                                .font(.custom("Menlo", size: 60))
                                .bold()
                                .multilineTextAlignment(.center)
                            
                            NavigationLink {
                                TriviaView()
                            } label: {
                                Text("Turn Off")
                            }

                        } else {
                            Text(viewModel.alarm.timeDifference)
                                .font(.custom("Menlo", size: 60))
                                .bold()
                                .multilineTextAlignment(.center)
                        }

                        Spacer()
                    }
                    .onTapGesture {
                        viewModel.turnOffAlarm()
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmView()
    }
}


