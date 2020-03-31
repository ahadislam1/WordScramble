//
//  ContentView.swift
//  WordScramble
//
//  Created by Ahad Islam on 3/31/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import SwiftUI

struct ListExampleView: View {
    let people = ["Finn", "Leia", "Luke", "Rey"]
    
    var body: some View {
        List(people, id: \.self) {
            Text(($0))
        }
        .listStyle(GroupedListStyle())
    }
}

struct StringView: View {
    var body: some View {
        let word = "swift"
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let mispelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        let allGood = mispelledRange.location == NSNotFound
        
        
        if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
            if let fileContents = try? String(contentsOf: fileURL) {
                
            }
        }
        
        let input = "a\nb\nc"
        let letters = input.components(separatedBy: "\n")
        let letter = letters.randomElement()
        
        return Text("Hi")
    }
}

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                List(usedWords, id: \.self) {
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                }
            }
            .navigationBarTitle(rootWord.capitalized)
            .navigationBarItems(leading: Button(action: startGame) { Text("Hi")})
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {
            return
        }
        
        guard isOriginal(answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(answer) else {
            wordError(title: "Be real", message: "YOu cant make thme up")
            return
        }
        
        guard isRealWord(answer) else {
            wordError(title: "thats", message: "not a real word")
            return
        }
        
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWorlds = try? String(contentsOf: startWordsURL) {
                let allWords = startWorlds.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                
                return
            }
        }
        
        fatalError("Error occured finding URL")
    }
    
    func isOriginal(_ word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(_ word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isRealWord(_ word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
