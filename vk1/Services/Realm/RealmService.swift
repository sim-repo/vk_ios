import Foundation
import RealmSwift

class RealmService {
    
    
    enum RealmConfigEnum {
        
        case unsafe
        case safe
        
        private static let safeConfig = Realm.Configuration (
            fileURL: getRealmURL(dbName: "safe"),
            encryptionKey: getKey() as Data,
            deleteRealmIfMigrationNeeded: true
        )
        
        private static let mainConfig = Realm.Configuration (
            fileURL:  getRealmURL(dbName: "main"),
            deleteRealmIfMigrationNeeded: true
        )
        
        var config: Realm.Configuration {
            switch self {
            case .safe:
                return RealmConfigEnum.safeConfig
            default:
                return RealmConfigEnum.mainConfig
            }
        }
    }
    

    //MARK:- public
    
    public static func loadToken() -> (String?, Int?)? {

        guard let realm = getInstance(.safe)
        else {
            return nil
        }
        let token: String? = realm.objects(RealmToken.self).first?.token
        let userId: Int? = realm.objects(RealmToken.self).first?.userId
        
        return (token, userId)
    }
    
    
    public static func loadFirebaseCredentials() -> (String?, String?)? {

        guard let realm = getInstance(.safe)
        else {
            return nil
        }
        let login: String? = realm.objects(RealmFirebase.self).first?.login
        let psw: String? = realm.objects(RealmFirebase.self).first?.psw
        
        return (login, psw)
    }
    
    
    
    public static func loadNews(filter: String? = nil) -> [News]? {
        
        var results: Results<RealmNews>
        guard let realm = getInstance(.unsafe) else { return nil }
        
        if let _filter = filter {
            results = realm.objects(RealmNews.self).filter(_filter)
        } else {
            results = realm.objects(RealmNews.self)
        }
        let news = realmToNews(results: results)
        return news
    }
    
    
    public static func newsLastPostDate() -> Int? {
        var results: Results<RealmNews>
        guard let realm = getInstance(.unsafe) else { return nil }
        results = realm.objects(RealmNews.self)
        let sorted = results.sorted(byKeyPath: "postDate", ascending: false)
        let n = sorted.first
        return n?.postDate
    }
    
    
    
