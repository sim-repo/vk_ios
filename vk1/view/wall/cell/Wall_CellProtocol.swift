import UIKit

protocol Wall_CellProtocol: UICollectionViewCell{
    func setup(_ wall: WallProtocol, indexRow: Int)
    func getTitle() -> UITextView
    func getImagesView() -> [UIImageView]
    func getLikeView() -> WallLike_View
    func getConstraintTitleHeight() -> NSLayoutConstraint
    func getIndexRow() -> Int
}
