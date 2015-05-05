//
//  ViewController.swift
//  MyFirstSwiftApp
//
//  Created by Kohei Arai on 5/5/15.
//  Copyright (c) 2015 Kohei Arai. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    @IBOutlet weak var appsTableView: UITableView!
    var tableData = []
    var api = APIController()

    override func viewDidLoad() {
        super.viewDidLoad()
        api.delegate = self
        api.searchItunesFor("Angry Birds")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kCellIdentifier: String = "Cell"
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell
        
        if var  rowData:NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
                urlString = rowData["artworkUrl60"] as? String,
                imgURL = NSURL(string: urlString),
                formattedPrice = rowData["formattedPrice"] as? String,
                imgData = NSData(contentsOfURL: imgURL),
                trackName = rowData["trackName"] as? String
        {
            cell.detailTextLabel?.text = formattedPrice
            cell.imageView?.image = UIImage(data: imgData)
            cell.textLabel?.text = trackName
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if var  rowData = self.tableData[indexPath.row] as? NSDictionary,
                name = rowData["trackName"] as? String,
                formattedPrice = rowData["formattedPrice"] as? String
        {
                var alert = UIAlertController(
                    title: name,
                    message: formattedPrice,
                    preferredStyle: .Alert
                )
                alert.addAction(UIAlertAction(
                    title: "Ok",
                    style: .Default,
                    handler: nil)
                )
                self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = results
            self.appsTableView!.reloadData()
        })
    }
}

