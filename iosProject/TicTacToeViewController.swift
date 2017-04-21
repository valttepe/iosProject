//
//  TicTacToeViewController.swift
//  iosProject
//
//  Created by iosdev on 21.4.2017.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit
import MultipeerConnectivity
class TicTacToeViewController: UIViewController, MCBrowserViewControllerDelegate {

    
    @IBOutlet var fields: [TTTImageView]!
    
    //who's turn is it
    var currentPlayer:String!
    
    //If play is tie
    var count:Int = 0
    
    //Call for appDelegate.swift
    var appDelegate:AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Init for appdelegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        // Sets peer name with phones own device name
        appDelegate.mpcHandler.setupPeerWithDisplayName(displayName: UIDevice.current.name)
        
        // Calls session
        appDelegate.mpcHandler.setupSession()
        
        //shows your own device name to others
        appDelegate.mpcHandler.advertiseSelf(advertise: true)
        
        //Starts listen notification
        NotificationCenter.default.addObserver(self, selector: #selector(TicTacToeViewController.peerChangedStateWithNotification), name:  NSNotification.Name(rawValue: "MPC_DidChangeStateNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TicTacToeViewController.handleReceivedDataWithNotification), name: NSNotification.Name(rawValue: "MPC_DidReceiveDataNotification") , object: nil)
        
        // Tap gestures and stuff
        setupField()
        
        //Tells that first player is x
        currentPlayer = "x"
    }
    

    // Bluetooth connection button
    @IBAction func connectWithPlayer(_ sender: Any) {
        if appDelegate.mpcHandler.session != nil {
            appDelegate.mpcHandler.setupBrowser()
            appDelegate.mpcHandler.browser.delegate = self
            self.present(appDelegate.mpcHandler.browser, animated: true, completion: nil)
        }
    }
    
    // Gets notification and when it is connected then it tells to navbar that it is connected
    func peerChangedStateWithNotification(notification: NSNotification){
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        
        let state = userInfo.object(forKey: "state") as! Int
        
        if state != MCSessionState.connecting.rawValue {
            self.navigationItem.title = "Connected"
        }
        
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
        
        
        // If there is new game call in message then it sends alert which tells when other player has started new game
        if (message?.object(forKey: "string") as AnyObject).isEqual("New Game") == true{
            let alert = UIAlertController(title: "TicTacToe", message: "\(senderDisplayName) has started a new Game", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            // takes field tag number from message
            var field:Int? = message?.object(forKey: "field") as! Int?
            
            // takes player mark x or o
            var player:String? = message?.object(forKey: "player") as? String
            
            // Checks that player and field are there
            if field != nil && player != nil {
                //adds player to the field
                fields[field!].player = player
                fields[field!].setPlayer(_player: player!)
                
                //changes current player
                if player == "x" {
                    currentPlayer = "o"
                }
                else {
                    currentPlayer = "x"
                }
                
                // checkResults
                
                checkResults()
                
            }
            
        }
        
    }
    
    //tracks if someone tapps field
    func fieldTapped(recognizer:UITapGestureRecognizer) {
        
        if appDelegate.mpcHandler.session.connectedPeers.count == 0 {
            print("This is the problem")
            let alert = UIAlertController(title: "Error", message: "You must connect before playing", preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let tappedField = recognizer.view as! TTTImageView
            tappedField.setPlayer(_player: currentPlayer)
            
            let messageDict = ["field":tappedField.tag, "player":currentPlayer] as [String : Any]
            
            let messageData = try? JSONSerialization.data(withJSONObject: messageDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            
            do {
                try appDelegate.mpcHandler.session.send(messageData!, toPeers: appDelegate.mpcHandler.session.connectedPeers, with: .reliable)
            }
                
            catch let error {
                NSLog("error is :  \(error)")
            }
            
            // CheckResult
            checkResults()
            
        }
        
    }
    
    func setupField () {
        for index in 0 ... fields.count - 1 {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TicTacToeViewController.fieldTapped))
            gestureRecognizer.numberOfTapsRequired = 1
            
            fields[index].addGestureRecognizer(gestureRecognizer)
        }
    }
    
    func resetField() {
        for index in 0 ... fields.count - 1 {
            fields[index].image = nil
            fields[index].activated = false
            fields[index].player = ""
        }
        currentPlayer = "x"
        count = 0
    }
    
    func checkResults () {
        var winner = ""
        
        
        if fields[0].player == "x" && fields[1].player == "x" && fields[2].player == "x"{
            winner = "x"
        }else if fields[0].player == "o" && fields[1].player == "o" && fields[2].player == "o"{
            winner = "o"
        }else if fields[3].player == "x" && fields[4].player == "x" && fields[5].player == "x"{
            winner = "x"
        }else if fields[3].player == "o" && fields[4].player == "o" && fields[5].player == "o"{
            winner = "o"
        }else if fields[6].player == "x" && fields[7].player == "x" && fields[8].player == "x"{
            winner = "x"
        }else if fields[6].player == "o" && fields[7].player == "o" && fields[8].player == "o"{
            winner = "o"
        }else if fields[0].player == "x" && fields[3].player == "x" && fields[6].player == "x"{
            winner = "x"
        }else if fields[0].player == "o" && fields[3].player == "o" && fields[6].player == "o"{
            winner = "o"
        }else if fields[1].player == "x" && fields[4].player == "x" && fields[7].player == "x"{
            winner = "x"
        }else if fields[1].player == "o" && fields[4].player == "o" && fields[7].player == "o"{
            winner = "o"
        }else if fields[2].player == "x" && fields[5].player == "x" && fields[8].player == "x"{
            winner = "x"
        }else if fields[2].player == "o" && fields[5].player == "o" && fields[8].player == "o"{
            winner = "o"
        }else if fields[0].player == "x" && fields[4].player == "x" && fields[8].player == "x"{
            winner = "x"
        }else if fields[0].player == "o" && fields[4].player == "o" && fields[8].player == "o"{
            winner = "o"
        }else if fields[2].player == "x" && fields[4].player == "x" && fields[6].player == "x"{
            winner = "x"
        }else if fields[2].player == "o" && fields[4].player == "o" && fields[6].player == "o"{
            winner = "o"
        }
        
        count = count + 1
        
        
        
        print(count)
        
        
        if winner != ""{
            
            let alert = UIAlertController(title: "Tic Tac Toe", message: "The winner is \(winner)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                self.resetField()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        if winner == "" && count == 9{
            let alert = UIAlertController(title: "Tic Tac Toe", message: "The game has ended as tie", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                self.resetField()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
