//
//  ViewController.swift
//  VoteNow
//
//  Created by Amish Tyagi on 10/19/20.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import SwiftKeychainWrapper
class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var statButton: UIButton!
    
    var race = ""
    
    var state = ""
    
    var selected = "Biden"
    
    let defaults = KeychainWrapper.standard
    
    let pickerValues = ["Joe Biden", "Donald Trump", "Jo Jorgensen", "Howie Hawkins"]
        	
    let lastName = ["Biden", "Trump", "Jorgensen", "Hawkins"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerValues[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = lastName[row]
        getData()
    }
    
    var votes = 0
    var raceVotes = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getData()
    }

    @IBAction func voteTapped(_ sender: Any) {
        print(defaults.bool(forKey: "Voted"))
        if defaults.bool(forKey: "Voted") == true {
            showMessage("You have already voted", "You have already voted. Unfortunately, you cannot change your vote, but you can move the picker to see the amount of votes. Thank you for using VoteNow!")
        }
        else {
            if defaults.bool(forKey: "Policies") != true {
                defaults.set(true, forKey: "Policies")
                let alertController = UIAlertController(title: "Policies", message: "Would you like to look over the policies?", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "No", style: .destructive, handler: { (action) in
                    if self.defaults.bool(forKey: "Voted") != true {
                        let alertController2 = UIAlertController(title: "Are you sure you want to vote?", message: "Are you sure you want to vote for \(self.selected)? This action cannot be undone. You will be taken to the stats page if you press yes.", preferredStyle: .alert)
                        alertController2.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
                        alertController2.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                            self.defaults.set(true, forKey: "Voted");
                            self.updateData()
                            self.performSegue(withIdentifier: "goToStats", sender: self)
                            return
                        }))
                        self.present(alertController2, animated: true, completion: nil)
                    }
                    else {
                        self.label.text = "Select a candidate to vote"
                        self.statButton.isEnabled = false
                    }
                }))
                alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    self.performSegue(withIdentifier: "goToPolicies", sender: self)
                    return
                }))
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                if self.defaults.bool(forKey: "Voted") != true {
                    let alertController2 = UIAlertController(title: "Are you sure you want to vote?", message: "Are you sure you want to vote for \(self.selected)? This action cannot be undone. You will be taken to the stats page if you press yes.", preferredStyle: .alert)
                    alertController2.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
                    alertController2.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                        self.defaults.set(true, forKey: "Voted");
                        self.updateData()
                        self.performSegue(withIdentifier: "goToStats", sender: self)
                        return
                    }))
                    self.present(alertController2, animated: true, completion: nil)
                }
            }
        }
    }
    func getData() {
        if defaults.bool(forKey: "Voted") == true {
            statButton.isEnabled = true
            let db = Firestore.firestore()
            let docRef = db.collection("Counter")
            docRef.getDocuments { (snapshot, error) in
                if let err = error {
                    debugPrint("Error fetching docs: \(err)")
                } else {
                    guard let snap = snapshot else { return }
                    for document in snap.documents {
                        let data = document.data()
                        let firebaseState = data["State"] as! String ?? "None"
    //                    print("firebaseState: \(firebaseState)    \(self.state)")
                        if (firebaseState == self.state) {
                            print("hi")
                            let count = data[self.selected] as! Int
                            self.votes = count
                            let raceCount = data[self.race] as! Int
                            self.raceVotes = raceCount
                            if self.raceVotes == 1  && count >= 1 {
                                self.label.text = "\(self.selected) votes: \(count) \n \(self.raceVotes) person has voted of race \(self.race)"
                            }
                            else {
                                self.label.text = "Votes for \(self.selected): \(count) \n \(self.raceVotes) people have voted of race \(self.race)"
                            }
                        }
                    }
                }
            }
        }
        else {
            label.text = "Select a candidate to vote"
            statButton.isEnabled = false
        }
    }
   
    func showMessage(_ title : String, _ message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PieChartViewController {
            let dest = segue.destination as? PieChartViewController
            dest?.state = self.state
        }
    }
    
    func updateData() {
        let db = Firestore.firestore()
        let docRef = db.collection("Counter")
        let doc = docRef.document(state)
        doc.updateData([selected : (votes+1)]) {
            err in
            if let err = err {
                print("Error updating document: \(err)")
            }
            else {
                print("Document succesfully updated!")
            }
        }
        doc.updateData([race : (raceVotes+1)]) {
            err in
            if let err = err {
                print("Error updating document: \(err)")
            }
            else {
                print("Document succesfully updated!")
            }
        }
        getData()
        self.votes+=1
        self.raceVotes+=1
        self.label.text = "\(self.selected) votes: \(votes) \n \(raceVotes) have voted of race \(self.race)"
    }
}

