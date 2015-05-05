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
    var albums = [Album]()
    var api: APIController!
    let kCellIdentifier: String = "Cell"
    var imageCashe = [String : UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api.searchItunesFor("Beatles")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell
        let album = self.albums[indexPath.row]
        
        cell.textLabel?.text = album.title
        cell.detailTextLabel?.text = album.price

        cell.imageView?.image = UIImage(named: "Blank52.png")

        var thumbnailURLString = album.thumanailImageURL
        var thumbnailURL = NSURL(string: thumbnailURLString)!
        
        if var img = imageCashe[thumbnailURLString] {
            cell.imageView?.image = img
        } else {
            // The image isn't cached, download the img data
            // We should perform this in a background thread
            var request:NSURLRequest = NSURLRequest(URL: thumbnailURL)
            var mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: {(response, data, error) -> Void in
                if error == nil {
                    var image = UIImage(data: data)
                    self.imageCashe[thumbnailURLString] = image
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
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if var  rowData = self.albums[indexPath.row] as? NSDictionary,
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
            self.albums = Album.albumWithJSON(results)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if var detailsVC: DetailsViewController = segue.destinationViewController as? DetailsViewController {
            var albumIndex = self.appsTableView.indexPathForSelectedRow()!.row
            var selectedAlbum = self.albums[albumIndex]
            detailsVC.album = selectedAlbum
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
}

