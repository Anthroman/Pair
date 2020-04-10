//
//  NameController.swift
//  Name Randomizer Assessment
//
//  Created by Anthroman on 4/10/20.
//  Copyright © 2020 Anthroman. All rights reserved.
//

import Foundation

class NameController {
    
    //MARK: - Singleton and Source of Truth
    static var sharedInstance = NameController()
    var names: [String] = []
    
    //MARK: - Initializer
    
    init() {
        loadFromPersistence()
    }
    
    //MARK: - CRUD Functions
    
    func createName(name: String) {
        names.append(name)
        saveToPersistentStorage(names: names)
    }
    
    func deleteName(name: String) {
        guard let index = names.firstIndex(of: name) else {return}
        names.remove(at: index)
        saveToPersistentStorage(names: names)
    }
    
    func shuffleNames() {
        var shuffledNames: [String] = []
        shuffledNames = names.shuffled()
        names = shuffledNames
    }
    
    //MARK: - Persistence
    func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "Randomizer.json"
        let documentDirectory = urls[0]
        let documentsDirectoryURL = documentDirectory.appendingPathComponent(fileName)
        return documentsDirectoryURL
    }
    
    func saveToPersistentStorage(names: [String]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(names)
            try data.write(to: fileURL())
        } catch let error {
            print("There was an error saving to persistent storage: \(error)")
        }
    }
    
    func loadFromPersistence() {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let decodedData = try jsonDecoder.decode([String].self, from: data)
            self.names = decodedData
        } catch let error {
            print("\(error.localizedDescription) -> \(error)")
        }
    }
}
