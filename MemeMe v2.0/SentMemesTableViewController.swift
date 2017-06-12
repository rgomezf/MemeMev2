//
//  SentMemesTableViewController.swift
//  MemeMe v2.0
//
//  Created by Ramon Gomez on 6/7/17.
//  Copyright © 2017 Ramon's. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return self.memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell", for: indexPath) as! MemeTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]

        cell.imageView?.image = meme.memedImage
        cell.topBottomLabels.text = meme.topText! + "..." + meme.bottomText!
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.tableView.reloadData()
    }
}
