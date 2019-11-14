import UIKit

class GroupSectionHeader: UICollectionReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    var title: String? {
        didSet{
            titleLabel.text = title
        }
    }
    
    var count: String? {
        didSet{
            countLabel.text = count
        }
    }
}
