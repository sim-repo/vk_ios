import Foundation

class Friend {
    var id: Int!
    var name: String!
    var ava: String!
    
    init(id: Int){
        self.id = id
        var index = Int(arc4random_uniform(UInt32(names.count)))
        self.name = names[index]
      
        index = Int(arc4random_uniform(UInt32(pictures.count)))
        self.ava = pictures[index]
    }
    
    private let names = ["Александр","Алексей","Алина","Анна","Алена","Богдан","Борис","Валерий","Василий","Виталий","Владимир","Григорий","Дана","Екатерина","Елена","Елизавета","Зоя","Ирина","Лидия","Марина","Надежда","Оксана", "Amaya", "Noe", "Julius", "Carolina", "Aria", "Meghan", "Braylon", "Celia", "Alijah", "Mathew", "Diego", "Arely", "Stacy", "Mareli", "Brendan", "Harrison", "Olive", "Litzy", "Deven", "Lilliana", "Liam", "Kenley", "Hana", "Devin", "Ali", "Judah", "Carlee", "Fletcher", "Maleah", "Jayla", "Beckham", "Leonidas", "Kyra", "Finnegan", "Genevieve", "Vivian", "Kristin", "Janet", "Alison", "Howard", "Frank", "Ignacio", "Elizabeth", "Zion", "Journey", "Vaughn", "Mateo", "Bridger", "Jaxson", "Mikayla"]
    
    private let pictures = ["face1", "face2", "face3","face4","face4","face5","face6","face7","face8","face9","face10","face11","face12"]
    
    public class func list()->[Friend] {
        var friends: [Friend] = []
        for i in 0...100 {
            let friend = Friend(id: i)
            friends.append(friend)
        }
        
        return friends.sorted(by: { $0.name < $1.name })
    }
}
