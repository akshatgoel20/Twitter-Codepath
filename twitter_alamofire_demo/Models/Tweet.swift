

import Foundation
import DateToolsSwift

class Tweet {
    
    // MARK: Properties
    var id: Int? // For favoriting, retweeting & replying
    var text: String? // Text content of tweet
    var favoriteCount: Int? // Update favorite count label
    var favorited: Bool? // Configure favorite button
    var retweetCount: Int? // Update favorite count label
    var retweeted: Bool? // Configure retweet button
    var user: User? // Author of the Tweet
    var createdAtString: String? // String representation of date posted
    var createdAtStringLong: String? // String representation of date posted
    
//    var replyCount: Int? // Update favorite count label
    
    // For Retweets
    var retweetedByUser: User?  // user who retweeted if tweet is retweet
    
    init(dictionary: [String: Any]) {
        var dictionary = dictionary
        
        // Is this a re-tweet?
        if let originalTweet = dictionary["retweeted_status"] as? [String: Any] {
            let userDictionary = dictionary["user"] as! [String: Any]
            self.retweetedByUser = User(dictionary: userDictionary)
            
            // Change tweet to original tweet
            dictionary = originalTweet
        }
        
        id = (dictionary["id"] as! Int)
        text = (dictionary["text"] as! String)
        favoriteCount = dictionary["favorite_count"] as? Int
        favorited = dictionary["favorited"] as? Bool
        retweetCount = (dictionary["retweet_count"] as! Int)
        retweeted = (dictionary["retweeted"] as! Bool)
  //      replyCount = (dictionary["reply_count"] as! Int)
        
        // initialize user
        let user = dictionary["user"] as! [String: Any]
        self.user = User(dictionary: user)
        
        // Format createdAt date string
        let createdAtOriginalString = dictionary["created_at"] as! String
        let formatter = DateFormatter()
        // Configure the input format to parse the date string
        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
        // Convert String to Date
        let date = formatter.date(from: createdAtOriginalString)
        createdAtString = date?.shortTimeAgoSinceNow
        // Configure output format
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        // Convert Date to String and set the createdAtString property
        createdAtStringLong = formatter.string(from: date!)
      
    }
   /* static func tweets(with array: [[String: Any]]) -> [Tweet] {
        var tweets: [Tweet] = []
        for tweetDictionary in array {
            let tweet = Tweet(dictionary: tweetDictionary)
            tweets.append(tweet)
        }
        return tweets
    }*/
    //FLATMAP
    static func tweets(with array: [[String: Any]]) -> [Tweet] {
        return array.flatMap({ (dictionary) -> Tweet in
            Tweet(dictionary: dictionary)
        })
    }
}
