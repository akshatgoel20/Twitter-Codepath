//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Joakim Jorde on 10/13/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet] = []
    var user: User! = User.current!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileBanner: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    
    @IBOutlet weak var profileTweetCount: UILabel!
    @IBOutlet weak var profileFollowingCount: UILabel!
    @IBOutlet weak var profileFollowersCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        fetchUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {

        fetchUser()
        user = User.current!
    }
    func fetchUser(){
        
        profileName.text = self.user.name!
        let user = self.user.screenName!
        profileUsername.text = "@\(user)"


        profileImage.af_setImage(withURL: (self.user.profileImage!))

      //  profileBanner.af_setImage(withURL: (self.user.profileBanner!))
        profileTweetCount.text = self.user.tweetsCount!
        profileFollowingCount.text = self.user.followingCount!
        profileFollowersCount.text = self.user.followersCount!
        
        if self.user.screenName == User.current?.screenName{
        APIManager.shared.timeLineUserName = ""
        }
        else
        {
            APIManager.shared.timeLineUserName = self.user.screenName!
        }
        fetchData()
    }
    func fetchData() {
        APIManager.shared.getUserTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? DetailViewController {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell){
                let tweet = tweets[indexPath.row]
                detailViewController.tweet = tweet
            }
        }
    }
}
