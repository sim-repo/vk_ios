import UIKit

protocol WallCellProtocol : UICollectionViewCell {
    
    
    func setup(_ wall: WallModelProtocol, _ indexPath: IndexPath, _ presenter: ViewableWallPresenterProtocol, isExpanded: Bool, delegate: WallCellProtocolDelegate?)
    
    // header constraints
    func getReposterHeightCon() -> NSLayoutConstraint
    func getAuthorHeightCon() -> NSLayoutConstraint
    
    // reposter
    func getReposterName() -> UILabel
    func getReposterDate() -> UILabel
    func getReposterAva() -> UIImageView

    // author
    func getAuthorName() -> UILabel
    func getAuthorDate() -> UILabel
    func getAuthorAva() -> UIImageView

    // post message
    func getAuthorPostMsg() -> UILabel
    
    // media
    func getImagesView() -> [UIImageView]
    
    // footer
    func getLikeView() -> WallLike_View
    func getExpandButton() -> UIButton
    func getIndexRow() -> Int
    func hideFooter()
    
    // cell
    func getPreferedHeight() -> CGFloat
}


protocol ChildWallCellProtocol {
    func setupOutlets()
    func getButtons() -> [UIButton]
    func getImageContent() -> UIView
}

protocol VideoableWallCellProtocol {
    func play(url: URL, platformEnum: WallCellConstant.VideoPlatform)
    func showErr(err: String)
}
