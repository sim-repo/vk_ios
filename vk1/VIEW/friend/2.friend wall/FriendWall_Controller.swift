import UIKit

class FriendWall_Controller: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintSpaceX: NSLayoutConstraint!
    
    var presenter = FriendWallPresenter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...cellByCode.count {
            collectionView.register(UINib(nibName: cellByCode["tp\(i)"]!, bundle: nil), forCellWithReuseIdentifier: cellByCode["tp\(i)"]!)
        }
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = view.frame.size.width - constraintSpaceX.constant * 40
        let height = view.frame.size.height*0.5
        layout.minimumLineSpacing = 50
        layout.itemSize = CGSize(width: width, height: height)
    }
        
}


// Segue Actions
extension FriendWall_Controller {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       performSegue(withIdentifier: "FriendPostSegue", sender: indexPath)
    }
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       guard let indexPath = sender as? IndexPath else { return }

       if segue.identifier == "FriendPostSegue",
        let dest = segue.destination as? FriendPost_ViewController {
        if let data = presenter.getData(indexPath: indexPath) as? FriendWall {
                dest.friendWall = data
            }
       }
    }
}


extension FriendWall_Controller: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        guard let wall = presenter.getData(indexPath: indexPath) as? FriendWall
        else {
            return UICollectionViewCell()
        }
        
        if let name = cellByCode[wall.postTypeCode] {
            cell = cellConfigure(name, indexPath, wall)
        }
        return cell
    }
    
    func cellConfigure(_ cell: String, _ indexPath: IndexPath, _ wall: FriendWall) -> UICollectionViewCell{
        let c = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath) as! Wall_CellProtocol
        c.setup(wall, indexRow: indexPath.row)
        return c
    }
}


extension FriendWall_Controller: PushPlainViewProtocol {
    func viewReloadData() {
    }
}
