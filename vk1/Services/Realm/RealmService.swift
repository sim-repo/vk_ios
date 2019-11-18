import Foundation
import RealmSwift

class RealmService {
    
    static var configuration: Realm.Configuration {
        return Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    }
    
    

    public static func save(models: [ModelProtocol], update: Bool) {
        var objects: [Object] = []
        
        for model in models {
            switch model {
                
            case is Wall:
                let m = model as! Wall
                let obj = wallToRealm(m)
                objects.append(obj)
                
            case is Friend:
                let m = model as! Friend
                let obj = friendToRealm(m)
                objects.append(obj)
                
            case is MyGroup:
                let m = model as! MyGroup
                let obj = myGroupToRealm(m)
                objects.append(obj)
                
            case is Group:
                let m = model as! Group
                let obj = groupToRealm(m)
                objects.append(obj)
                
            case is DetailGroup:
                let m = model as! DetailGroup
                let obj = detailGroupToRealm(m)
                objects.append(obj)
                
            default:
                catchError(msg: "RealmService: save(models:): no case for \(model)")
                
            }
        }
        save(items: objects, update: update)
    }
    
    
    public static func save<T: Object>(items: [T], update: Bool) {
        let realm = getInstance()
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
    
    
    public static func delete(clazz: Object.Type, id: typeId? = nil) {
        let realm = getInstance()
        do {
            try realm?.write {
                // by id
                if let _id = id {
                    let predicate = NSPredicate(format: "id = %@", _id)
                    if let results = realm?.objects(clazz.self).filter(predicate) {
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
    
    
    
    public static func clearAll(clazz: Object.Type) {
        let realm = getInstance()
        do {
            try realm?.write {
                realm?.deleteAll()
            }
        } catch(let err) {
            catchError(msg: err.localizedDescription)
        }
    }
    
    

    
    private static func getInstance() -> Realm? {
        do {
            let realm = try Realm(configuration: RealmService.configuration)
            console(msg: "Realm DB Path: \(realm.configuration.fileURL)")
            return realm
        } catch(let err) {
            catchError(msg: err.localizedDescription)
        }
        return nil
    }
    
    
    
    //MARK:- load models
    
    public static func loadWall(filter: String? = nil) -> [Wall]? {
        var results: Results<RealmWall>
        do {
            let realm = try Realm()
            if let _filter = filter {
                results = realm.objects(RealmWall.self).filter(_filter)
            } else {
                results = realm.objects(RealmWall.self)
            }
            let walls = realmToWall(results: results)
            return walls
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    
    
    public static func loadFriend(filter: String? = nil) -> [Friend]? {
         var results: Results<RealmFriend>
        do {
            let realm = try Realm()
            
            if let _filter = filter {
                results = realm.objects(RealmFriend.self).filter(_filter)
            } else {
                results = realm.objects(RealmFriend.self)
            }
            let friends = realmToFriend(results: results)
            return friends
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    
    public static func loadGroup(filter: String? = nil) -> [Group]? {
         var results: Results<RealmGroup>
        do {
            let realm = try Realm()
            
            if let _filter = filter {
                results = realm.objects(RealmGroup.self).filter(_filter)
            } else {
                results = realm.objects(RealmGroup.self)
            }
            let groups = realmToGroup(results: results)
            return groups
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    
    public static func loadMyGroup(filter: String? = nil) -> [MyGroup]? {
         var results: Results<RealmMyGroup>
        do {
            let realm = try Realm()
            
            if let _filter = filter {
                results = realm.objects(RealmMyGroup.self).filter(_filter)
            } else {
                results = realm.objects(RealmMyGroup.self)
            }
            let groups = realmToMyGroup(results: results)
            return groups
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    
    public static func loadDetailGroup(filter: String? = nil) -> [DetailGroup]? {
        var results: Results<RealmDetailGroup>
        do {
            let realm = try Realm()
            
            if let _filter = filter {
                results = realm.objects(RealmDetailGroup.self).filter(_filter)
            } else {
                results = realm.objects(RealmDetailGroup.self)
            }
            let groups = realmToDetailGroup(results: results)
            return groups
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    
    
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
}
