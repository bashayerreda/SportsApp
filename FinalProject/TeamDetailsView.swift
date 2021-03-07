//
//  TeamDetailsView.swift
//  FinalProject
//
//  Created by MacOSSierra on 3/1/21.
//  Copyright © 2021 MacOSSierra. All rights reserved.
// bashayer r mansour

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage


class TeamDetailsView: UICollectionViewController {
    @IBAction func btn_back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var evdata = EventsData()
    var teamDetails =  Teams()
    var arr_team_details = [TeamDetails]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(teamDetails.teamid)
        let mydata = "https://www.thesportsdb.com/api/v1/json/1/lookupteam.php?id=" +  String (teamDetails.teamid)
        AF.request(mydata, method: .get).responseJSON { (myresponse) in
            switch myresponse.result {
            case .success:
                print(myresponse.result)
                let result = try? JSON(data: myresponse.data!)
                print(result)
                let resultArray = result!["teams"]
                self.arr_team_details.removeAll()
                for i in resultArray.arrayValue{
                    let tm_name = i["strTeam"].stringValue
                    let tm_alternative = i["strAlternate"].stringValue
                    let tm_logo = i["strTeamLogo"].stringValue
                    let tm_img = i["strTeamJersey"].stringValue
                    let tm_country = i["strCountry"].stringValue
                    let tm_gender = i["strGender"].stringValue
                    var finaldetailsteam = TeamDetails()
                    finaldetailsteam.alternative = tm_alternative
                    finaldetailsteam.badge = tm_img
                    finaldetailsteam.country = tm_country
                    finaldetailsteam.genderTeam = tm_gender
                    finaldetailsteam.teamname = tm_name
                    finaldetailsteam .logo = tm_logo
                    self.arr_team_details.append(finaldetailsteam)
                }
                self.collectionView.reloadData()
                break;
            case .failure:
                break
            }
        }
        
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr_team_details.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ab", for: indexPath)
        let  img:UIImageView = cell.viewWithTag(1) as! UIImageView
        let teamname:UILabel = cell.viewWithTag(2) as! UILabel
        let teamgender:UILabel = cell.viewWithTag(3) as! UILabel
        let teamcountry:UILabel = cell.viewWithTag(4) as! UILabel
        let  teamalternative : UILabel = cell.viewWithTag(5) as! UILabel
        let  imglogo:UIImageView = cell.viewWithTag(6) as! UIImageView
        
        img.sd_setImage(with: URL(string: arr_team_details[indexPath.row].badge), placeholderImage: UIImage(named: "sport-black.jpg"))
        imglogo.sd_setImage(with: URL(string: arr_team_details[indexPath.row].logo), placeholderImage: UIImage(named: "sports3.jpg"))
        
        teamname.text = arr_team_details[indexPath.row].teamname
        teamgender.text = arr_team_details[indexPath.row].genderTeam
        teamcountry.text = arr_team_details[indexPath.row].country
        teamalternative.text = arr_team_details[indexPath.row].alternative
        
        
        return cell
    }
    
    
    
    
}
