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
    
    //@IBOutlet weak var turnPlayer: UILabel!
    //who's turn is it
    var currentPlayer:String!
    
    //If play is tie
    var count:Int = 0
    
    //Call for appDelegate.swift
    var appDelegate:AppDelegate!
    
    // checks whose turn it is
    var turnCheck:Bool = true
    // your username
    var you:String?
    
    //opponent username
    var opponent:String?
    
    //opponent mark o or x
    var opponentMark:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor()
        //Init for appdelegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.you = appDelegate.scoreHandler.getYourself()
        
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
        
        // Tap gestures and stuff
        setupField()
        
        //Tells that first player is x
        currentPlayer = "x"
    }

    
    
    @IBAction func rageQuit(_ sender: Any) {
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
        
        
        // If there is new game call in message then it sends alert which tells when other player has started new game
        if (message?.object(forKey: "string") as AnyObject).isEqual("quit") == true{
            
            let alert = UIAlertController(title: "TicTacToe", message: "\(senderDisplayName) has left the game", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            //Takes opponent name
            self.opponent = message?.object(forKey: "opponent") as? String
            
            self.opponentMark = message?.object(forKey: "player") as? String
            
            self.turnCheck = true
            
            // takes field tag number from message
            var field:Int? = message?.object(forKey: "field") as! Int?
            
            // takes player mark x or o
            var player:String? = message?.object(forKey: "player") as? String
            
            //self.turnPlayer.text = "It is your turn"
            
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
        //Checks that if player is connected
        if appDelegate.mpcHandler.session.connectedPeers.count == 0 {
            print("This is the problem")
            let alert = UIAlertController(title: "Error", message: "You must connect before playing", preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        //Sets player marking in the field and sends notification to other player
        else if self.turnCheck == true {
            let tappedField = recognizer.view as! TTTImageView
            tappedField.setPlayer(_player: currentPlayer)
            let opponent = appDelegate.scoreHandler.getYourself()
            
            // Sends field that you have tapped and your mark o or x and also your username
            let messageDict = ["field":tappedField.tag, "player":currentPlayer,"opponent":opponent] as [String : Any]
            
            let messageData = try? JSONSerialization.data(withJSONObject: messageDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            
            do {
                try appDelegate.mpcHandler.session.send(messageData!, toPeers: appDelegate.mpcHandler.session.connectedPeers, with: .reliable)
            }
                
            catch let error {
                NSLog("error is :  \(error)")
            }
            
            self.turnCheck = false
            // CheckResult
            checkResults()
            
        }
        else {
            //if there isn't connection to other player
            let alert = UIAlertController(title: "Error", message: "You must connect before playing", preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func setupField () {
        
        //Enables tapping in the field
        for index in 0 ... fields.count - 1 {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TicTacToeViewController.fieldTapped))
            gestureRecognizer.numberOfTapsRequired = 1
            
            fields[index].addGestureRecognizer(gestureRecognizer)
        }
    }
    
    func resetField() {
        //Returns game to start state
        for index in 0 ... fields.count - 1 {
            fields[index].image = nil
            fields[index].activated = false
            fields[index].player = ""
        }
        self.currentPlayer = "x"
        self.count = 0
        self.turnCheck = true
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
        //This is counter for checking tie
        count = count + 1
        
        
        
        print(count)
        
        // Checks if you or opponent wins ar
        if winner == opponentMark {
            let alert = UIAlertController(title: "Tic Tac Toe", message: "The winner is \(self.opponent!) with \(winner)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Rematch", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                self.appDelegate.scoreHandler.getResultsFromGame(name: self.opponent!, res: "Lose")
                self.resetField()
            }))
            alert.addAction(UIAlertAction(title: "Quit", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                self.appDelegate.scoreHandler.getResultsFromGame(name: self.opponent!, res: "Win")
                self.changeToMain()
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        if winner != "" && winner != opponentMark {
            let alert = UIAlertController(title: "Tic Tac Toe", message: "Y The winner is \(self.you!) with \(winner)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                self.appDelegate.scoreHandler.getResultsFromGame(name: self.opponent!, res: "Win")
                self.resetField()
            }))
            alert.addAction(UIAlertAction(title: "Quit", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                self.appDelegate.scoreHandler.getResultsFromGame(name: self.opponent!, res: "Win")
                self.changeToMain()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
//        if winner != ""{
//            
//            let alert = UIAlertController(title: "Tic Tac Toe", message: "The winner is \(winner)", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
//                //self.appDelegate.scoreHandler.getOpponent(name: self.opponent!)
//                self.resetField()
//            }))
//            
//            self.present(alert, animated: true, completion: nil)
//        }
        
        // if game is tie and no winner is found
        
        if winner == "" && count == 9{
            let alert = UIAlertController(title: "Tic Tac Toe", message: "The game has ended as tie", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                self.appDelegate.scoreHandler.getResultsFromGame(name: self.opponent!, res: "Tie")
                self.resetField()
            }))
            alert.addAction(UIAlertAction(title: "Quit", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                self.appDelegate.scoreHandler.getResultsFromGame(name: self.opponent!, res: "Win")
                self.changeToMain()
            }))
            
            self.present(alert, animated: true, completion: nil)
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backgroundColor() {
        let backColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
        view.backgroundColor = backColor
    }

    

    
}
