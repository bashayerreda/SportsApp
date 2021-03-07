//
//  eventsContainerView.swift
//  FinalProject
//
//  Created by MacOSSierra on 2/27/21.
//  Copyright © 2021 MacOSSierra. All rights reserved.
// bashayer r mansour

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import CoreData

class eventsContainerView: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate{
    var legauesevents = leagues()
    var arr_all_events_leg = [EventsData]()
    var arr_teams = [Teams]()
    var numid : String = ""
    
    @IBOutlet weak var third_cell: UICollectionView!
    @IBOutlet weak var second_cell: UICollectionView!
    @IBOutlet weak var fIrst_CELL: UICollectionView!
    
    @IBOutlet weak var nn: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataevents = "https://www.thesportsdb.com/api/v1/json/1/eventsseason.php?id=" + String(legauesevents.leagueId)
        AF.request(dataevents, method: .get).responseJSON { (myresponse) in
            switch myresponse.result {
            case .success:
                print(myresponse.result)
                let result = try? JSON(data: myresponse.data!)
                print(result)
                let resultArray = result!["events"]
                self.arr_all_events_leg.removeAll()
                for i in resultArray.arrayValue{
                    let lg_eventname = i["strEvent"].stringValue
                    let lg_eventdate = i["dateEvent"].stringValue
                    let lg_eventtime = i["strTime"].stringValue
                    let lg_hometeam = i["strHomeTeam"].stringValue
                    let lg_awayteam = i["strAwayTeam"].stringValue
                    let lg_hometeam_score = i["intHomeScore"].intValue
                    let lg_awayteam_score = i["intAwayScore"].intValue
                    var event = EventsData()
                    event.eventname = lg_eventname
                    event.eventdate = lg_eventdate
                    event.eventtime = lg_eventtime
                    event.hometeam = lg_hometeam
                    event.awayteam = lg_awayteam
                    event.homeScore = lg_hometeam_score
                    event.awayScore = lg_awayteam_score
                    self.arr_all_events_leg.append(event)
                }
                self.fIrst_CELL.reloadData()
                self.second_cell.reloadData()
                break;
            case .failure:
                break
            }
        }
        
        
        
        let teamdata = "https://www.thesportsdb.com/api/v1/json/1/lookup_all_teams.php?id=" + String(legauesevents.leagueId)
        AF.request(teamdata, method: .get).responseJSON { (myresponse) in
            switch myresponse.result {
            case .success:
                print(myresponse.result)
                let result = try? JSON(data: myresponse.data!)
                print(result)
                let resultArray = result!["teams"]
                self.arr_teams.removeAll()
                for i in resultArray.arrayValue{
                    let teamsdetails = Teams()
                    let tm_id = i["idTeam"].intValue
                    let tm_logo = i["strTeamLogo"].stringValue
                    
                    teamsdetails.teamid = tm_id
                    teamsdetails.teamimmg = tm_logo
                    
                    self.arr_teams.append(teamsdetails)
                    //self.third_cell.reloadData()
                    
                }
                self.third_cell.reloadData()
                break;
            case .failure:
                break
            }
        }
        
    }
    
    var sportsArray = [NSManagedObject]()
    @IBAction func btn_save(_ sender: Any) {
        
        //1 app delgate
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //2 manage object context
        
        let manageContext = appDelegate.persistentContainer.viewContext
        
        //3 create entity object
        
        let entity = NSEntityDescription.entity(forEntityName: "FavouriteSports", in: manageContext)
        
        
        
        // 4 create manage object for movie entity
        
        let sport = NSManagedObject(entity: entity!, insertInto: manageContext)
        
        //5 set values for the manage object
        var leaguesid = String(legauesevents.leagueId)
        sport.setValue(leaguesid, forKey: "id")
        sport.setValue(legauesevents.leaugename, forKey: "title")
        sport.setValue(legauesevents.leagueImage, forKey: "image")
        
        
        //6 Save
        do{
            
            try manageContext.save()
            sportsArray.append(sport)
            
            print("data added")
            
        }catch let error{
            
            print(error)
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == fIrst_CELL){
            return arr_all_events_leg.count
        }
        if(collectionView == second_cell){
            return arr_all_events_leg.count
            
        }
        
        return arr_all_events_leg.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == fIrst_CELL){
            let cell = fIrst_CELL.dequeueReusableCell(withReuseIdentifier: "fCell", for: indexPath) as! UICollectionViewCell
            
            let  evname:UILabel = cell.viewWithTag(1) as! UILabel
            let  evtime:UILabel = cell.viewWithTag(2) as! UILabel
            let  evdate:UILabel = cell.viewWithTag(3) as! UILabel
            
            evname.text = arr_all_events_leg[indexPath.row].eventname
            evtime.text = arr_all_events_leg[indexPath.row].eventtime
            evdate.text = arr_all_events_leg[indexPath.row].eventdate
            return cell
            
        }
        
        if(collectionView == second_cell){
            let cell2 = second_cell.dequeueReusableCell(withReuseIdentifier: "secCell", for: indexPath) as! UICollectionViewCell
            let hometeamname:UILabel = cell2.viewWithTag(1) as! UILabel
            let hometeamnscore:UILabel = cell2.viewWithTag(2) as! UILabel
            let eventtime:UILabel = cell2.viewWithTag(3) as! UILabel
            let  secondteamname : UILabel = cell2.viewWithTag(4) as! UILabel
            let secondteamscore: UILabel = cell2.viewWithTag(5) as! UILabel
            let eventdate : UILabel = cell2.viewWithTag(6) as! UILabel
            hometeamname.text = arr_all_events_leg[indexPath.row].hometeam
            hometeamnscore.text = String (arr_all_events_leg[indexPath.row].homeScore)
            eventtime.text = arr_all_events_leg[indexPath.row].eventtime
            secondteamname.text = arr_all_events_leg[indexPath.row].awayteam
            secondteamscore.text = String(arr_all_events_leg[indexPath.row].awayScore)
            eventdate.text = arr_all_events_leg[indexPath.row].eventdate
            return cell2
        }
        if(collectionView == third_cell){
            
            let cell3 = third_cell.dequeueReusableCell(withReuseIdentifier: "thCell", for: indexPath) as! UICollectionViewCell
            
            let  img:UIImageView = cell3.viewWithTag(8) as! UIImageView
            img.sd_setImage(with: URL(string: arr_teams[indexPath.row].teamimmg), placeholderImage: UIImage(named: "sport-black.jpg"))
            img.layer.cornerRadius = img.frame.size.width / 2
            
            img.clipsToBounds = true
            print(arr_teams[indexPath.row].teamimmg)
            return cell3
            
        }
        
        let cellfinal = collectionView.dequeueReusableCell(withReuseIdentifier: "Events", for: indexPath) as! UICollectionViewCell
        return cellfinal
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let Fnext = self.storyboard?.instantiateViewController(withIdentifier: "ab") as! TeamDetailsView
        Fnext.teamDetails = arr_teams[indexPath.row]
        self.present(Fnext, animated: true, completion: nil)
    
        print("pressed")
        
        
    }
    
}


