import Foundation

protocol ModelProtocol: class {
    func getId() -> typeId
    func getSortBy() -> String
}


protocol SectionModelProtocol: ModelProtocol {
    func getGroupBy()->String
}

protocol PlainModelProtocol: ModelProtocol {
}
