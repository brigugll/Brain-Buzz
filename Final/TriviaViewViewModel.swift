//
//  DetailViewModel.swift
//  Final
//
//  Created by Luke Briguglio on 4/24/23.
//

import Foundation


@MainActor
class TriviaViewViewModel: ObservableObject {
    
    private struct Returned: Codable {
        var results: [Result]
    }
    
    struct Result: Codable, Hashable {
        var question: String
        var correct_answer: String
        var incorrect_answers: [String]
        var all_answers: [String] {
            return [correct_answer] + incorrect_answers
        }
    }
    
    var urlString = "https://opentdb.com/api.php?amount=30&category=9&difficulty=easy&type=multiple"
    
    @Published var questions: [Result] = []
    @Published var currentQuestionIndex = 0
    @Published var isCorrect = false
    @Published var score = 0
    @Published var isGameOver = false
    
    func getData() async {
        print("We are accessing the url \(urlString)")
        
        //Create a URL
        guard let url = URL(string: urlString) else {
            print("Error: Could not create a URL from\(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let returned = try JSONDecoder().decode(Returned.self, from: data)
            self.questions = returned.results
            print("First question: \(questions.first?.question ?? "No questions found")")
            
        } catch {
            print("Error: Could not use URL at \(urlString)")
        }
    }
    
    func returnfunc() {
        currentQuestionIndex = 0
        isCorrect = false
        score = 0
        isGameOver = false
    }
    
    func removingHTMLEntities(from string: String) -> String {
        var result = string
        
        let entities = [
            "&quot;Llanfair&shy;pwllgwyngyll&shy;gogery&shy;chwyrn&shy;drobwll&shy;llan&shy;tysilio&shy;gogo&shy;goch&quot;" : "Llanfairpwll railway station",
            "&oacute" : "í",
            "&quot;" : "\"",
            "&amp;" : "&",
            "&lt;"  : "<",
            "&gt;"  : ">",
            "&nbsp;": " ",
            "&shy;": "",
            "&ndash;": "-",
            "&mdash;": "--",
            "&lsquo;": "'",
            "&#039;": "'",
            "&rsquo;": "'",
            "&sbquo;": "'",
            "&ldquo;": "\"",
            "&rdquo;": "\"",
            "&bdquo;": "\"",
            "&laquo;": "<<",
            "&raquo;": ">>",
            "&lsaquo;": "<",
            "&rsaquo;": ">",
            "&hellip;": "...",
            "&oline;": "",
            "&frasl;": "/",
            "&infin;": "∞",
            "&deg;": "°",
            "&plusmn;": "±",
            "&times;": "×",
            "&divide;": "÷",
            "&micro;": "μ",
            "&alpha;": "α",
            "&beta;": "β",
            "&gamma;": "γ",
            "&delta;": "δ",
            "&epsilon;": "ε",
            "&theta;": "θ",
            "&lambda;": "λ",
            "&mu;": "μ",
            "&pi;": "π",
            "&sigma;": "σ",
            "&omega;": "ω"
        ]
        
        for (entity, character) in entities {
            result = result.replacingOccurrences(of: entity, with: character)
        }
        
        return result
    }
    
    
}


