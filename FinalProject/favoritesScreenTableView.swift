//
//  favoritesScreenTableView.swift
//  FinalProject
//
//  Created by MacOSSierra on 2/23/21.
//  Copyright © 2021 MacOSSierra. All rights reserved.
// bashayer r mansour

import UIKit
import CoreData
import SDWebImage
class favoritesScreenTableView: UITableViewController {
    var sportsArray = [NSManagedObject]()
    var arr_all_legues = [leagues]()
    var legauesevents = leagues()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Favourite"
        //1 app delgate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //2 manage object context
        let manageContext = appDelegate.persistentContainer.viewContext
        //3 create fetch request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteSports")
        fetchRequest.returnsDistinctResults = true
        do{
            sportsArray = try manageContext.fetch(fetchRequest)
            print("data show")
            
            
        }catch let error{
            
            
            print(error)
            
        }
        self.tableView.reloadData();
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sportsArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favcell", for: indexPath)
        let  title:UILabel = cell.viewWithTag(2) as! UILabel
        let  image:UIImageView = cell.viewWithTag(1) as! UIImageView
        title.text = (sportsArray[indexPath.row].value(forKey: "title") as! String)
        image.sd_setImage(with: URL(string: sportsArray[indexPath.row].value(forKey: "image") as! String), placeholderImage: UIImage(named: "sports2.jpg"))
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //1 app delgate
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //2 manage object context
            let manageContext = appDelegate.persistentContainer.viewContext
            //3 delete from manage context
            manageContext.delete(sportsArray[indexPath.row])
            do{
                try manageContext.save()
                
                
            }catch let error{
                
                print(error)
            }
            
            sportsArray.remove(at: indexPath.row)
            
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Connectivity.isConnectedToInternet {
            
            let nextScreen = self.storyboard?.instantiateViewController(withIdentifier: "Events") as! eventsContainerView
            var id = sportsArray[indexPath.row].value(forKey: "id") as! String
            
            nextScreen.legauesevents.leagueId = Int(id)!
            
            self.present(nextScreen  as UIViewController, animated: true, completion: nil)
            print("pressed")
        }
        else  {
            let alert = UIAlertController(title: "Alert", message: "Connection failed", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
