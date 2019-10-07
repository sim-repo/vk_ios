import UIKit


class CommonElementDesigner {
    
    static var cellByCode = ["tp1": "Wall_Cell_tp1",
                             "tp2": "Wall_Cell_tp2",
                             "tp3": "Wall_Cell_tp3",
                             "tp4": "Wall_Cell_tp4",
                             "tp5": "Wall_Cell_tp5",
                             "tp6": "Wall_Cell_tp6",
                             "tp7": "Wall_Cell_tp7",
                             "tp8": "Wall_Cell_tp8",
                             "tp9": "Wall_Cell_tp9",]
    
    
    static func setupNavigationBarColor(navigationController: UINavigationController?){
        var colors = [UIColor]()
        colors.append(UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 0.95))
        colors.append(UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.95))
        colors.append(UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 0.95))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
    }
    
    static func setupLikeControl(like: UserActivityRegControl, likeCount: UILabel, message: UserActivityRegControl, eye: UserActivityRegControl, share: UserActivityRegControl) {
        like.isUserInteractionEnabled = true
        message.isUserInteractionEnabled = true
        eye.isUserInteractionEnabled = true
        share.isUserInteractionEnabled = true
        
        like.alpha = CommonElementDesigner.likeControlAlpha
        message.alpha = CommonElementDesigner.likeControlAlpha
        eye.alpha = CommonElementDesigner.likeControlAlpha
        share.alpha = CommonElementDesigner.likeControlAlpha
        
        
        like.userActivityType = .like
        like.boundMetrics = likeCount
        message.userActivityType = .shake
        eye.userActivityType = .shake
        share.userActivityType = .shake
    }
    
    
    static let comments = ["Thanks so much for the birthday money","Thanks so much for driving me home","I really appreciate your help","Thanks so much for cooking dinner. I really appreciate it...","Thanks so much. ...","Excuse me sir, you dropped your wallet)))","Excuse me, do you know what time it is?","I'm sorry for being so late.=/","Be careful!!!","Be careful driving!!","Can you translate this for me????","Chicago is very different from Boston))","Don't worry..","Everyone knows it.","Everything is ready.","Excellent.","From time to time.","Good idea.","He likes it very much.","Help!","He's coming soon.","He's right.", "He's very annoying.", "He's very famous.", "How are you?", "How's work going?", "I ate already.", "I can't hear you.", "I'd like to go for a walk.", "I don't know how to use it.", "I don't like him.", "I don't like it.", "I don't speak very well.", "I don't understand.", "I don't want it.", "I don't want that.", "I don't want to bother you.", "I feel good.", "If you need my help, please let me know.", "I get off of work at 6.", "I have a headache.", "I hope you and your wife have a nice trip.", "I know.", "I like her.", "I'll call you when I leave.", "I'll come back later.", "I'll pay.", "I'll take it.", "I'll take you to the bus stop.", "I love you.", "I'm an American.", "I'm cleaning my room.", "I'm coming to pick you up.", "I'm cold.", "I'm going to leave.", "I'm good, and you?", "I'm happy.", "I'm hungry.", "I'm not busy.", "I'm not ready yet.", "I'm not sure.", "I'm sorry, we're sold out.", "I'm thirsty.", "I'm very busy. I don't have time now.", "I need to change clothes.", "I need to go home.", "I only want a snack.", "Is Mr. Smith an American?", "I think it tastes good.", "I think it's very good.", "I was about to leave the restaurant when my friends arrived.", "Just a moment."]

    static let emoji = ["😀","😃","😄","😁","😅","🤣","☺️","😊","😉","🙃","😇","😍","😘","😗","😙","😝","😋","😚","🤪","🤨","🧐","😎","🤩","🥳","😏","😒","😡","😠","😭","🤬","😳","🥶","😓","😥","😱","🤮","😴","🤤","😈","🤠","🤑","👻","🤖","🎃","😹","🤟🏾","🤞🏾","☝🏽"]
    
    static let names = ["Александр","Алексей","Алина","Анна","Алена","Богдан","Борис","Валерий","Василий","Виталий","Владимир","Григорий","Дана","Екатерина","Елена","Елизавета","Зоя","Ирина","Лидия","Марина","Надежда","Оксана", "Amaya", "Noe", "Julius", "Carolina", "Aria", "Meghan", "Braylon", "Celia", "Alijah", "Mathew", "Diego", "Arely", "Stacy", "Mareli", "Brendan", "Harrison", "Olive", "Litzy", "Deven", "Lilliana", "Liam", "Kenley", "Hana", "Devin", "Ali", "Judah", "Carlee", "Fletcher", "Maleah", "Jayla", "Beckham", "Leonidas", "Kyra", "Finnegan", "Genevieve", "Vivian", "Kristin", "Janet", "Alison", "Howard", "Frank", "Ignacio", "Elizabeth", "Zion", "Journey", "Vaughn", "Mateo", "Bridger", "Jaxson", "Mikayla"]
    
    static let pictures = ["face1", "face2", "face3","face4","face4","face5","face6","face7","face8","face9","face10","face11","face12","pic1", "pic2", "pic3","pic4","pic4","pic5","pic6","pic7","pic8","pic9","pic10","pic11","pic12","pic13","pic14","pic15","pic16","pic17","pic18","pic19","pic20"]
    
    static let likeControlAlpha: CGFloat = 0.6
    
    static let groupIcons =
    ["🍏","🍎","🍐","🍊","🥭","🥝","🌶","🥔","🥨","🧀","🥚","🏀","🏈","⚾️","🥎","🎣","🏒","🏓","🥊","🚒","🚨","🛵","🚋","🚟","🚆","🚂","🚈","🚅","📱","🧲",]
    
    static let groupNames =
        ["abandon", "ability","bake","balance","ball","ban","band","bank","baseball","calculat","call","camera","camp","campaign","campus","can","ivision","divorce","DNA","do","doctor","document","dog","domestic","dominant","dominate","door","effect","effective","effectively","efficiency","efficient","effort","failure","fair","fairly","faith","fall","false","familiar","family","famous","fan","eneral","generally","generate","generation","genetic","gentleman","gently","Irish","iron","Islamic","island","Israeli","issue","it","Italian","item","its","itself","jacket","jail","Japanese","jet","Jew","Jewis"]
    
    
    static let groupDesc =
           ["Abstract enables designers to reliably version and manage their Sketch files. By leveraging and extends the technology of git, Abstract provide design teams with a lightweight workflow and stable tools so designers can work together with confidence.", "On the heels of leading influential projects for Nike and Instagram, Ian Spalter explains the process of experimenting with new product designs.","While researching vintage watches as inspiration for a new font, Jonathan Hoefler delves into his work for Apple, Obama's Change campaign and more.","A young postman and a reclusive toymaker become unlikely friends in Klaus",
           "A young woman wakes up in a morgue with inexplicable powers and gets caught in a battle between good and evil. Inspired by the manga novels.",
           "Pressured to marry a nice Orthodox Jewish woman, Motti is thrown for a loop when he falls for classmate Laura, who his mother will never approve of.",
       "Virtual reality (VR) is a simulated experience that can be similar to or completely different from the real world. Applications of virtual reality can include entertainment (i.e. gaming) and educational purposes (i.e. medical or military training). Other, distinct types of VR style technology include augmented reality and mixed reality.",
       "This course will teach you about one of the most important aspects of VR, how you interact with a VR world. Virtual Reality is completely different from an on screen app or game. You are completely immersed in a VR world, so it doesn't make sense to interact only through buttons or menus. You will get the most out of VR if you can interact with the world just as you would with the real world: with your natural body movements."
       ]
    
    static let groupPictures =
        ["group1", "group2","group3","group4","group5","group6","group7","group8","group9","group10","group11","group12","group13","group14","grou15","group2"]
}
