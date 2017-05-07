//
//  ScoreTableViewController.swift
//  iosProject
//
//  Created by iosdev on 26.4.2017.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit
import CoreData

class ScoreTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var scores = [OneScore]()
    var appDelegate:AppDelegate!
    var yourUser:User!
    var you:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        loadScores()
        backgroundColor()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return scores.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Table view cells are reused and should be dequeued using a cell indetifier
        let cellIndetifier = "ScoreTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIndetifier, for: indexPath) as? ScoreTableViewCell else {
            fatalError("The dequeued cell is not an instance of ScoreTableViewCell")
        }
        
        // Fetches the appropriate score for the data source layut.
        let score = scores[indexPath.row]
        let backColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
        cell.backgroundColor = backColor
        cell.nameLabel.text = "\(self.yourUser.username!) - \(score.opponent) "
        cell.winStreak.text = String(score.win)
        cell.tieStreak.text = String(score.tie)
        cell.loseStreak.text = String(score.lose)
     return cell
     }

    private func loadScores() {
        print("It goes here")
        appDelegate.scoreHandler.you = appDelegate.scoreHandler.getYourself()
        appDelegate.scoreHandler.fetchYourself()
        self.yourUser = appDelegate.scoreHandler.yourUser!
        let fetchScore:NSFetchRequest<Score> = Score.fetchRequest()
        let youPredicate = NSPredicate(format: "user = %@", self.yourUser!)
        fetchScore.predicate = youPredicate
        
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchScore)
            if searchResults.count == 0 {
                print("You have no scores")
                // Prints only overall scores
                let yourScore = OneScore.init(you: self.yourUser.username!, opponent: "Overall Records", win: Int(self.yourUser.win), lose: Int(self.yourUser.lose), tie: Int(self.yourUser.tie))
                self.scores.append(yourScore)

            }
            else {
                let yourScore = OneScore.init(you: self.yourUser.username!, opponent: "Overall Records", win: Int(self.yourUser.win), lose: Int(self.yourUser.lose), tie: Int(self.yourUser.tie))
                self.scores.append(yourScore)
                for result in searchResults as [Score] {
                    print("Game opponent was \(result.player2!)")
                    let score = OneScore.init(you: result.user!.username!, opponent: result.player2!, win: Int(result.win), lose: Int(result.lose), tie: Int(result.tie))
                    self.scores.append(score)
                }
            }
        }
            
        catch {
            print("Error: \(error)")
        }

        
    }
    
    private func backgroundColor() {
    let backColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
    view.backgroundColor = backColor
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
}
