//
//  MPCHandler.swift
//  iosProject
//
//  Created by iosdev on 21.4.2017.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit

import MultipeerConnectivity

class MPCHandler: NSObject, MCSessionDelegate {
    // MultipeerConnectivity must have functions are in here so that both games can use them
    var peerID:MCPeerID!
    var session:MCSession!
    var browser:MCBrowserViewController!
    var advertiser:MCAdvertiserAssistant? = nil
    
    // puts peerID
    func setupPeerWithDisplayName(displayName:String){
        peerID = MCPeerID(displayName: displayName)
    }
    
    // starts session with peerid
    func setupSession (){
        session = MCSession(peer: peerID)
        session.delegate = self
    }
    
    // makes browser for finding peer
    func setupBrowser() {
        self.browser = MCBrowserViewController(serviceType: "my-game", session: session)
    }
    
    // start showing itself in peers or stops it
    func advertiseSelf(advertise:Bool){
        if advertise {
            advertiser = MCAdvertiserAssistant(serviceType: "my-game", discoveryInfo: nil, session: session)
            advertiser!.start()
        }
        else {
            advertiser!.stop()
            advertiser = nil
        }
    }
    
    
    
    // checks state of the connection
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let userInfo = ["peerID":peerID, "state":state.rawValue] as [String : Any]
        DispatchQueue.main.async { [unowned self] in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MPC_DidChangeStateNotification"), object: nil, userInfo: userInfo)
        }
    }
    
    // when it receives something from the other one
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let userInfo = ["data":data, "peerID":peerID] as [String : Any]
        DispatchQueue.main.async { [unowned self] in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MPC_DidReceiveDataNotification"), object: nil, userInfo: userInfo)
        }
    }
    
    // rest of them just are here because they are required but are not used in anywhere
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
}
