import Foundation


// wall cell talks to collectionView about expanding action

protocol WallCellProtocolDelegate: class {
    func didPressExpand(isExpand: Bool, indexPath: IndexPath)
}




// wall header cell talks to collectionCell about expanding action

protocol WallHeaderProtocolDelegate: class {
    func didPressExpand()
}
