import UIKit
import Kingfisher

class WallCellConfigurator {
    
    
    static func setupCell(cell: Wall_CellProtocol, wall: WallProtocol) {
        
        // wall header block >>
        
        // set initial height
        cell.getHConHeaderView().constant = cellHeaderHeight
        cell.getHeaderView().hConRepostTitleTextView.constant = cellQuarterHeight
        cell.getHeaderView().hConOrigAuthorContentView.constant = cellQuarterHeight
        cell.getHeaderView().hConOrigTitleTextView.constant = cellQuarterHeight
        
        // search and hide empty
        var negativeHCon: CGFloat = 0
        if wall.getTitle()?.count == 0 {
            cell.getHeaderView().hConRepostTitleTextView.constant = 0
            negativeHCon += cellQuarterHeight
        }
        
        if wall.getOrigAvaURL() == nil {
            cell.getHeaderView().hConOrigAuthorContentView.constant = 0
            negativeHCon += cellQuarterHeight
        }
        
        if wall.getOrigTitle()?.count == 0 {
            cell.getHeaderView().hConOrigTitleTextView.constant = 0
            negativeHCon += cellQuarterHeight
        }
        
        // parent block: decrease height
        cell.getHConHeaderView().constant -= negativeHCon
        
        
        // set attributes
        cell.getHeaderView().myAvaImageView.kf.setImage(with: wall.getMyAvaURL())
        cell.getHeaderView().myNameLabel.text = wall.getMyName()
        cell.getHeaderView().myPostDateLabel.text = wall.getMyPostDate()
        cell.getHeaderView().myTitleTextView.text = wall.getTitle()
        cell.getHeaderView().myTitleTextView.textContainer.lineBreakMode = .byTruncatingTail
        cell.getHeaderView().origAvaImageView.kf.setImage(with: wall.getOrigAvaURL())
        cell.getHeaderView().origNameLabel.text = wall.getOrigName()
        cell.getHeaderView().origPostDateLabel.text = wall.getOrigPostDate()
        cell.getHeaderView().origTitleTextView.text = wall.getOrigTitle()
        cell.getHeaderView().origTitleTextView.textContainer.lineBreakMode = .byTruncatingTail
        
        
         // wall image block >>
        let URLs = wall.getImageURLs()
        let images = cell.getImagesView()
        for (idx, url) in URLs.enumerated() {
            if idx < 9 {
                images[idx].kf.setImage(with: url)
            }
        }
        
         // wall bottom block >>
        cell.getLikeView().likeCount.text = "\(wall.getLikeCount())"
        cell.getLikeView().messageCount.text = "\(wall.getMessageCount())"
        cell.getLikeView().shareCount.text = "\(wall.getShareCount())"
        cell.getLikeView().eyeCount.text = "\(wall.getEyeCount())"
        
    }

}
