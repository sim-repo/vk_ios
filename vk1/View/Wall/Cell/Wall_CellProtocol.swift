import UIKit

protocol Wall_CellProtocol: UICollectionViewCell{
    func setup(_ wall: WallModelProtocol, _ indexPath: IndexPath, _ presenter: PullWallPresenterProtocol)
    func getImagesView() -> [UIImageView]
    func getLikeView() -> WallLike_View
    func getHeaderView() -> WallHeader_View
    func getIndexRow() -> Int
    func getHConHeaderView() -> NSLayoutConstraint
}
