import UIKit
import Kingfisher



class WallCellConfigurator {
    
    
    static func setupCell(cell: Wall_CellProtocol, wall: WallModelProtocol, isExpanded: Bool) {
        
        
        
        // wall header block >>
        
        
        // set initial height
        
        cell.getHeaderView().origTitleTextView.textContainer.maximumNumberOfLines = 1000
        cell.getHeaderView().origTitleTextView.text = wall.getOrigTitle()
        
        if !isExpanded {
            configNormalCell(cell: cell, wall: wall)
        }
        
        // set attributes
        cell.getHeaderView().myAvaImageView.kf.setImage(with: wall.getMyAvaURL())
        cell.getHeaderView().myNameLabel.text = wall.getMyName()
        
        cell.getHeaderView().myPostDateLabel.text = convertUnixTime(unixTime: wall.getMyPostDate())
        cell.getHeaderView().myTitleTextView.text = wall.getTitle()
        cell.getHeaderView().myTitleTextView.textContainer.lineBreakMode = .byTruncatingTail
        
        
        cell.getHeaderView().origAvaImageView.kf.setImage(with: wall.getOrigAvaURL())
        cell.getHeaderView().origNameLabel.text = wall.getOrigName()
        cell.getHeaderView().origPostDateLabel.text = convertUnixTime(unixTime: wall.getOrigPostDate())
        
        
        if isExpanded {
            expandCell(cell: cell, wall: wall, isExpanded: isExpanded)
            cell.getHeaderView().addExpandedButton(expanded: true)
        }
        
        // wall image block >>
        let URLs = wall.getImageURLs()
        let images = cell.getImagesView()
        for (idx, url) in URLs.enumerated() {
            if idx < 9 {
                images[idx].kf.setImage(with: url)
            }
        }
        
        // wall footer block >>
        cell.getLikeView().likeCount.text = "\(wall.getLikeCount())"
        cell.getLikeView().messageCount.text = "\(wall.getMessageCount())"
        cell.getLikeView().shareCount.text = "\(wall.getShareCount())"
        cell.getLikeView().eyeCount.text = "\(wall.getEyeCount())"
        
    }
    
    
    
    
    
    static func configNormalCell(cell: Wall_CellProtocol, wall: WallModelProtocol){
        
        cell.getHConHeaderView().isActive = true
        cell.getHeaderView().hConRepostAuthorContentView.isActive = true
        cell.getHeaderView().hConRepostTitleTextView.isActive = true
        cell.getHeaderView().hConOrigAuthorContentView.isActive = true
        cell.getHeaderView().hConOrigTitleTextView.isActive = true
        
        
        cell.getHConHeaderView().constant = WallCellConstant.headerHeight + 20
        cell.getHeaderView().hConRepostAuthorContentView.constant = WallCellConstant.quarterHeight
        cell.getHeaderView().hConRepostTitleTextView.constant = WallCellConstant.quarterHeight
        cell.getHeaderView().hConOrigAuthorContentView.constant = WallCellConstant.quarterHeight
        cell.getHeaderView().hConOrigTitleTextView.constant = WallCellConstant.quarterHeight
        
        
        // search and hide empty
        var negativeHCon: CGFloat = 0

        if wall.getMyAvaURL() == nil {
            cell.getHeaderView().hConRepostAuthorContentView.constant = 0
            negativeHCon += WallCellConstant.quarterHeight
        }
        
        if wall.getTitle() == nil || wall.getTitle()?.count == 0 {
            cell.getHeaderView().hConRepostTitleTextView.constant = 0
            negativeHCon += WallCellConstant.quarterHeight
        }
        
        if wall.getOrigAvaURL() == nil {
            cell.getHeaderView().hConOrigAuthorContentView.constant = 0
            negativeHCon += WallCellConstant.quarterHeight
        }
        
        if wall.getOrigTitle() == nil || wall.getOrigTitle()?.count == 0 {
            cell.getHeaderView().hConOrigTitleTextView.constant = 0
            negativeHCon += WallCellConstant.quarterHeight
        }
        
        
        // parent block: decrease height
        cell.getHConHeaderView().constant -= negativeHCon
        
        let canExpanded = cell.getHeaderView().origTitleTextView.numberOfLines() >= 8
        if canExpanded {
            let size = cell.getHeaderView().origTitleTextView.sizeForLines(numberOfLines: 3)
            cell.getHConHeaderView().constant = WallCellConstant.quarterHeight + size + 20
            cell.getHeaderView().hConOrigTitleTextView.constant = size
            cell.getHeaderView().addExpandedButton(expanded: false)
        } else if cell.getHeaderView().origTitleTextView.text.count > 0 {
            let delta = cell.getHeaderView().origTitleTextView.actualSize().height - WallCellConstant.quarterHeight
            cell.getHConHeaderView().constant += delta
            cell.getHeaderView().hConOrigTitleTextView.constant = cell.getHeaderView().origTitleTextView.actualSize().height
        }
    }
    
    static func expandCell(cell: Wall_CellProtocol, wall: WallModelProtocol, isExpanded: Bool) {
        if !isExpanded {
            cell.getHeaderView().origTitleTextView.textContainer.lineBreakMode = .byWordWrapping
        } else {
            cell.getHeaderView().origTitleTextView.text = wall.getOrigTitle()
            let titleHeight = cell.getHeaderView().origTitleTextView.actualSize().height
            let headerHeight = calcHeaderHeight(cell, wall) + titleHeight
            cell.getHConHeaderView().constant = headerHeight
            cell.getHeaderView().hConOrigTitleTextView.constant = titleHeight
        }
    }
    
    
    static func calcHeaderHeight(_ cell: Wall_CellProtocol, _ wall: WallModelProtocol) -> CGFloat {
        
        var negativeHCon: CGFloat = 0
        
        if wall.getMyAvaURL() == nil {
            negativeHCon += WallCellConstant.quarterHeight
        }
        
        if wall.getTitle() == nil || wall.getTitle()?.count == 0 {
            negativeHCon += WallCellConstant.quarterHeight
        }
        
        if wall.getOrigAvaURL() == nil {
            negativeHCon += WallCellConstant.quarterHeight
        }
        
        return WallCellConstant.headerHeight - negativeHCon
    }
}
