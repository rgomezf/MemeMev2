//
//  SentMemesCollectionViewController.swift
//  MemeMe v2.0
//
//  Created by Ramon Gomez on 6/7/17.
//  Copyright © 2017 Ramon's. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var memeCollectionView: UICollectionView!
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView!.register(MemeCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        memeCollectionView?.dataSource = self
        memeCollectionView?.delegate = self
        
        // Additional setup
        flowLayoutSet(self.view.frame.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        flowLayoutSet(size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //self.memeCollectionView.reloadData()
        collectionView?.reloadData()
    }
    
    func flowLayoutSet (_ size: CGSize) {
        
        if let flowLayout = self.flowLayout {
            let space: CGFloat = 1.5
            let dimension = size.width >= size.height ? (size.width - (5 * space)) / 6.0 : (size.width - (2 * space)) / 3.0
            
            flowLayout.minimumInteritemSpacing = space
            flowLayout.minimumLineSpacing = space
            flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        }

    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // return the number of item
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        
        cell.memeImage.image = meme.memedImage
        cell.memeImage.contentMode = .scaleAspectFill
        
        return cell
    }

}
