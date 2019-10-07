import Foundation

class Group {
    var id: Int!
    var name: String!
    var desc: String!
    var icon: String!
    
    init(_ id: Int, _ name: String, _ desc: String, _ icon: String){
        self.id = id;
        self.name = name
        self.desc = desc
        self.icon = icon
    }
    
    public class func list()->[Group] {
           var groups: [Group] = []
           for i in 0...100 {
               var index = Int(arc4random_uniform(UInt32(CommonElementDesigner.groupNames.count-1)))
               let name = CommonElementDesigner.groupNames[index]
               
               index = Int(arc4random_uniform(UInt32(CommonElementDesigner.groupDesc.count-1)))
               let desc = CommonElementDesigner.groupDesc[index]
               
               index = Int(arc4random_uniform(UInt32(CommonElementDesigner.groupPictures.count-1)))
               let icon = CommonElementDesigner.groupPictures[index]
               groups.append(Group(i, name, desc, icon))
           }
           return groups
       }
}
