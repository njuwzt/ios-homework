//
//  GoodTableViewController.swift
//  shopping
//
//  Created by Astinna on 2020/11/12.
//  Copyright © 2020 NJU. All rights reserved.
//

import UIKit
import os.log
class GoodTableViewController: UITableViewController {
    
    var goods = [Good]()
    private func loadSampleGoods(){
        let photo1 = UIImage(named: "Good1")
        let photo2 = UIImage(named: "Good2")
        let photo3 = UIImage(named: "Good3")
        guard let good1=Good(name:"plane", photo:photo1, reason:"I like to fly") else{
            fatalError("Unable to instantiate good1")
        }
        guard let good2=Good(name:"chocolate", photo:photo2, reason:"Very delicious") else{
                   fatalError("Unable to instantiate good2")
               }
        guard let good3=Good(name:"lighting", photo:photo3, reason:"And God said,Let therer be light") else{
                   fatalError("Unable to instantiate good3")
               }
        goods += [good1, good2, good3]
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.leftBarButtonItem = editButtonItem
        loadSampleGoods()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return goods.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GoodTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GoodTableViewCell else{
            fatalError("The dequed cell is not an instance of GoodTableVierwCell")
        }
        // Configure the cell...
        let good = goods[indexPath.row]
        
        cell.nameLabel.text = good.name
        cell.photoImageView.image = good.photo
        cell.reasonLabel.text = good.reason
        
        return cell
    }
    
    @IBAction func unwindToGoodList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? ViewController, let good = sourceViewController.good{
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                goods[selectedIndexPath.row] = good
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                let newIndexPath = IndexPath(row: goods.count, section: 0)
                goods.append(good)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }


    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            goods.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
        case "AddItem":
            os_log("Adding a new meal", log: OSLog.default, type: .debug)
        case "ShowDetail":
                guard let goodDetailViewController = segue.destination as? ViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedGoodCell = sender as? GoodTableViewCell else {
                    fatalError("Unexpected sender: \(sender)")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedGoodCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedGood = goods[indexPath.row]
                goodDetailViewController.good = selectedGood
                
            default:
                fatalError("Unexpected Segue Identifier; \(segue.identifier)")
            
        }
    }
    

}