    public static func loadWall(filter: String? = nil) -> [Wall]? {
        
        var results: Results<RealmWall>
        guard let realm = getInstance(.unsafe) else { return nil }
        
        if let _filter = filter {
            results = realm.objects(RealmWall.self).filter(_filter)
        } else {
            results = realm.objects(RealmWall.self)
        }
        let walls = realmToWall(results: results)
        return walls
    }

    
    public static func loadFriend(filter: String? = nil) -> [Friend]? {
        
        var results: Results<RealmFriend>
        guard let realm = getInstance(.unsafe) else { return nil }
            
        if let _filter = filter {
            results = realm.objects(RealmFriend.self).filter(_filter)
        } else {
            results = realm.objects(RealmFriend.self)
        }
        let friends = realmToFriend(results: results)
        return friends
    }
    
    
    public static func loadGroup(filter: String? = nil) -> [Group]? {
        
        var results: Results<RealmGroup>
        guard let realm = getInstance(.unsafe) else { return nil }
        if let _filter = filter {
            results = realm.objects(RealmGroup.self).filter(_filter)
        } else {
            results = realm.objects(RealmGroup.self)
        }
        let groups = realmToGroup(results: results)
        return groups
    }
    
    
    public static func loadMyGroup(filter: String? = nil) -> [MyGroup]? {
        
        var results: Results<RealmMyGroup>
        guard let realm = getInstance(.unsafe) else { return nil }
        if let _filter = filter {
            results = realm.objects(RealmMyGroup.self).filter(_filter)
        } else {
            results = realm.objects(RealmMyGroup.self)
        }
        let groups = realmToMyGroup(results: results)
        return groups
    }
    
    
    public static func loadDetailGroup(filter: String? = nil) -> [DetailGroup]? {
        var results: Results<RealmDetailGroup>
        
        guard let realm = getInstance(.unsafe) else { return nil }
        if let _filter = filter {
            results = realm.objects(RealmDetailGroup.self).filter(_filter)
        } else {
            results = realm.objects(RealmDetailGroup.self)
        }
        let groups = realmToDetailGroup(results: results)
        return groups
    }
    
    
    public static func delete(moduleEnum: ModuleEnum, id: typeId? = nil) {
        switch moduleEnum {
            case .news: delete(confEnum: .unsafe, clazz: RealmNews.self)
            case .friend: delete(confEnum: .unsafe, clazz: RealmFriend.self)
            case .friend_wall, .my_group_wall: delete(confEnum: .unsafe, clazz: RealmWall.self, id: id)
        default:
            catchError(msg: "RealmService(): delete(): no case is found")
        }
    }
    
    
    public static func save(models: [ModelProtocol], update: Bool) {
        var objects: [Object] = []
        
        for model in models {
            switch model {
                
            case is Wall:
                let m = model as! Wall
                let obj = wallToRealm(m)
                objects.append(obj)
                break
                
            case is Friend:
                let m = model as! Friend
                let obj = friendToRealm(m)
                objects.append(obj)
                break
                
            case is MyGroup:
                let m = model as! MyGroup
                let obj = myGroupToRealm(m)
                objects.append(obj)
                break
                
            case is Group:
                let m = model as! Group
                let obj = groupToRealm(m)
                objects.append(obj)
                break
                
            case is DetailGroup:
                let m = model as! DetailGroup
                let obj = detailGroupToRealm(m)
                objects.append(obj)
                break
                
            case is News:
                let m = model as! News
                let obj = newsToRealm(m)
                objects.append(obj)
                break
                
            default:
                catchError(msg: "RealmService: save(models:): no case for \(model)")
                
            }
        }
        save(items: objects, update: update)
    }
    
    
    
    public static func saveVKCredentials(token: String, userId: Int) {
        let realm = getInstance(.safe)
        do {
            try realm?.write {
                let obj = RealmToken()
                obj.token = token
                obj.userId = userId
                realm?.add(obj, update: .all)
            }
        } catch(let err) {
            catchError(msg: err.localizedDescription)
        }
    }
    
    
    public static func saveFirebaseCredentials(login: String, psw: String) {
        let realm = getInstance(.safe)
        do {
            try realm?.write {
                let obj = RealmFirebase()
                obj.login = login
                obj.psw = psw
                realm?.add(obj, update: .all)
            }
        } catch(let err) {
            catchError(msg: err.localizedDescription)
        }
    }
    
    
    
    
    //MARK:- private:
    
    private static func getInstance(_ confEnum: RealmConfigEnum) -> Realm? {
        do {
            let realm = try Realm(configuration: confEnum.config)
            console(msg: "Realm DB Path: \(realm.configuration.fileURL?.absoluteString ?? "")", printEnum: .realm)
            return realm
        } catch(let err) {
            catchError(msg: err.localizedDescription)
        }
        return nil
    }
    
    

    
    
    private static func save<T: Object>(items: [T], update: Bool) {
        let realm = getInstance(.unsafe)
        do {
            try realm?.write {
                if update {
                    realm?.add(items, update: .all)
                } else {
                    realm?.add(items)
                }
            }
        } catch(let err) {
            catchError(msg: err.localizedDescription)
        }
    }
    
    
    
    
    private static func delete(confEnum: RealmConfigEnum, clazz: Object.Type, id: typeId? = nil) {
        let realm = getInstance(confEnum)
        do {
            try realm?.write {
                // by id
                if let _id = id {
                    if let results = realm?.objects(clazz.self).filter("id == %@", _id) {
                        for result in results {
                            realm?.delete(result)
                        }
                    }
                } else {
                    if let results = realm?.objects(clazz.self) {
                        for result in results {
                            realm?.delete(result)
                        }
                    }
                }
            }
        } catch(let err) {
            catchError(msg: err.localizedDescription)
        }
    }
    
    
    
