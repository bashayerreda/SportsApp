//
//  SportsFirstScreen.swift
//  FinalProject
//
//  Created by MacOSSierra on 2/23/21.
//  Copyright © 2021 MacOSSierra. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

private let reuseIdentifier = "Cell"

class SportsFirstScreen: UICollectionViewController {
    var arr_sports = [Sport]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mydata = "https://www.thesportsdb.com/api/v1/json/1/all_sports.php"
        AF.request(mydata, method: .get).responseJSON { (myresponse) in
            switch myresponse.result {
            case .success:
                print(myresponse.result)
                let result = try? JSON(data: myresponse.data!)
                print(result)
                //print(result!["sports"])
                let resultArray = result!["sports"]
                
                self.arr_sports.removeAll()
                
                
                for i in resultArray.arrayValue{
                    let sp_name = i["strSport"].stringValue
                    let sp_image = i["strSportThumb"].stringValue
                  
                    var sport = Sport()
                    sport.name = sp_name
                    sport.image = sp_image
                    self.arr_sports.append(sport)
                    self.collectionView.reloadData()
                }
                break;
            case .failure:
                break
            }
        }
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return arr_sports.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arr_sports.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let  title:UILabel = cell.viewWithTag(2) as! UILabel
        let  img:UIImageView = cell.viewWithTag(1) as! UIImageView
        
        title.text = arr_sports[indexPath.row].name
        img.sd_setImage(with: URL(string: arr_sports[indexPath.row].image), placeholderImage: UIImage(named: "sport.jpg"))
        
        
        
        
        
        
        return cell;
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(arr_sports[indexPath.row].name)
        print(arr_sports[indexPath.row].image)
        let next = self.storyboard?.instantiateViewController(withIdentifier: "legVC") as! LeaguesTableViewController
        next.sport = arr_sports[indexPath.row]
        self.present(next, animated: true, completion: nil)
        print("pressed")
        
        
    }
    
}
