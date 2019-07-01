//
//  MainTableViewController.swift
//  tableview
//
//  Created by 彭睿诚 on 2019/5/31.
//  Copyright © 2019年 Ruicheng Peng. All rights reserved.
//

import UIKit
import Firebase


class MainTableViewController: UITableViewController {
    
    //Mark: Properties
    var finishedBets = [Bet]()

    //create different section
     var unfinishedBets = [Bet]()
    
    var valid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        loadcache()
        
        addNewBetFromDatabase()
        addNewUnfinishedBetFromDatabase()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let label = UILabel()
            label.text = "Finished Bet"
            label.backgroundColor = UIColor.yellow
            return label
        case 1:
            let label = UILabel()
            label.text = "WE WILL SEE!"
            label.backgroundColor = UIColor.red
            return label
            
        default:
            let label = UILabel()
            return label
        }
    }
    


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
        return finishedBets.count
        }
        else {
            return unfinishedBets.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Bet", for: indexPath) as? BetTableViewCell else{
            fatalError("Can't load cell")
        }
    if (indexPath.section == 0){
        cell.settingcell(newbet: finishedBets[indexPath.row])
    }
    else {
        cell.settingcell(newbet: unfinishedBets[indexPath.row])
        }
        
        // Configure the cell...
//     cell.username1.text = bets[indexPath.row].username1
//     cell.username2.text = bets[indexPath.row].username2
//     cell.slaps.text = String(bets[indexPath.row].slaps)
//    cell.profilephoto.image = bets[indexPath.row].photo
//        cell.incident.text = bets[indexPath.row].incident
        
        return cell
    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

