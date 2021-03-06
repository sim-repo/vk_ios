import UIKit


class BaseWall : UICollectionViewCell {
    
    
    weak var presenter: PullWallPresenterProtocol?
    var indexPath: IndexPath!
    var cellType: WallCellConstant.CellTypeEnum!
    var preferedHeight: CGFloat = WallCellConstant.cellHeight
    var isExpanded = false
    weak var delegate: WallCellProtocolDelegate?
    var wall: WallModelProtocol!
    var baseWallVideo: BaseWallVideo = BaseWallVideo()
    
    
    func setup(_ wall: WallModelProtocol,
               _ indexPath: IndexPath,
               _ presenter: PullWallPresenterProtocol,
               isExpanded: Bool,
               delegate: WallCellProtocolDelegate?) {
        
        self.indexPath = indexPath
        self.presenter = presenter
        self.isExpanded = isExpanded
        self.delegate = delegate
        self.wall = wall
        
        setupOutlets()
        
        WallCellConfigurator.setupCell(cell: self, wall: wall, isExpanded: isExpanded)
        
        cellType = wall.getCellType()
        if wall.getCellType() == .video {
            baseWallVideo.setup(buttons: getButtons())
        }
    }
    
    func setupOutlets(){}
    
    func prepareReuse(){
        for imageView in getImagesView() {
          imageView.image = UIImage(named: "placeholder")
        }
        baseWallVideo.prepareReuse(buttons: getButtons())
    }
    
    
    func pressImage(imageIdx: Int){
        guard let presenter = presenter else { return }
        baseWallVideo.pressImage(presenter: presenter, view: getImageContent(), indexPath: indexPath, imageIdx: imageIdx)
        presenter.selectImage(indexPath: indexPath, imageIdx: imageIdx)
    }
    
    
    func getButtons() -> [UIButton] {
        return []
    }
    
    
    func getImageContent() -> UIView {
        return UIView()
    }
    
    func getFooterHeightCon() -> NSLayoutConstraint {
        return NSLayoutConstraint()
    }
    
    
    func getPreferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        let preferredLayoutAttributes = layoutAttributes
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = preferredLayoutAttributes.size.width
        let size = systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        var adjustedFrame = preferredLayoutAttributes.frame
        adjustedFrame.size.height = ceil(size.height)
        preferredLayoutAttributes.frame = adjustedFrame
        preferedHeight = adjustedFrame.size.height
        return preferredLayoutAttributes
    }
}


extension BaseWall: Video_CellProtocol {
    func play(url: URL, platformEnum: WallCellConstant.VideoPlatform) {
        baseWallVideo.play(url: url, platformEnum: platformEnum)
    }
    
    func showErr(err: String) {
        baseWallVideo.showErr(err: err)
    }
}

extension BaseWall: WallHeaderProtocolDelegate {
    func didPressExpand() {
        isExpanded = !isExpanded
        WallCellConfigurator.expandCell(cell: self, wall: wall, isExpanded: isExpanded)
        delegate?.didPressExpand(isExpand: isExpanded, indexPath: indexPath)
    }
}


extension BaseWall: Wall_CellProtocol {

    
    // header constraints
    @objc func getReposterHeightCon() -> NSLayoutConstraint {
        return NSLayoutConstraint()
    }
    
    @objc func getAuthorHeightCon() -> NSLayoutConstraint {
        return NSLayoutConstraint()
    }
    
    // reposter
    @objc func getReposterName() -> UILabel { return UILabel() }
    
    @objc func getReposterDate() -> UILabel { return UILabel() }
    @objc func getReposterAva() -> UIImageView  { return UIImageView() }

    // author
    @objc func getAuthorName() -> UILabel { return UILabel() }
    @objc func getAuthorDate() -> UILabel { return UILabel() }
    @objc func getAuthorAva() -> UIImageView  { return UIImageView() }

    // post message
    @objc func getAuthorPostMsg() -> UILabel { return UILabel() }

    // media
    @objc func getImagesView() -> [UIImageView] { return [] }

    // footer
    @objc func getLikeView() -> WallLike_View { return WallLike_View() }
    
    
    @objc func getExpandButton() -> UIButton {
        return UIButton()
    }
    
    @objc func getPreferedHeight() -> CGFloat {
        return 0
    }
    
    @objc func getIndexRow() -> Int {
        return 0
    }
    
    func hideFooter() {
        getFooterHeightCon().constant = 0
        setNeedsLayout()
        layoutIfNeeded()
    }
}

extension BaseWall: WallFooterViewProtocolDelegate {
    
    func didPressLike() {
        presenter?.didPressLike(indexPath: indexPath)
    }
    
    func didPressComment() {
        presenter?.didPressComment(indexPath: indexPath)
    }
    
    func didPressShare() {
        presenter?.didPressShare(indexPath: indexPath)
    }
}
