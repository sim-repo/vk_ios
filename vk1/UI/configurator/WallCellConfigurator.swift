import UIKit
import Kingfisher

class WallCellConfigurator {
    
    static var wallTitleHeight: [Int:CGFloat] = [:]
    
    static func getTitleHeight(cellIdx: Int, title: UITextView) -> CGFloat? {
        var height = wallTitleHeight[cellIdx]
        if height == nil {
            if title.text.count == 0 {
                wallTitleHeight[cellIdx] = 0
                return 0
            }
            
            let numLines = min((title.contentSize.height / title.font!.lineHeight), 3)
            height = cellHeaderHeight * numLines
            wallTitleHeight[cellIdx] = height
            return height
        } else {
            return height
        }
    }
    
    static func setupCollectionCell(cell: Wall_CellProtocol, wall: WallProtocol) {
        
        
        cell.getHeaderView().myAvaImageView.kf.setImage(with: wall.getMyAvaURL())
        cell.getHeaderView().myNameLabel.text = wall.getMyName()
        cell.getHeaderView().myPostDateLabel.text = wall.getMyPostDate()
        
        
        var negativeHCon: CGFloat = 0
        if wall.getTitle()?.count == 0 {
            cell.getHeaderView().hConRepostTitleTextView.constant = 0
            negativeHCon += cellQuarterHeight
        }
        cell.getHeaderView().myTitleTextView.text = wall.getTitle()
        cell.getHeaderView().myTitleTextView.textContainer.lineBreakMode = .byTruncatingTail
        
        
        if wall.getOrigAvaURL() == nil {
            cell.getHeaderView().hConOrigAuthorContentView.constant = 0
            negativeHCon += cellQuarterHeight
        }
        
        if wall.getOrigTitle()?.count == 0 {
            cell.getHeaderView().hConOrigTitleTextView.constant = 0
            negativeHCon += cellQuarterHeight
        }
        
        cell.getHConHeaderView().constant = cellHeaderHeight - negativeHCon
        
        
        
        cell.getHeaderView().origAvaImageView.kf.setImage(with: wall.getOrigAvaURL())
        cell.getHeaderView().origNameLabel.text = wall.getOrigName()
        cell.getHeaderView().origPostDateLabel.text = wall.getOrigPostDate()
        cell.getHeaderView().origTitleTextView.text = wall.getOrigTitle()
        cell.getHeaderView().origTitleTextView.textContainer.lineBreakMode = .byTruncatingTail
        
        
        let URLs = wall.getImageURLs()
        let images = cell.getImagesView()
        for (idx, url) in URLs.enumerated() {
            images[idx].kf.setImage(with: url)
        }
        cell.getLikeView().likeCount.text = "\(wall.getLikeCount())"
        cell.getLikeView().messageCount.text = "\(wall.getMessageCount())"
        cell.getLikeView().shareCount.text = "\(wall.getShareCount())"
        cell.getLikeView().eyeCount.text = "\(wall.getEyeCount())"
        
    }

}
