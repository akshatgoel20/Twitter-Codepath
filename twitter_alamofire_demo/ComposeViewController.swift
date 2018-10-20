

import UIKit
import AlamofireImage

protocol ComposeViewControllerDelegate {
    func did(post: Tweet)
}


class ComposeViewController: UIViewController, UITextViewDelegate {
    
    var delegate: ComposeViewControllerDelegate?

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var letterCount: UILabel!
    @IBOutlet weak var tweetText: UITextView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetText.delegate = self
        
        profileName.text = User.current?.name!
        let user = User.current?.screenName!
        profileUsername.text = "@\(user ?? "Anon")"
        
        profileImage.af_setImage(withURL: (User.current?.profileImage!)!)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true){}
    }
    
    @IBAction func didTapPost(_ sender: Any) {
        
        APIManager.shared.composeTweet(with: tweetText.text) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
                self.tweetText.textColor = UIColor(red: 255, green: 000, blue: 000, alpha: 255)
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                print("Compose Tweet Success!")
                self.tweetText.text = ""
                self.dismiss(animated: true){}
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Set the max character limit
        let characterLimit = 140
        
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        
        // TODO: Update Character Count Label
        letterCount.text = String(characterLimit - newText.characters.count)
        
        // The new text should be allowed? True/False
        return newText.characters.count < characterLimit
        
        // Allow or disallow the new text
    }
    

}
