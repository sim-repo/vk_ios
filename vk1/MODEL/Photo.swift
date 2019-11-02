import Foundation

class Photo {
    var id: Int!
    var imageURL: String!

    
    init(_ id: Int, _ image: String){
        self.id = id;
        self.imageURL = image
    }
    
    public class func list()->[Photo] {
        return [
            Photo(1, "mphoto1"),
            Photo(2, "mphoto2"),
            Photo(3, "mphoto3"),
            Photo(4, "mphoto4"),
            Photo(5, "mphoto5"),
            Photo(6, "mphoto6"),
            Photo(7, "mphoto7"),
            Photo(8, "mphoto8"),
            Photo(9, "mphoto9")
        ]
    }
}
