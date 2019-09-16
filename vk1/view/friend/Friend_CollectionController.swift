//
//  FriendCollectionController.swift
//  vk1
//
//  Created by Igor Ivanov on 16/09/2019.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FriendCollectionCell"

class Friend_CollectionController: UICollectionViewController {

    var friend: Friend?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendDetailCell", for: indexPath) as! Friend_CollectionCell
        cell.friendNameLabel.text = friend?.name
        return cell
    }

}
