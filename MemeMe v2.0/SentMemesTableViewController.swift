//
//  SentMemesTableViewController.swift
//  MemeMe v2.0
//
//  Created by Ramon Gomez on 6/7/17.
//  Copyright © 2017 Ramon's. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeTableViewCell"

class SentMemesTableViewController: UITableViewController {

    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let meme = memes[(indexPath as NSIndexPath).row]

        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText! + "..." + meme.bottomText!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.memes.remove(at: indexPath.row)
            memes = appDelegate.memes
            self.tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
        
    }
}
