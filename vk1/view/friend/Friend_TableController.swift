//
//  FriendTableController.swift
//  vk1
//
//  Created by Igor Ivanov on 16/09/2019.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit

class Friend_TableController: UITableViewController {

    
    var presenter = FriendPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! Friend_TableCell
        cell.friendName?.text = presenter.getName(indexPath)
        cell.friendAva?.text = presenter.getAva(indexPath)
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
                guard let friend = presenter.getFriend(index)
                    else {return}
                dest.presenter.setFriend(friend: friend)
            }
        }
    }

}
