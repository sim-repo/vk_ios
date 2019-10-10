import UIKit

class MyGroups_ViewController: UIViewController  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter = MyGroupPresenter()
    @IBOutlet weak var constraintSpaceX: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = (view.frame.size.width - layout.minimumInteritemSpacing*2 - constraintSpaceX.constant*2) / 1
        layout.itemSize = CGSize(width: width, height: 130)
        
     //   let navigationCtl = navigationController as! ZoomNavigatorController
//        navigationCtl.popAnimator.dismissCompletion = { [weak self] in
//            guard
//              let selected = self?.collectionView.indexPathsForSelectedItems,
//              let selectedCell = self?.collectionView.cellForItem(at: selected[0]) as? MyGroup_CollectionViewCell
//                else {
//                    return
//                }
//
//            //selectedCell.containerView.isHidden = false
//        }
            
        CommonElementDesigner.setupNavigationBarColor(navigationController: navigationController)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        prepareForPresent()
           let indexPath = sender as! IndexPath
           let dest = segue.destination as! MyGroupDetail_ViewController
           dest.modalPresentationStyle = .custom
           dest.myGroup = presenter.getData(indexPath)
       }
    
    private func prepareForPresent(){
        
        guard
          let indexPath = collectionView.indexPathsForSelectedItems,
          let selectedCell = collectionView.cellForItem(at: indexPath[0]) as? MyGroup_CollectionViewCell,
          let selectedCellSuperview = selectedCell.superview
          else {
                return
          }
        
        let navigationCtl = navigationController as! ZoomNavigatorController
        let popAnimator = navigationCtl.popAnimator
        popAnimator.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
        popAnimator.originFrame = CGRect(
          x: popAnimator.originFrame.origin.x,
          y: popAnimator.originFrame.origin.y,
          width: popAnimator.originFrame.size.width ,
          height: popAnimator.originFrame.size.height
        )
        
        popAnimator.presenting = true
    }
    
}


extension MyGroups_ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyGroup_CollectionViewCell", for: indexPath) as! MyGroup_CollectionViewCell
        cell.nameLabel.text = presenter.getName(indexPath)
        cell.descTextView?.text = presenter.getDesc(indexPath)
        cell.imageView.image = UIImage(named: presenter.getIcon(indexPath))
        cell.setup()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MyGroupDetailSegue", sender: indexPath)
    }
    
    @IBAction func addGroupPressed(_ sender: Any) {
        performSegue(withIdentifier: "GroupSegue", sender: nil)
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroupSegue",
        let controller = segue.source as? Group_ViewController {
           if let indexPath = controller.collectionView.indexPathsForSelectedItems,
              let selected = controller.getGroup(indexPath: indexPath[0]) {
               if presenter.addGroup(group: selected) {
                   let indexPath = presenter.getIndexPath()
                   collectionView.insertItems(at: [indexPath])
               }
           }
        }
    }

}
