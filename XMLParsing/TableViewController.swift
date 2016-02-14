//
//  TableViewController.swift
//  XMLParsing
//
//  Created by Pravin Kandala on 2/2/16.
//  Copyright © 2016 Pravin Kandala. All rights reserved.
//

import UIKit


//initializing url
let url = NSURL(string: "https://itunes.apple.com/us/rss/topmovies/limit=10/xml")

var imageProvider = ImageProvider()

class TableViewController: UITableViewController, XMLParserDelegate {
    
    var parser = XMLParser(url: url!)
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //display title
         title = "Top 10 Movies"
        
        parser.delegate = self
        parser.parse{
            
            //refresh the tableview for data
            self.tableView.reloadData()
        }
    }

    
    //display if any parser error
    
    func XMLParserError(parser: XMLParser, error: String) {
        print(error)
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return parser.objects.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> CustomTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomTableViewCell

        
        
        //display title of movie
        cell.label1.text = parser.objects[indexPath.row]["title"]
        cell.label1?.numberOfLines = 2
        cell.label1?.lineBreakMode = .ByWordWrapping
        cell.label1?.textColor = UIColor.darkTextColor()
        cell.label1?.font = UIFont.boldSystemFontOfSize(18)
        
        //display artist name
        cell.label2!.text = "Artist: "+parser.objects[indexPath.row]["im:artist"]!
        
        //display price of the movie
        cell.label3!.text = "Price: "+parser.objects[indexPath.row]["im:price"]!
        
        //display discription of the movie
        
        cell.discriptionLabel!.text = parser.objects[indexPath.row]["summary"]!
        cell.discriptionLabel?.numberOfLines = 5
        cell.discriptionLabel?.lineBreakMode = .ByWordWrapping
        cell.discriptionLabel?.font = UIFont.boldSystemFontOfSize(11)
        
        
        
        
        // downloading images for cell image view
        let imgName = parser.objects[indexPath.row]["im:image"]
        
        var myArray = imgName!.componentsSeparatedByString("\n")
        
        
            print(myArray[4].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
     
        //call 113x170 size images from xml
        
        imageProvider.imageWithName(myArray[4].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) {
            (image: UIImage) in
            
            // Code to do something with the downloaded image named image
            
            cell.image1.image = image
            
        }
        


        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