    private static func clearAll(confEnum: RealmConfigEnum) {
        let realm = getInstance(confEnum)
        do {
            try realm?.write {
                realm?.deleteAll()
            }
        } catch(let err) {
            catchError(msg: err.localizedDescription)
        }
    }
    
    


    
    
    //MARK:- load models
    

    
    
    //MARK:- transofm: model into realm
    
    private static func wallToRealm(_ wall: Wall) -> RealmWall {
        let realmWall = RealmWall()
        realmWall.id = wall.id
        realmWall.ownerId = wall.ownerId
        realmWall.myName = wall.myName
        realmWall.origName = wall.origName
        realmWall.myPostDate = wall.myPostDate
        realmWall.origPostDate = wall.origPostDate
        realmWall.myAvaURL = wall.myAvaURL?.absoluteString ?? ""
        realmWall.origAvaURL = wall.origAvaURL?.absoluteString ?? ""
        realmWall.title = wall.title
        realmWall.origTitle = wall.origTitle
        realmWall.postTypeCode = wall.postTypeCode
        realmWall.viewCount = wall.viewCount
        realmWall.likeCount = wall.likeCount
        realmWall.messageCount = wall.messageCount
        realmWall.offset = wall.offset
        
        let realmImagesURL = List<RealmURL>()
        var count = 0
        for url in wall.imageURLs {
            let realmURL = RealmURL()
            realmURL.id = wall.id + count
            count += 1
            realmURL.url = url.absoluteString
            realmImagesURL.append(realmURL)
        }
        realmWall.imageURLs = realmImagesURL
        
        return realmWall
    }
    
    private static func newsToRealm(_ news: News) -> RealmNews {
        let realmNews = RealmNews()
        realmNews.id = news.id
        // service fields:
        realmNews.ownOffset = news.ownOffset
        realmNews.vkOffset = news.vkOffset
        // others:
        realmNews.ownerId = news.ownerId
        realmNews.name = news.name
        realmNews.postDate = Int(news.postDate)
        realmNews.avaURL = news.avaURL?.absoluteString ?? ""
        realmNews.title = news.title
        realmNews.postTypeCode = news.postTypeCode
        realmNews.viewCount = news.viewCount
        realmNews.likeCount = news.likeCount
        realmNews.messageCount = news.messageCount
        realmNews.createDate = news.createDate
        
        let realmImagesURL = List<RealmURL>()
        var count = 0
        for url in news.imageURLs {
            let realmURL = RealmURL()
            realmURL.id = news.id + count
            count += 1
            realmURL.url = url.absoluteString
            realmImagesURL.append(realmURL)
        }
        realmNews.imageURLs = realmImagesURL
        
        return realmNews
    }
    
    
    private static func friendToRealm(_ friend: Friend) -> RealmFriend {
        let realmFriend = RealmFriend()
        realmFriend.id = friend.id
        realmFriend.firstName = friend.firstName
        realmFriend.lastName = friend.lastName
        realmFriend.avaURL50 = friend.avaURL50?.absoluteString ?? ""
        realmFriend.avaURL100 = friend.avaURL100?.absoluteString ?? ""
        realmFriend.avaURL200 = friend.avaURL200?.absoluteString ?? ""
        realmFriend.groupBy = friend.groupBy.rawValue
        return realmFriend
    }
    
    private static func myGroupToRealm(_ myGroup: MyGroup) -> RealmMyGroup {
        let realmMyGroup = RealmMyGroup()
        
        realmMyGroup.id = myGroup.id
        realmMyGroup.name = myGroup.name
        realmMyGroup.desc = myGroup.desc
        realmMyGroup.avaURL50 = myGroup.avaURL50?.absoluteString ?? ""
        realmMyGroup.avaURL200 = myGroup.avaURL200?.absoluteString ?? ""
        realmMyGroup.groupBy = myGroup.groupBy.rawValue
        realmMyGroup.coverURL400 = myGroup.coverURL400?.absoluteString ?? ""
        realmMyGroup.membersCount = myGroup.membersCount
        realmMyGroup.isClosed = myGroup.isClosed
        realmMyGroup.isDeactivated = myGroup.isDeactivated
        
        return realmMyGroup
    }
    
