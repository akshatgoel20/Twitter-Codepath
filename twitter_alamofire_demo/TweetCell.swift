
import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {

  

    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileUsernameLabel: UILabel!
    @IBOutlet weak var tweetDateLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var tweetRetweetLabel: UILabel!
    @IBOutlet weak var tweetFavorLabel: UILabel!
    @IBOutlet weak var tweetFavorButton: UIButton!
    @IBOutlet weak var tweetRetweetButton: UIButton!
    
    var tweet: Tweet!{
        didSet{
            refreshData()
        }
    }

    @IBAction func onFavorite(_ sender: Any) {
        if(tweet.favorited == false){
            tweet.favorited = true
            tweet.favoriteCount! += 1
            refreshData()
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text ?? " ")")
                }
            }
        }
        else{
            tweet.favorited = false
            tweet.favoriteCount! -= 1
            refreshData()
            APIManager.shared.unFavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text ?? " ")")
                }
            }
        }
        
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        if(tweet.retweeted == false){
            tweet.retweeted = true
            tweet.retweetCount! += 1
            refreshData()
            APIManager.shared.retweet(with: tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error retweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweeted the following Tweet: \n\(tweet.text ?? " ")")
                }
            }
        }
        else{
            tweet.retweeted = false
            tweet.retweetCount! -= 1
            refreshData()
            APIManager.shared.unRetweet(with: tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unretweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unretweeted the following Tweet: \n\(tweet.text ?? " ")")
                }
            }
        }
    }
    
    func refreshData(){
        tweetTextLabel.text = tweet.text
        profileNameLabel.text = tweet.user?.name
        let user = tweet.user?.screenName!
        profileUsernameLabel.text = "@\(user ?? "Anon")"
        tweetDateLabel.text = tweet.createdAtString
        tweetRetweetLabel.text = String(tweet.retweetCount!)
        tweetFavorLabel.text = String(tweet.favoriteCount!)
        if(tweet.favorited)!
        {
            tweetFavorButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        }
        else
        {
            tweetFavorButton.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
        
        if(tweet.retweeted)!
        {
            tweetRetweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
        }
        else
        {
            tweetRetweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
        }

        profilePictureImage.af_setImage(withURL: (tweet.user!.profileImage!))
        
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
