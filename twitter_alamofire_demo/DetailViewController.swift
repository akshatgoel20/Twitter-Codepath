
import UIKit
import AlamofireImage

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailUsername: UILabel!
    @IBOutlet weak var detailDate: UILabel!
    @IBOutlet weak var detailTweetText: UILabel!
    
    @IBOutlet weak var detailFavoriteButton: UIButton!
    @IBOutlet weak var detailFavoriteCount: UILabel!
    @IBOutlet weak var detailRetweetButton: UIButton!
    @IBOutlet weak var detailRetweetCount: UILabel!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func detailOnFavorite(_ sender: Any) {
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
    
    @IBAction func detailOnRetweet(_ sender: Any) {
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
        detailTweetText.text = tweet.text
        detailName.text = tweet.user?.name
        let user = tweet.user?.screenName!
        detailUsername.text = "@\(user ?? "Anon")"
        detailDate.text = tweet.createdAtStringLong
        detailRetweetCount.text = String(tweet.retweetCount!)
        detailFavoriteCount.text = String(tweet.favoriteCount!)
        if(tweet.favorited)!
        {
            detailFavoriteButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        }
        else
        {
            detailFavoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
        
        if(tweet.retweeted)!
        {
            detailRetweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
        }
        else
        {
            detailRetweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
        }
        
        
        
        detailImageView.af_setImage(withURL: tweet.user!.profileImage!)
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
