//
//  ViewController.swift
//  CatchMcQueen
//
//  Created by Ibrahim Cicek on 22.01.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var mcqueenImage: UIImageView!
    @IBOutlet weak var topScoreLabel: UILabel!
    
    
    var counter = 0
    var score = 0
    var highScore = 0
    var startingPosition = 0
    var timer = Timer()
    var timer2 = Timer()
   
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startingPosition = Int(CGFloat(mcqueenImage.frame.origin.y))
        counter = 20
        let topScore = UserDefaults.standard.integer(forKey: "topScore")
        topScoreLabel.text = "Top Score: \(topScore)"
        scoreLabel.text = "Score: \(score)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(mcqueenTimer), userInfo: nil, repeats: true)
        mcqueenImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scoreUp))
        mcqueenImage.addGestureRecognizer(gestureRecognizer)
        
    }
    @objc func scoreUp(){
        score = score+1
        scoreLabel.text = "Score: \(score)"
    }
    
    @objc func mcqueenTimer(){
                let mcqueen = mcqueenImage
                let mcqueenWidth = mcqueen!.frame.width
                let mcqueenHeight = mcqueen!.frame.height

                 // Find the width and height of the enclosing view
                let viewWidth = CGFloat(400)
                let viewHeight = CGFloat(400)

                 // Compute width and height of the area to contain the mcqueen's center
                let xwidth = viewWidth - mcqueenWidth
                let yheight = viewHeight - mcqueenHeight

                // Generate a random x and y offset
                let xoffset = CGFloat(arc4random_uniform(UInt32(xwidth)))
                let yoffset = CGFloat(arc4random_uniform(UInt32(yheight)))

                // Offset the button's center by the random offsets.
                mcqueen!.center.x = xoffset + mcqueenWidth / 2
                mcqueen!.center.y = yoffset + CGFloat(startingPosition) + mcqueenHeight / 2
    }
    
    @objc func startTimer(){
        timeLabel.text = "Time: \(counter)"
        counter -= 1
        
        
        if counter <= 0{
            timer.invalidate()
            timer2.invalidate()
            self.timeLabel.text = "Time's Up!"
            
            let alert = UIAlertController(title: "Ka-Chow Time's Up", message: "Would you like to play again?", preferredStyle: UIAlertController.Style.alert)
            let retryButton = UIAlertAction(title: "Retry", style: UIAlertAction.Style.default){
                (UIAlerAction) in
                self.score = 0
                self.scoreLabel.text = "Score: \(self.score)"
                self.counter = 20
                self.timeLabel.text = "Time \(self.counter)"
                
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
                self.timer2 = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.mcqueenTimer), userInfo: nil, repeats: true)
                
            }
            let closeButton = UIAlertAction(title: "Close", style: UIAlertAction.Style.default){
                (UIAlerAction) in
                self.mcqueenImage.removeFromSuperview()
                
            }
            let topScore = UserDefaults.standard.integer(forKey: "topScore")
            
            if(topScore==0){
                UserDefaults.standard.set(String(score),forKey: "topScore")
                topScoreLabel.text = "Top Score: \(score)"
            }
            
            else if(topScore<=score){
                UserDefaults.standard.set(String(score),forKey: "topScore")
                topScoreLabel.text = "Top Score: \(score)"
            }
            alert.addAction(retryButton)
            alert.addAction(closeButton)
            self.present(alert, animated: true)
        }
        
    }

}

