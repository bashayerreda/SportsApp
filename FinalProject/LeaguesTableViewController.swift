//
//  LeaguesTableViewController.swift
//  FinalProject
//
//  Created by MacOSSierra on 2/26/21.
//  Copyright © 2021 MacOSSierra. All rights reserved.
//  bashayer r mansour


import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class LeaguesTableViewController: UITableViewController {
    var sport = Sport()
    var arr_all_legues = [leagues]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mydata = "https://www.thesportsdb.com/api/v1/json/1/search_all_leagues.php?s=" + sport.name
        AF.request(mydata, method: .get).responseJSON { (myresponse) in
            switch myresponse.result {
            case .success:
                let result = try? JSON(data: myresponse.data!)
                
                let resultArray = result!["countrys"]
                self.arr_all_legues.removeAll()
                
                for i in resultArray.arrayValue{
                    let lg_name = i["strLeague"].stringValue
                    let lg_image = i["strBadge"].stringValue
                    let lg_youtube = i["strYoutube"].stringValue
                    let lg_id = i["idLeague"].intValue
                    
                    let Leagues = leagues()
                    Leagues.leaugename = lg_name
                    Leagues.leagueImage = lg_image
                    Leagues.leagueUrlButton = lg_youtube
                    Leagues.leagueId = lg_id
                    
                    self.arr_all_legues.append(Leagues)
                }
                self.tableView.reloadData()
                break
                
            case .failure:
                break
            }
            
            
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arr_all_legues.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "legCell", for: indexPath)
        let  title:UILabel = cell.viewWithTag(2) as! UILabel
        let  img:UIImageView = cell.viewWithTag(1) as! UIImageView
        title.text = arr_all_legues[indexPath.row].leaugename
        img.sd_setImage(with: URL(string: arr_all_legues[indexPath.row].leagueImage), placeholderImage: UIImage(named: "sports.jpg"))
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath){
        
        if let url = NSURL(string: "http://" + arr_all_legues[indexPath.row].leagueUrlButton){
            UIApplication.shared.openURL(url as URL)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextScreen = self.storyboard?.instantiateViewController(withIdentifier: "Events") as! eventsContainerView
        nextScreen.legauesevents = arr_all_legues[indexPath.row]
        self.present(nextScreen  as! UIViewController, animated: true, completion: nil)
        print("pressed")
    }
}









