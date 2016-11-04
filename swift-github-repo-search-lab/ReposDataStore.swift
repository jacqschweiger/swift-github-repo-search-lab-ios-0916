//
//  FISReposDataStore.swift
//  github-repo-list-swift
//
//  Created by  susan lovaglio on 10/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    //all the data!
    
    static let sharedInstance = ReposDataStore()
    
    private init() {}
    
    var repositories: [GithubRepository]!
    
    func getRepositoriesFromAPI(completion: @escaping ()->()) {
        
        repositories = []
        
        GithubAPIClient.getRepositories { (repos) in
            for repo in repos {
                let newRepo = GithubRepository(dictionary: repo)
                self.repositories.append(newRepo)
            }
            completion()
        }
    }
    
    
    func toggleStarStatus(for fullName: String, starred:@escaping (Bool)->()){
        
        GithubAPIClient.checkIfRepositoryIsStarred(fullName: fullName) { (isStarred) in
            if isStarred {
                GithubAPIClient.unstarRepository(fullName: fullName, completion: { (success) in
                    starred(false)
                })
                
            }  else {
                GithubAPIClient.starRepository(fullName: fullName, completion: { (success) in
                    starred(true)
                })
            }
        }
    }
    
    func getSearchResultsfromAPI(userInput: String, completion: @escaping ()->()) {
        print("getSearchResults called")
        
        GithubAPIClient.getSearchResults(userInput: userInput) { (responseJSON) in
            print("responseJSON[items]: \(responseJSON["items"]!)")
            
            self.repositories.removeAll()
            
            let itemsDict = responseJSON["items"]
            guard let unwrappedItemsDict = itemsDict as? [[String: Any]] else { return }
            
            for dict in unwrappedItemsDict {
                let newDict = GithubRepository(dictionary: dict)
                self.repositories.append(newDict)
            }
            completion()
            print(self.repositories.count)
        }
    }
}