/*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
      
    }
    


    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
    //  }

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if let destination = segue.destination as? BetDetailsController,
     let indexPath = tableView.indexPathForSelectedRow{
        if indexPath.section == 0{
     destination.bet = finishedBets[indexPath.row]
     }
        else{
            destination.bet = unfinishedBets[indexPath.row]
        }
     }
    }
     
     
    
    
    @IBAction func AddNewBet(_ sender: Any) {
          performSegue(withIdentifier: "addBet", sender: self)
    }
    
    
    //Mark: Privated Methods
 
    private func loadSampleBets() {
        let photo1 = UIImage(named: "sample1")
        let photo2 = UIImage(named: "defaultphoto")
        
        guard let bet1 = Bet(username1: "FYQ", username2: "PRC", slaps: 20, winner: true, incident: "wo shi ni ba ba", photo: photo1) else {
            fatalError("Unable to instantiate bet")
        }
        
        guard let bet2 = Bet(username1: "FYQ", username2: "PRC", slaps: 12, winner: true, incident: "qian zhai huan qian", photo: photo2) else {
            fatalError("Unable to instantiate bet")
        }
        
        finishedBets.append(bet1)
        finishedBets.append(bet2)
    }
    
    
    
    //************************ loading cache, sending out alert*************************
    
    private func loadcache(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let cacheRef = Database.database().reference().child("cache/\(uid)")
        cacheRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
           self.valid = snapshot.exists()
            
            let BET = snapshot.childSnapshot(forPath: "BET")
             let dict1 = BET.value as? NSDictionary
            let incident = dict1?["incident"] as? String ?? "nil"
            let timestamp = dict1?["timestamp"] as? Double ?? 0
            let username1 = dict1?["username1"] as? String ?? "nil"
            let username2 = dict1?["username2"] as? String ?? "nil"
            
            let Postby = snapshot.childSnapshot(forPath: "postby")
            let dict2 = Postby.value as? NSDictionary
            let currentUid = dict2?["currentUid"] as? String ?? "nil"
            let photoURL = dict2?["photoURL"] as? String ?? "nil"
            let username = dict2?["username"] as? String ?? "nil"
            
            print("\(incident) 1 \(timestamp)2 \(username1)3 \(username2) \(currentUid) 4 \(photoURL) 5 \(username)")
            
            if self.valid{
                print("lets do alert")
            
                let alert = UIAlertController(title: "New Bet", message: "\(username1) wanna bet you \(username2) for \(incident)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "NO WAY", style: .default, handler: {
                    action in
                    print("delete")
                    cacheRef.removeValue()
                }))
                
                alert.addAction(UIAlertAction(title: "YEAH", style: .default, handler: {
                    action in
                    self.addtoUsers(incident: incident, timestamp: timestamp, username1: username1, username2: username2, currentUid: currentUid, photoURL: photoURL, username: username)
                    cacheRef.removeValue()
                }))
                self.present(alert, animated: true)
                
                
            }
                
            else{
                print("there is no new bet")
                return
            }

            
        }){
            (error) in
            print("Error!!!!!!!!!!!!!!!")
            return
        }
        
        
    }
    
    
    
    //**************read data from firebase**********************
    
    private func addNewBetFromDatabase(){
         var photo1 = UIImage(named: "user-logo")
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postRef = Database.database().reference().child("users/\(uid)/testingpost")
        
        postRef.observe(.value, with: { snapshot in
            
            var tempBets = [Bet]()
         
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let BET = dict["BET"] as? [String:Any],
                    let postby = dict["postby"]as? [String:Any],
                   
                    let username1 = BET["username1"] as? String,
                    let username2 = BET["username2"] as? String,
                    let uid = postby["currentUid"] as? String,
                    let photoURL = postby["photoURL"] as? String,
                    let url = URL(string:photoURL),
                    let incident = BET["incident"] as? String,
                    let timestamp = BET["timestamp"] as? Double {
                    
                  let userProfile = UserProfile(uid: uid, username: username1, photoURL: url)
                    
                    ImageService.downloadImage(withURL: userProfile.photoURL){
                        image in photo1 = image
                    }

                   let post = Bet(username1: username1, username2: username2, slaps: 10, winner: true, incident: incident, photo: photo1)
                    
                    tempBets.append(post!)
                }
        }
            
            self.finishedBets = tempBets
            self.loadSampleBets()
            
            self.tableView.reloadData()
        })
    }
    
    private func addNewUnfinishedBetFromDatabase(){
        var photo1 = UIImage(named: "user-logo")
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postRef = Database.database().reference().child("users/\(uid)/testingpost222")
        
        postRef.observe(.value, with: { snapshot in
            
            var tempBets = [Bet]()
            
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let BET = dict["BET"] as? [String:Any],
                    let postby = dict["postby"]as? [String:Any],
                    
                    let username1 = BET["username1"] as? String,
                    let username2 = BET["username2"] as? String,
                    let uid = postby["currentUid"] as? String,
                    let photoURL = postby["photoURL"] as? String,
                    let url = URL(string:photoURL),
                    let incident = BET["incident"] as? String,
                    let timestamp = BET["timestamp"] as? Double {
                    
                    let userProfile = UserProfile(uid: uid, username: username1, photoURL: url)
                    
                    ImageService.downloadImage(withURL: userProfile.photoURL){
                        image in photo1 = image
                    }
                    
                    let post = Bet(username1: username1, username2: username2, slaps: 10, winner: true, incident: incident, photo: photo1)
                    
                    tempBets.append(post!)
                }
            }
            
            self.unfinishedBets = tempBets
            
            self.tableView.reloadData()
        })
    }
    
    
    
    private func addtoUsers(incident: String, timestamp: Double, username1: String, username2: String, currentUid: String, photoURL: String, username: String){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postRef = Database.database().reference().child("users/\(uid)/testingpost222").childByAutoId()
        let  postRef2 = Database.database().reference().child("users/\(currentUid)/testingpost222").childByAutoId()
        
        let postObject = [
            "postby": [
                "currentUid" : currentUid,
                "photoURL" : photoURL,
                "username" : username],
            
            "BET":[
                "username1": username1,
                "username2": username2,
                "incident": incident,
                "timestamp": timestamp
            ]
            ] as [String:Any]
        
        postRef.setValue(postObject, withCompletionBlock: { error, ref in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Handle the error
            }
        })
        
        postRef2.setValue(postObject, withCompletionBlock: { error, ref in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Handle the error
            }
        })
        
        print("sucessful adding")
    }
        
   
    
}
