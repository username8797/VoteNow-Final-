//
//  RaceViewController.swift
//  VoteNow
//
//  Created by Amish Tyagi on 10/21/20.
//

import UIKit
import FirebaseFirestore
class RaceViewController: UIViewController {

    @IBOutlet weak var africanButton: UIButton!
    @IBOutlet weak var indianButton: UIButton!
    @IBOutlet weak var asianButton: UIButton!
    @IBOutlet weak var latinButton: UIButton!
    @IBOutlet weak var americanButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var noneButton: UIButton!
    
    var selected = "African-American"
    
    var state = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        africanButton.isSelected = true;
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func africanButtonPressed(_ sender: UIButton) {
        sender.isSelected = true
        indianButton.isSelected = false
        asianButton.isSelected = false
        latinButton.isSelected = false
        americanButton.isSelected = false
        otherButton.isSelected = false
        noneButton.isSelected = false
        selected = "African-American"
    }
    
    @IBAction func indianButtonPressed(_ sender: UIButton) {
        sender.isSelected = true
        africanButton.isSelected = false
        asianButton.isSelected = false
        latinButton.isSelected = false
        americanButton.isSelected = false
        otherButton.isSelected = false
        noneButton.isSelected = false
        selected = "Indian"
    }
    
    @IBAction func asianButtonPressed(_ sender: UIButton) {
        sender.isSelected = true
        indianButton.isSelected = false
        africanButton.isSelected = false
        latinButton.isSelected = false
        americanButton.isSelected = false
        otherButton.isSelected = false
        noneButton.isSelected = false
        selected = "Asian-American"
    }
    
    @IBAction func latinButtonPressed(_ sender: UIButton) {
        sender.isSelected = true
        indianButton.isSelected = false
        africanButton.isSelected = false
        asianButton.isSelected = false
        americanButton.isSelected = false
        otherButton.isSelected = false
        noneButton.isSelected = false
        selected = "Latin-American"
    }
    
    @IBAction func americanButtonPressed(_ sender: UIButton) {
        sender.isSelected = true
        indianButton.isSelected = false
        africanButton.isSelected = false
        asianButton.isSelected = false
        latinButton.isSelected = false
        otherButton.isSelected = false
        noneButton.isSelected = false
        selected = "American"
    }
    
    @IBAction func otherButtonPressed(_ sender: UIButton) {
        sender.isSelected = true
        indianButton.isSelected = false
        africanButton.isSelected = false
        asianButton.isSelected = false
        latinButton.isSelected = false
        americanButton.isSelected = false
        noneButton.isSelected = false
        selected = "Other"
    }
    
    @IBAction func noneButtonPressed(_ sender: UIButton) {
        sender.isSelected = true
        indianButton.isSelected = false
        africanButton.isSelected = false
        asianButton.isSelected = false
        latinButton.isSelected = false
        americanButton.isSelected = false
        otherButton.isSelected = false
        selected = "None"
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewController {
            let vc = segue.destination as? ViewController
            vc?.race = self.selected
            vc?.state = self.state
        }
    }
}
