import Foundation


// comment cell talks to tableview about expanding action

protocol CommentCellProtocolDelegate: class {
    func didPressExpand()
}
