import UIKit


class BaseWall : UICollectionViewCell {
    
    weak var presenter: ViewableWallPresenterProtocol?
    var indexPath: IndexPath!
    var cellType: WallCellConstant.CellEnum!
    var preferedHeight: CGFloat = 0
    var isExpanded = false
    weak var delegate: WallCellProtocolDelegate?
    var wall: WallModelProtocol!
    var baseWallVideo: BaseWallVideo = BaseWallVideo()
    
    
    func setup(_ wall: WallModelProtocol,
               _ indexPath: IndexPath,
               _ presenter: ViewableWallPresenterProtocol,
               isExpanded: Bool,
               delegate: WallCellProtocolDelegate?) {
        
        self.indexPath = indexPath
        self.presenter = presenter
        self.isExpanded = isExpanded
        self.delegate = delegate
        self.wall = wall
        
        getChild().setupOutlets()
    
        ExpandableConfigurator.setupCell(cell: self as! WallCellProtocol, wall: wall, isExpanded: isExpanded)
        
        cellType = wall.getType()
        if wall.getType() == .video {
            baseWallVideo.setup(buttons: getChild().getButtons())
        }
    }
    
    func getChild() -> ChildWallCellProtocol {
        return self as! ChildWallCellProtocol
    }
    
    
    func prepareReuse(){
        for imageView in (self as! WallCellProtocol).getImagesView() {
          imageView.image = UIImage(named: "placeholder")
        }
        baseWallVideo.prepareReuse(buttons: getChild().getButtons())
    }
    
    
    func pressImage(imageIdx: Int){
        guard let presenter = presenter else { return }
        baseWallVideo.pressImage(view: getChild().getImageContent())
        presenter.didSelectImage(indexPath: indexPath, imageIdx: imageIdx)
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
    
        
    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        Logger.log(clazz: "BaseWall", msg, level: level, printEnum: .warning)
    }
}


extension BaseWall: VideoableWallCellProtocol {
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
        ExpandableConfigurator.expandCell(cell: (self as! WallCellProtocol), wall: wall, isExpanded: isExpanded)
        delegate?.didPressExpand(isExpand: isExpanded, indexPath: indexPath)
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
