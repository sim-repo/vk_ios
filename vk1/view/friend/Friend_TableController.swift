//
//  FriendTableController.swift
//  vk1
//
//  Created by Igor Ivanov on 16/09/2019.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit

class Friend_TableController: UITableViewController {

    
    var friends: [Friend]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friends = Friend.list()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! Friend_TableCell
        let item = friends[indexPath.row]
        cell.friendName?.text = item.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "FriendDetailSegue", sender: indexPath)
    }
    
    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendDetailSegue" {
            if let dest = segue.destination as? Friend_CollectionController,
                let index = sender as? IndexPath {
                dest.friend = friends[index.row]
            }
        }
    }

}