    private static func groupToRealm(_ group: Group) -> RealmGroup {
        let realmGroup = RealmGroup()
        
        realmGroup.id = group.id
        realmGroup.name = group.name
        realmGroup.desc = group.desc
        realmGroup.avaURL50 = group.avaURL50?.absoluteString ?? ""
        realmGroup.avaURL200 = group.avaURL200?.absoluteString ?? ""
        realmGroup.groupBy = group.groupBy.rawValue
        realmGroup.coverURL400 = group.coverURL400?.absoluteString ?? ""
        realmGroup.membersCount = group.membersCount
        realmGroup.isClosed = group.isClosed
        realmGroup.isDeactivated = group.isDeactivated
        
        return realmGroup
    }
    
    private static func detailGroupToRealm(_ detailGroup: DetailGroup) -> RealmDetailGroup {
        let realmGroup = RealmDetailGroup()
        
        realmGroup.id = detailGroup.id
        realmGroup.name = detailGroup.name
        realmGroup.desc = detailGroup.desc
        realmGroup.avaURL50 = detailGroup.avaURL50?.absoluteString ?? ""
        realmGroup.avaURL200 = detailGroup.avaURL200?.absoluteString ?? ""
        realmGroup.coverURL400 = detailGroup.coverURL400?.absoluteString ?? ""
        realmGroup.membersCount = detailGroup.membersCount
        realmGroup.isClosed = detailGroup.isClosed
        realmGroup.isDeactivated = detailGroup.isDeactivated
        
        realmGroup.photosCounter = detailGroup.photosCounter
        realmGroup.albumsCounter = detailGroup.albumsCounter
        realmGroup.topicsCounter = detailGroup.topicsCounter
        realmGroup.videosCounter = detailGroup.videosCounter
        realmGroup.marketCounter = detailGroup.marketCounter
        
        return realmGroup
    }
    
    
    //MARK:- transofm: realm to model
    
    private static func realmToWall(results: Results<RealmWall>) -> [Wall] {
        var walls = [Wall]()
        for result in results {
            let wall = Wall()
            wall.id = typeId(result.id)
            wall.ownerId = result.ownerId
            wall.myName = result.myName
            wall.origName = result.myName
            wall.origName = result.origName
            wall.myPostDate = result.myPostDate
            wall.origPostDate = result.origPostDate
            wall.myAvaURL = URL(string: result.myAvaURL)
            wall.origAvaURL = URL(string: result.origAvaURL)
            wall.title = result.title
            wall.origTitle = result.origTitle
            wall.postTypeCode = result.postTypeCode
            wall.viewCount = result.viewCount
            wall.likeCount = result.likeCount
            wall.messageCount = result.messageCount
            
            var imagesURL = [URL]()
            for url in result.imageURLs {
                if let sURL = URL(string: url.url) {
                    imagesURL.append(sURL)
                }
            }
            wall.imageURLs = imagesURL
            walls.append(wall)
        }
        return walls
    }
    
    
    
    private static func realmToNews(results: Results<RealmNews>) -> [News] {
        var newsArr = [News]()
        for result in results {
            let news = News()
            news.id = typeId(result.id)
            news.ownerId = result.ownerId
            news.name = result.name
            news.postDate = Double(result.postDate)
            news.avaURL = URL(string: result.avaURL)
            news.title = result.title
            news.postTypeCode = result.postTypeCode
            news.viewCount = result.viewCount
            news.likeCount = result.likeCount
            news.messageCount = result.messageCount
            news.vkOffset = result.vkOffset
            var imagesURL = [URL]()
            for url in result.imageURLs {
                if let sURL = URL(string: url.url) {
                    imagesURL.append(sURL)
                }
            }
            news.imageURLs = imagesURL
            newsArr.append(news)
        }
        return newsArr
    }
    
    
    
