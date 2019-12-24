import UIKit
import WebKit

protocol Wall_CellProtocol: UICollectionViewCell {
    func setup(_ wall: WallModelProtocol, _ indexPath: IndexPath, _ presenter: PullWallPresenterProtocol, isExpanded: Bool, delegate: WallCellProtocolDelegate)
    func getImagesView() -> [UIImageView]
    func getLikeView() -> WallLike_View
    func getHeaderView() -> WallHeader_View
    func getIndexRow() -> Int
    func getHConHeaderView() -> NSLayoutConstraint
    func getPreferedHeight() -> CGFloat
}


protocol Video_CellProtocol {
    func play(url: URL, platformEnum: WallCellConstant.VideoPlatform)
    func showErr(err: String)
}
