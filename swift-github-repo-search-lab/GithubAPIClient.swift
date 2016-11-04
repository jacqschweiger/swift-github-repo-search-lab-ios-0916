//
//  FISGithubAPIClient.swift
//  github-repo-list-swift
//
//  Created by  susan lovaglio on 10/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire

class GithubAPIClient {
    //talks to the API
    
    
    class func getRepositories(with completion: @escaping ([[String:AnyObject]])-> Void) {
        let urlString = "https://api.github.com/repositories?client_id=\(clientID)&client_secret=\(clientSecret)"
        
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        if let unwrappedURL = url {
            let task = session.dataTask(with: unwrappedURL) { (data, response, error) in
                if let unwrappedData = data {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! [[String: AnyObject]]
                        completion(responseJSON)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    
    class func checkIfRepositoryIsStarred(fullName: String, completion: @escaping (Bool) -> ()) {
        print("checkIfRepositoryIsStarred called")
        var isStarred = false
        
        let urlString = "\(githubAPIURL)/user/starred/\(fullName)?client_id=\(clientID)&client_secret=\(clientSecret)&access_token=\(personalAccessToken)"
        
        let url = URL(string: urlString)
        
        guard let unwrappedURL = url else { return }
        let request = URLRequest(url: unwrappedURL)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            let httpResponse = response as! HTTPURLResponse
            
            if httpResponse.statusCode == 204 {
                isStarred = true
            } else if httpResponse.statusCode == 404 {
                isStarred = false
            }
            
            completion(isStarred)
        }
        task.resume()
        
    }
    
    
    
    
    
    class func starRepository(fullName: String, completion: @escaping (Bool)->()) {
        
        let urlString = "\(githubAPIURL)/user/starred/\(fullName)?client_id=\(clientID)&client_secret=\(clientSecret)&access_token=\(personalAccessToken)"
        let url = URL(string: urlString)
        
        
        Alamofire.request(url!, method: .put).responseJSON { response in
            
            print("alamofire running")
            
            if let JSON = response.result.value {
                
                let statusCode = response.response?.statusCode
                
                if statusCode == 204 {
                    completion(true)
                } else if statusCode == 404 {
                    completion(false)
                }
                
            }
            
        }
    }
    
    
    
    //        let urlString = "\(githubAPIURL)/user/starred/\(fullName)?client_id=\(clientID)&client_secret=\(clientSecret)&access_token=\(personalAccessToken)"
    //        let url = URL(string: urlString)
    //
    //        guard let unwrappedURL = url else { return }
    //        var request = URLRequest(url: unwrappedURL)
    //        request.httpMethod = "PUT"
    //        request.addValue("0", forHTTPHeaderField: "Content-Length")
    //        let session = URLSession.shared
    //
    //        let task = session.dataTask(with: request) { (data, response, error) in
    //            let httpResponse = response as! HTTPURLResponse
    //            let statusCode = httpResponse.statusCode
    //            print("Status code is \(statusCode)")
    //
    //            if statusCode == 204 {
    //                completion(true)
    //            } else if statusCode == 404 {
    //                completion(false)
    //            }
    //        }
    //        task.resume()
    //    }
    
    
    
    
    class func unstarRepository(fullName: String, completion: @escaping (Bool)->()) {
        
        let urlString = "\(githubAPIURL)/user/starred/\(fullName)?client_id=\(clientID)&client_secret=\(clientSecret)&access_token=\(personalAccessToken)"
        let url = URL(string: urlString)
        
        
        Alamofire.request(url!, method: .delete).responseJSON { response in
            
            print("alamofire running")
            
            if let JSON = response.result.value {
                
                let statusCode = response.response?.statusCode
                
                if statusCode == 204 {
                    completion(true)
                } else if statusCode == 404 {
                    completion(false)
                }
                
            }
            
        }
        
        
        
        
        
        
        //        let urlString = "\(githubAPIURL)/user/starred/\(fullName)?client_id=\(clientID)&client_secret=\(clientSecret)&access_token=\(personalAccessToken)"
        //        let url = URL(string: urlString)
        //
        //        guard let unwrappedURL = url else { return }
        //        var request = URLRequest(url: unwrappedURL)
        //        request.httpMethod = "DELETE"
        //        request.addValue("0", forHTTPHeaderField: "Content-Length")
        //        let session = URLSession.shared
        //        let task = session.dataTask(with: request) { (data, response, error) in
        //            let httpresponse = response as! HTTPURLResponse
        //            if httpresponse.statusCode == 204 {
        //                completion(true)
        //            } else if httpresponse.statusCode == 404 {
        //                completion(false)
        //            }
        //        }
        //        task.resume()
        
    }
    
    
    class func getSearchResults(userInput: String, completion: @escaping ([String:AnyObject]) -> ()) {
        
        let urlString = "\(githubAPIURL)/search/repositories?q=\(userInput)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { return }
        
        let task = session.dataTask(with: unwrappedURL) { (data, response, error) in
            if let unwrappedData = data {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! [String: AnyObject]
                    completion(responseJSON)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
}