    private static func realmToFriend(results: Results<RealmFriend>) -> [Friend] {
        var friends = [Friend]()
        
        for result in results {
            let friend = Friend()
            friend.id = typeId(result.id)
            friend.firstName = result.firstName
            friend.lastName = result.lastName
            friend.avaURL50 = URL(string: result.avaURL50)
            friend.avaURL100 = URL(string: result.avaURL100)
            friend.avaURL200 = URL(string: result.avaURL200)
            if let groupBy = FriendGroupByEnum(rawValue: result.groupBy) {
                friend.groupBy = groupBy
            }
            friends.append(friend)
        }
        return friends
    }
    
    
    
    private static func realmToGroup(results: Results<RealmGroup>) -> [Group] {
        var groups = [Group]()
        
        for result in results {
            let group = Group()
            group.id = result.id
            group.name = result.name
            group.desc = result.desc
            group.avaURL50 = URL(string: result.avaURL50)
            group.avaURL200 = URL(string: result.avaURL200)
            if let groupBy = MyGroupByEnum(rawValue: result.groupBy) {
                group.groupBy = groupBy
            }
            group.coverURL400 = URL(string: result.coverURL400)
            group.membersCount = result.membersCount
            group.isClosed = result.isClosed
            group.isDeactivated = result.isDeactivated
            
            groups.append(group)
        }
        return groups
    }
    
    
    private static func realmToMyGroup(results: Results<RealmMyGroup>) -> [MyGroup] {
        var groups = [MyGroup]()
        
        for result in results {
            let group = MyGroup()
            group.id = typeId(result.id)
            group.name = result.name
            group.desc = result.desc
            group.avaURL50 = URL(string: result.avaURL50)
            group.avaURL200 = URL(string: result.avaURL200)
            if let groupBy = MyGroupByEnum(rawValue: result.groupBy) {
                group.groupBy = groupBy
            }
            group.coverURL400 = URL(string: result.coverURL400)
            group.membersCount = result.membersCount
            group.isClosed = result.isClosed
            group.isDeactivated = result.isDeactivated
            
            groups.append(group)
        }
        return groups
    }
    
    
    
    private static func realmToDetailGroup(results: Results<RealmDetailGroup>) -> [DetailGroup] {
        var detailGroups = [DetailGroup]()
        
        for result in results {
            let detailGroup = DetailGroup()
            
            detailGroup.id = result.id
            detailGroup.name = result.name
            detailGroup.desc = result.desc
            detailGroup.avaURL50 = URL(string: result.avaURL50)
            detailGroup.avaURL200 = URL(string: result.avaURL200)
            detailGroup.coverURL400 = URL(string: result.coverURL400)
            detailGroup.membersCount = result.membersCount
            detailGroup.isClosed = result.isClosed
            detailGroup.isDeactivated = result.isDeactivated
            
            detailGroup.photosCounter = result.photosCounter
            detailGroup.albumsCounter = result.albumsCounter
            detailGroup.topicsCounter = result.topicsCounter
            detailGroup.videosCounter = result.videosCounter
            detailGroup.marketCounter = result.marketCounter
            detailGroups.append(detailGroup)
        }
        return detailGroups
    }
    
    
    
    private static func getKey() -> NSData {
        // Identifier for our keychain entry - should be unique for your application
        let keychainIdentifier = "io.Realm.EncryptionExampleKey"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!

        // First check in the keychain for an existing key
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]

        // To avoid Swift optimization bug, should use withUnsafeMutablePointer() function to retrieve the keychain item
        // See also: http://stackoverflow.com/questions/24145838/querying-ios-keychain-using-swift/27721328#27721328
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as! NSData
        }

        // No pre-existing key from this application, so generate a new one
        let keyData = NSMutableData(length: 64)!
        let result = SecRandomCopyBytes(kSecRandomDefault, 64, keyData.mutableBytes.bindMemory(to: UInt8.self, capacity: 64))
        assert(result == 0, "Failed to get random bytes")

        // Store the key in the keychain
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: keyData
        ]

        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")

        return keyData
    }
}
