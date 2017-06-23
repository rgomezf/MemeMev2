//
//  MemeDetailViewController.swift
//  MemeMe v2.0
//
//  Created by Ramon Gomez on 6/16/17.
//  Copyright © 2017 Ramon's. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var detailMemedImage: UIImageView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailMemedImage.image = self.meme.memedImage
        detailMemedImage.contentMode = .scaleAspectFit
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeTabBarStatus(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        changeTabBarStatus(false)
    }
    
    private func changeTabBarStatus (_ status: Bool) {
        self.tabBarController?.tabBar.isHidden = status
    }
}
