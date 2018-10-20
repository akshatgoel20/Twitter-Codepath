

import Foundation
class User {
    var dictionary: [String: Any]?
    
    private static var _current: User?
    
    static var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                }
            }
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
    
    // MARK: Properties
    var name: String?
    var screenName: String?
    var profileImage: URL?
    var profileBanner: URL?
    var followersCount: String?
     var followingCount: String?
     var tweetsCount: String?
    
    init(dictionary: [String: Any]) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImage = URL(string: dictionary["profile_image_url_https"] as! String)
       // profileBanner = URL(string: dictionary["profile_background_image_url"] as! String)
        followersCount = String(dictionary["followers_count"] as! Int)
        followingCount = String(dictionary["friends_count"] as! Int)
        tweetsCount = String(dictionary["statuses_count"] as! Int)
        
        self.dictionary = dictionary
    }
    
}
