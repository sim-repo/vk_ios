import UIKit
import Kingfisher



class WallCellConfigurator {
    
    
    static func setupCell(cell: Wall_CellProtocol, wall: WallModelProtocol) {
        
        // wall header block >>
        
        // set initial height
        cell.getHConHeaderView().constant = WallCellConstant.headerHeight
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
        
        
        // set attributes
        cell.getHeaderView().myAvaImageView.kf.setImage(with: wall.getMyAvaURL())
        cell.getHeaderView().myNameLabel.text = wall.getMyName()
        
        cell.getHeaderView().myPostDateLabel.text = convertUnixTime(unixTime: wall.getMyPostDate())
        cell.getHeaderView().myTitleTextView.text = wall.getTitle()
        cell.getHeaderView().myTitleTextView.textContainer.lineBreakMode = .byTruncatingTail
        cell.getHeaderView().origAvaImageView.kf.setImage(with: wall.getOrigAvaURL())
        cell.getHeaderView().origNameLabel.text = wall.getOrigName()
        cell.getHeaderView().origPostDateLabel.text = convertUnixTime(unixTime: wall.getOrigPostDate())
        cell.getHeaderView().origTitleTextView.text = wall.getOrigTitle()
        cell.getHeaderView().origTitleTextView.textContainer.lineBreakMode = .byWordWrapping
        cell.getHeaderView().origTitleTextView.textContainer.maximumNumberOfLines = 4
        
        
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

}
