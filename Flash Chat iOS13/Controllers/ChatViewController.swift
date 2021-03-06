//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    private static let cellIdentifier = "ReuseableCell"
    private static let otherMessageIdentifier = "OtherMessageCell"
    private static let collection = "message"
    private static let name = "name"
    private static let body = "body"
    private static let date = "date"
    
    private let db = Firestore.firestore()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "⚡️FlashChat"
        navigationItem.hidesBackButton = true
        
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: ChatViewController.cellIdentifier)
        tableView.register(UINib(nibName: "OtherMessageCell", bundle: nil), forCellReuseIdentifier: ChatViewController.otherMessageIdentifier)
        
        
        db.collection(ChatViewController.collection)
            .order(by: ChatViewController.date)
            .addSnapshotListener() { querySnapshot, error in
                
            if let e = error {
                print("there is an error when retrieving the data, error: \(e)")
            } else {
                self.messages = []
                let docs = querySnapshot?.documents ?? []
                for document in docs {
                    let data = document.data()
                    if let senderMessage = data[ChatViewController.name] as? String, let bodyMessage = data[ChatViewController.body] as? String {
                        self.messages.append(Message(sender: senderMessage, body: bodyMessage))
                    }
                }
                self.reloadAndGoToDown()
            }
        }
    }
    
    func reloadAndGoToDown() {
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: UITableView.ScrollPosition.top, animated: false)
    }
    
    @IBAction func onLogOutClick(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        let user = Auth.auth().currentUser?.email
        let body = messageTextfield.text
        if let userNotNull = user, let bodyNotNull = body {
            db.collection(ChatViewController.collection).addDocument(data: [
                ChatViewController.name: userNotNull,
                ChatViewController.body: bodyNotNull,
                ChatViewController.date: Date().timeIntervalSince1970
            ]) { error in
                if let e = error {
                    print("there is an error when saving the message to db, error: \(e)")
                } else {
                    print("success send the message")
                    self.messageTextfield.text = ""
                }
            }
        } else {
            print("user is null? \(user == nil)")
            print("body is null? \(body == nil)")
        }
    }

}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        let currentUserMail = Auth.auth().currentUser?.email
        
        if message.sender == currentUserMail {
            let cellItem = tableView.dequeueReusableCell(withIdentifier: ChatViewController.cellIdentifier, for: indexPath) as! MessageCell

            cellItem.labelV.text = message.body
            
            return cellItem
        } else {
            let otherCellItem = tableView.dequeueReusableCell(withIdentifier: ChatViewController.otherMessageIdentifier, for: indexPath) as! OtherMessageCell

            otherCellItem.bindData(message.body)
            
            return otherCellItem
        }
        
    }
    
}
