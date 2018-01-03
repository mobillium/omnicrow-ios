//
//  NotificationPopup.swift
//  Alamofire
//
//  Created by Eren Gündüz on 3.01.2018.
//

import Foundation
import UIKit
import Kingfisher

public class NotificationPopup: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var popUpImage: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet weak var CompletionButton: UIButton!
    
    
    var omnicrowPopup: OmnicrowPopup!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.omnicrowPopup.title
        self.descriptionLabel.text = self.omnicrowPopup.content
        self.CompletionButton.setTitle(self.omnicrowPopup.button, for: UIControlState())
        let url = URL(string: "http://is3.mzstatic.com/image/thumb/Purple128/v4/27/27/26/2727268c-f825-a2e9-76c7-0e9206080a87/source/1200x630bb.jpg")
        popUpImage.kf.setImage(with: url)
        
    }
    
    convenience init(_ omnicrowPopup: OmnicrowPopup){
        self.init(nibName: "NotificationPopup", bundle: Omnicrow.bundle())
        self.omnicrowPopup = omnicrowPopup
        
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    }
    
    
    @IBAction func rightButtonClick(_ sender: Any) {
        self.dismiss(animated: true) {
            UIApplication.shared.openURL(URL(string: self.omnicrowPopup.uri)!)
        }
        
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}

