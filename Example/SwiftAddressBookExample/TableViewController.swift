//
//  TableViewController.swift
//  Test
//
//  Created by Socialbit - Tassilo Karge on 14.02.15.
//  Copyright (c) 2015 socialbit. All rights reserved.
//

import UIKit
import SwiftAddressBook

class TableViewController: UITableViewController {

    var people : [SwiftAddressBookPerson]? = []
    var names : [String?]? = []
    var numbers : [Array<String?>?]? = []
    var birthdates : [NSDate?]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swiftAddressBook?.requestAccessWithCompletion { (b :Bool, _ :CFError?) -> Void in
            if b {
                
                //to test adding a new person uncomment the following 
                /*
                var person = SwiftAddressBookPerson.create()
                person.firstName = "newTestuserFirstname"
                person.lastName = "newTestuserLastname"
                person.organization = "newTestuserCompanyname"
                
                var phone = MultivalueEntry(value: "newTestuserNumber", label: "mobile", id: 1)
                person.phoneNumbers = [phone]
                
                swiftAddressBook?.addRecord(person)
                swiftAddressBook?.save()

                */

                self.people = swiftAddressBook?.allPeople
                
                //to test adding a new group uncomment the following
                /*
                
                var group = SwiftAddressBookGroup.create()
                
                group.name = "Testgroup"
                
                //add every second person
                for var i = 0; i < self.people?.count; i += 2 {
                    group.addMember(self.people![i])
                }
                swiftAddressBook?.addRecord(group)
                swiftAddressBook?.save()
                
                */
                
                self.numbers = self.people?.map { (p) -> (Array<String?>?) in
                    return p.phoneNumbers?.map { return $0.value }
                }
                self.names = self.people?.map { (p) -> (String?) in
                    return p.compositeName
                }
                self.birthdates = self.people?.map { (p) -> (NSDate?) in
                    return p.birthday
                }
                
                self.tableView.reloadData()
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return people == nil ? 0 : people!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("addressCell", forIndexPath: indexPath) as AddressViewCell

        // Configure the cell...
        cell.nameLabel.text = people![indexPath.row].compositeName
        cell.birthdateLabel.text = birthdates![indexPath.row]?.description
        cell.phoneNumberLabel.text = numbers![indexPath.row]?.first?

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
