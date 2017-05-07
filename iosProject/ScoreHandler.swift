//
//  ScoreHandler.swift
//  iosProject
//
//  Created by iosdev on 2.5.2017.
//  Copyright © 2017 iosdev. All rights reserved.
//

import Foundation
import CoreData

class ScoreHandler {
    
    //helper variables
    var you: String?
    var opponent: String?
    var result: String?
    
    // User with right user from database
    var yourUser:User?
    
    //let userClassName:String = String(describing: User.self)
    let scoreClassName:String = String(describing: Score.self)
    
    // Gets opponent from the game
    func getOpponent(name: String) {
        print(name)
    }
    
    // Gets your user from the userdefaults when logged and if not then it says that you use guest account
    func getYourself() -> String {
        let check = UserDefaults.standard.bool(forKey: "LoggedIn")
        
        if check == true {
            let you:String = UserDefaults.standard.object(forKey: "User") as! String
            return you
        }
        else {
            return "Guest"
        }
    }
    
    // Gets userdata from the database with your own username
    func fetchYourself() {
        let fetchYou:NSFetchRequest<User> = User.fetchRequest()
        
        let userPredicate = NSPredicate(format: "username = %@", self.you!)
        fetchYou.predicate = userPredicate
        
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchYou)
            if searchResults.count == 0 {
                
            }
            else {
                for result in searchResults as [User] {
                    self.yourUser = result
                }
            }
        }
        
        catch {
            print("Error: \(error)")
        }

    }
    // Gets result win lose or tie and adds information to helper variables
    func getResultsFromGame(name:String, res:String) {
        self.you = getYourself()
        self.opponent = name
        self.result = res
        
        if self.you == "Guest" {
            print("Guest account doesn't do anything in here")
        }
        else {
            fetchYourself()
            print("Fetch was success \(self.yourUser!.username!)")
            
            let fetchScore:NSFetchRequest<Score> = Score.fetchRequest()
            let oppPredicate = NSPredicate(format: "player2 = %@", self.opponent!)
            fetchScore.predicate = oppPredicate
            do {
                let searchResults = try DatabaseController.getContext().fetch(fetchScore)
                if searchResults.count == 0 {
                    // TODO: Create new object to database
                    print("Creates new Gameresult")
                    print("Result of the game was \(self.result!) and opponent was \(self.opponent!)")
                    let scores:Score = NSEntityDescription.insertNewObject(forEntityName: self.scoreClassName, into: DatabaseController.getContext()) as! Score
                    scores.player2 = self.opponent!
                    
                    if result == "Tie" {
                        print("It adds tie")
                        scores.tie = 1
                        scores.lose = 0
                        scores.win = 0
                        yourUser!.tie = yourUser!.tie + 1
                    }
                    else if result == "Win" {
                        print("It adds Win")
                        scores.lose = 0
                        scores.win = 1
                        scores.tie = 0
                        yourUser!.win = yourUser!.win + 1
                    }
                    else if result == "Lose" {
                        print("It adds Lose")
                        scores.lose = 1
                        scores.win = 0
                        scores.tie = 0
                        yourUser!.lose = yourUser!.lose + 1
                    }
                    else {
                        print("It doesn't work as it should be")
                    }
                    
                    self.yourUser?.addToUser(scores)
                    
                }
                else {
                    //Updates existing gameResult
                    for answer in searchResults as [Score] {
                    
                        if result == "Tie" {
                            print("It adds tie")
                            answer.tie = answer.tie + 1
                            yourUser!.tie = yourUser!.tie + 1
                        }
                        else if result == "Win" {
                            print("It adds Win")
                            answer.win = answer.win + 1
                            yourUser!.win = yourUser!.win + 1
                        }
                        else if result == "Lose" {
                            print("It adds Lose")
                            answer.lose = answer.lose + 1
                            yourUser!.lose = yourUser!.lose + 1
                        }
                        else {
                            print("It doesn't work as it should be")
                        }
                        print("Username from the object is \(answer.player2!) and \(answer.user!.username!) your results Ties: \(answer.tie) Loses: \(answer.lose) Wins: \(answer.win)")
                    }
                }
                
                print("Overall scores are Ties: \(yourUser!.tie) Wins: \(yourUser!.win) Loses: \(yourUser!.lose)")
                DatabaseController.saveContext()
            }
            catch {
                print("Error: \(error)")
            }
        }
        
        
    }
    
//    func getPlayerScores() {
//        
//        self.you = getYourself()
//        self.fetchYourself()
//        
//        let fetchScore:NSFetchRequest<Score> = Score.fetchRequest()
//        let youPredicate = NSPredicate(format: "user = %@", self.yourUser!)
//        fetchScore.predicate = youPredicate
//        
//        do {
//            let searchResults = try DatabaseController.getContext().fetch(fetchScore)
//            if searchResults.count == 0 {
//                print("You have no scores")
//                // Prints only overall scores
//            }
//            else {
//                for result in searchResults as [Score] {
//                    print("Game opponent was \(result.player2!)")
//                }
//            }
//        }
//            
//        catch {
//            print("Error: \(error)")
//        }
//
    
        
        
  //  }
    
   
    
    
}
