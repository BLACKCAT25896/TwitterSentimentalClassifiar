

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    let sentimentClassifiar = tweetSentimentClassifier()
    let tweetcount = 100
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    let swifter = Swifter(consumerKey: "JLHDKSdXkcqZzX2NF8ZSh4aT6", consumerSecret: "zZbr7KLA9FqKGET67EVxChmwVslyfBgORHsXoUFf6IDyr4qe3B")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func predictPressed(_ sender: Any) {
        
        FetchTweets()
    }
    func FetchTweets(){
        if let searchText = textField.text{
            swifter.searchTweet(using: searchText, lang: "en", count: tweetcount, tweetMode: .extended, success: { (results, metadata) in
                // print(results)
                var tweets = [tweetSentimentClassifierInput]()
                for i in 0..<self.tweetcount {
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = tweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                self.makePrediction(with: tweets)
                
            }) { (error) in
                print("Failure Twitter Api Request\(error)")
            }
        }
    }
    func makePrediction(with tweets: [tweetSentimentClassifierInput]){
        do{
            let predictions = try self.sentimentClassifiar.predictions(inputs: tweets)
            var sentimentScore = 0
            for pred in predictions{
                let sentiment = pred.label
                if sentiment == "Pos"{
                    sentimentScore += 1}
                else if sentiment == "Neg"{
                    sentimentScore -= 1 }
            }
            UpdateUI(with: sentimentScore)
        }catch{
            print("there was an Error to making prediction\(error)")
        }
    }
    func UpdateUI(with sentimentScore: Int){
        if sentimentScore > 20{
            self.sentimentLabel.text = "😍"
        }
        else if sentimentScore > 10{
            self.sentimentLabel.text = "😃"
        }
        else if sentimentScore > 0{
            self.sentimentLabel.text = "🙂"
        }
        else if sentimentScore == 0{
            self.sentimentLabel.text = "🤨"
        }
        else if sentimentScore < 0{
            self.sentimentLabel.text = "😕"
        }
        else if sentimentScore < 10{
            self.sentimentLabel.text = "😕"
        }
        else if sentimentScore < 20{
            self.sentimentLabel.text = "☹️"
        }
        else {
            self.sentimentLabel.text = "😍"
        }
        
    }
}

