//
//  RSPViewController.swift
//  iosProject
//
//  Created by iosdev on 23.4.2017.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class RSPViewController: UIViewController, MCBrowserViewControllerDelegate {

    //Call for appDelegate.swift
    var appDelegate:AppDelegate!
    
    //Check if you can choose 
    var turnCheck:Bool = true
    var readyCheck:Bool = false
    var yours:String!
    var opponent:String!
    var opponentName:String!
    @IBOutlet weak var displayChoiceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor()
        
        //Init for appdelegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        // Sets peer name with phones own device name
        appDelegate.mpcHandler.setupPeerWithDisplayName(displayName: UIDevice.current.name)
        
        // Calls session
        appDelegate.mpcHandler.setupSession()
        
        //shows your own device name to others
        appDelegate.mpcHandler.advertiseSelf(advertise: true)
        
        //Starts listen notification for bluetooth connection
        NotificationCenter.default.addObserver(self, selector: #selector(TicTacToeViewController.peerChangedStateWithNotification), name:  NSNotification.Name(rawValue: "MPC_DidChangeStateNotification"), object: nil)
        //Starts listen notification for receiving data from other player
        NotificationCenter.default.addObserver(self, selector: #selector(TicTacToeViewController.handleReceivedDataWithNotification), name: NSNotification.Name(rawValue: "MPC_DidReceiveDataNotification") , object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func backgroundColor() {
        let backColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
        view.backgroundColor = backColor
    }
    
    @IBAction func RockButton(_ sender: UITapGestureRecognizer) {
        //Checks that if player is connected
        if appDelegate.mpcHandler.session.connectedPeers.count != 0 {
            self.displayChoiceLabel.text = "You chose Rock"
        }
        self.yourChoice(name: "rock")
        
        
    }
    
    @IBAction func PaperButton(_ sender: UITapGestureRecognizer) {
        //Checks that if player is connected
        if appDelegate.mpcHandler.session.connectedPeers.count != 0 {
            self.displayChoiceLabel.text = "You chose Paper"
        }
        self.yourChoice(name: "paper")
    }
    
    @IBAction func ScissorsButton(_ sender: UITapGestureRecognizer) {
        //Checks that if player is connected
        if appDelegate.mpcHandler.session.connectedPeers.count != 0 {
            self.displayChoiceLabel.text = "You chose Scissors"
        }
        self.yourChoice(name: "scissors")
    }
    
    func yourChoice(name: String) {
        print("it goes here")
        //Checks that if player is connected
        if appDelegate.mpcHandler.session.connectedPeers.count == 0 {
            print("This is the problem")
            let alert = UIAlertController(title: "Error", message: "You must connect before playing", preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            //Sets players choice and sends notification to other player
        else if self.turnCheck == true {
            self.yours = name
            let op = appDelegate.scoreHandler.getYourself()
            let messageDict = ["choice":name, "opponent": op ] as [String : Any]
        
            let messageData = try? JSONSerialization.data(withJSONObject: messageDict, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        
            do {
                try appDelegate.mpcHandler.session.send(messageData!, toPeers: appDelegate.mpcHandler.session.connectedPeers, with: .reliable)
            }
            
            catch let error {
                NSLog("error is :  \(error)")
            }
            //ends turn
            self.turnCheck = false
            if self.readyCheck == true {
                self.checkResult()
            }
            // if not true then it changes and it starts to wait other player
            self.readyCheck = true
        }
        
        
        
    }
    
    @IBAction func rageButton(_ sender: UIBarButtonItem) {
        //alert that uses changeToMain if user chooses OK
        
        let refreshAlert = UIAlertController(title: "Rage quit", message: "You will lose the game.", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            self.changeToMain()
            print("Handle Ok logic here")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func changeToMain () {
        let messageDict = ["string":"quit"] as [String : Any]
        
        let messageData = try? JSONSerialization.data(withJSONObject: messageDict, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        
        do {
            try appDelegate.mpcHandler.session.send(messageData!, toPeers: appDelegate.mpcHandler.session.connectedPeers, with: .reliable)
        }
            
        catch let error {
            NSLog("error is :  \(error)")
        }
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            
            self.appDelegate.mpcHandler.session.disconnect()
                self.appDelegate.mpcHandler.advertiseSelf(advertise: false)
            //code for the change to main view without losing that navigation bar
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") else {
                print("View controller toMain not found")
                return
            }
            let navigationController = UINavigationController(rootViewController: vc)
            self.present(navigationController, animated: true, completion: nil)
        }
        
        
    }
    // Bluetooth connection button
    @IBAction func connectWithPlayer(_ sender: UIBarButtonItem) {
        if appDelegate.mpcHandler.session != nil {
            appDelegate.mpcHandler.setupBrowser()
            appDelegate.mpcHandler.browser.delegate = self
            self.present(appDelegate.mpcHandler.browser, animated: true, completion: nil)
        }

    }
    //Done button in bluetooth connection making view
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
    
    //Cancel button in bluetooth connection making
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
    
    func peerChangedStateWithNotification(notification: NSNotification){
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        
        let state = userInfo.object(forKey: "state") as! Int
        
        if state != MCSessionState.connecting.rawValue {
            self.navigationItem.title = "Connected"
        }
        
        print(state)
        
        
    }
    // Gets data with notification
    func handleReceivedDataWithNotification(notification: NSNotification) {
        
        // takes userInfo from the notification
        let userInfo = notification.userInfo! as Dictionary
        
        // Takes data from userInfo
        let receivedData:Data = userInfo["data"] as! Data
        
        // Changes data to json message and then it can be manipulated
        let message = try? JSONSerialization.jsonObject(with: receivedData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        
        // takes senders name from userInfo
        let senderPeerId:MCPeerID = userInfo["peerID"] as! MCPeerID
        
        // puts peerId to displayname
        let senderDisplayName = senderPeerId.displayName
        
        
        if (message?.object(forKey: "string") as AnyObject).isEqual("quit") == true{
            
            let alert = UIAlertController(title: "Rock Paper Scissors", message: "\(senderDisplayName) has left the game", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            //Takes opponents choice
            self.opponent = message?.object(forKey: "choice") as? String
            self.opponentName = message?.object(forKey: "opponent") as? String
            if self.opponent != "" && self.opponentName != "" && self.readyCheck == true {
                
                self.checkResult()
            }
            else {
                self.readyCheck = true
            }


            
        }
    }
    
    func checkResult() {
        //self.readyCheck = false
        if self.yours == "rock" && self.opponent == "paper"{
            print("Opponent Wins")
            self.showResult(result: "Lose", text: "Opponent wins")
        }
            
        else if self.yours == "rock" && self.opponent == "scissors" {
            print("You win")
            self.showResult(result: "Win", text: "You win")
        }
            
        else if self.yours == "paper" && self.opponent == "rock" {
            print("You win")
            self.showResult(result: "Win", text: "You win")
        }
        
        else if self.yours == "paper" && self.opponent == "scissors" {
            print("Opponent wins")
            self.showResult(result: "Lose", text: "Opponent wins")
        }
            
        else if self.yours == "scissors" && self.opponent == "paper" {
            print("You win")
            self.showResult(result: "Win", text: "You win")
        }
            
        else if self.yours == "scissors" && self.opponent == "rock" {
            print("You lose")
            self.showResult(result: "Lose", text: "Opponent wins")
        }
        else {
            print("Game was a Tie")
            self.showResult(result: "Tie", text: "The game was tie")
        }
        
    }
    
    func reset() {
        self.readyCheck = false
        self.turnCheck = true
        self.yours = ""
        self.opponent = ""
        self.opponentName = ""
        self.displayChoiceLabel.text = ""
    }
    
    func showResult(result:String, text:String) {
        let alert = UIAlertController(title: "Rock Paper Scissors", message: text, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Rematch", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.appDelegate.scoreHandler.getResultsFromGame(name: self.opponentName!, res: result)
                self.reset()
            print(self.readyCheck)
        }))
        alert.addAction(UIAlertAction(title: "Quit", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            self.appDelegate.scoreHandler.getResultsFromGame(name: self.opponentName!, res: result)
            self.changeToMain()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

}
