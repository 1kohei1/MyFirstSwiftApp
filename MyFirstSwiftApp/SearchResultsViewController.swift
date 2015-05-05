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
    var imageCashe = [String : UIImage]()

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
                trackName = rowData["trackName"] as? String
        {
            cell.detailTextLabel?.text = formattedPrice
            cell.textLabel?.text = trackName
            
            cell.imageView?.image = UIImage(named: "Blank52.png")
            // If this image is already cached, don't re-download
            if var img = imageCashe[urlString] {
                cell.imageView?.image = img;
            } else {
                // The image isn't cached, download the img data
                // We should perform this in a background thread
                var request:NSURLRequest = NSURLRequest(URL: imgURL)
                var mainQueue = NSOperationQueue.mainQueue()
                NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: {(response, data, error) -> Void in
                    if error == nil {
                        var image = UIImage(data: data)
                        self.imageCashe[urlString] = image
                        dispatch_async(dispatch_get_main_queue(), {
                            if var cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                                cellToUpdate.imageView?.image = image
                            }
                        })
                    } else {
                        println("Error: \(error.localizedDescription)")
                    }
                })
            }
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

