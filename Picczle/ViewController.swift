//
//  ViewController.swift
//  Picczle
//
//  Created by Nick Arnold on 11/25/15.
//  Copyright © 2015 Swiss. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    let baseURL: String = "http://127.0.0.1:8000"
    var pageData: [Puzzle]!
    var imagePicker = UIImagePickerController()
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var puzzleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Alamofire.request(.GET, baseURL + "/puzzles").responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            self.getPuzzles { puzzles, error in
                self.pageData = puzzles
                let puzzle = self.pageData[0]
                self.downloadAnImage(puzzle.imageURL, completion: { data, error in
                    self.puzzleImageView.image = UIImage(data: data)
                    self.view.setNeedsDisplay()
                })
                self.titleLabel.text = self.pageData[0].title
            }
        }
    }
    
    
    func downloadAnImage(url: String, completion: (data: NSData, error: NSError?) -> Void) -> Void {
        print(url)
        Alamofire.request(.GET, baseURL + url).response() { (_, _, data, error) in
            completion(data: data!, error: error)
        }
    }
    
    
    func getPuzzles(onCompletion: (puzzles: [Puzzle], error: NSError?) -> Void) {
        let requestURL = baseURL + "/picczle/puzzles"
        var puzzles : [Puzzle] = []
        Alamofire.request(.GET, requestURL)
            .responseJSON { response in
                if response.result.isSuccess {
                    if let data = response.result.value {
                        let json = JSON(data)
                        puzzles = Puzzle.puzzlesFromJSON(json)
                        onCompletion(puzzles: puzzles, error: nil)
                    }
                } else {
                    onCompletion(puzzles: puzzles, error: response.result.error)
                }
        }
    }

    
    @IBAction func photoButtonPressed(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        puzzleImageView.image = image
    }
}
