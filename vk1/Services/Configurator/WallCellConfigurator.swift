import UIKit
import Kingfisher



class WallCellConfigurator {
    
    
    static func setupCell(cell: Wall_CellProtocol, wall: WallModelProtocol, isExpanded: Bool) {
        
        

        // reposter
        if let name = wall.getMyName(),
            name.count > 0 {
                cell.getReposterHeightCon().constant = 35
                cell.getReposterName().text = wall.getMyName()
                cell.getReposterDate().text = convertUnixTime(unixTime: wall.getMyPostDate())
                cell.getReposterAva().kf.setImage(with: wall.getMyAvaURL())
        } else {
                cell.getReposterHeightCon().constant = 0
                cell.getReposterName().text = ""
                cell.getReposterDate().text = ""
                cell.getReposterAva().image = UIImage(named: "placeholder")
        }
        
        // author
        if let name = wall.getOrigName(),
        name.count > 0 {
            cell.getAuthorHeightCon().constant = 35
            cell.getAuthorName().text = wall.getOrigName()
            cell.getAuthorDate().text = convertUnixTime(unixTime: wall.getOrigPostDate())
            cell.getAuthorAva().kf.setImage(with: wall.getOrigAvaURL())
        } else {
            cell.getAuthorHeightCon().constant = 0
            cell.getAuthorName().text = ""
            cell.getAuthorDate().text = ""
            cell.getAuthorAva().image = UIImage(named: "placeholder")
        }
        
        // post message
        if !isExpanded {
            cell.getExpandButton().isHidden = true
            if let origPostMsg = wall.getOrigTitle() {
                cell.getAuthorPostMsg().text = String(origPostMsg.prefix(160))
                if origPostMsg.count > 160 {
                    cell.getExpandButton().isHidden = false
                }
            }
        } else {
            cell.getExpandButton().isHidden = true
            if let origPostMsg = wall.getOrigTitle() {
                cell.getAuthorPostMsg().text = origPostMsg
            }
        }
        
        // KingfisherConfigurator.clearCache()
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

    }
    
    static func expandCell(cell: Wall_CellProtocol, wall: WallModelProtocol, isExpanded: Bool) {
        cell.getAuthorPostMsg().text = wall.getOrigTitle()
    }
    
    static func calcHeaderHeight(_ cell: Wall_CellProtocol, _ wall: WallModelProtocol) -> CGFloat {
        return 0.0
    }
}
