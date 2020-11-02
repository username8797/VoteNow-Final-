//
//  SearchBarViewController.swift
//  VoteNow
//
//  Created by Amish Tyagi on 10/21/20.
//

import UIKit
import FirebaseFirestore
class SearchBarViewController: UITableViewController, UISearchBarDelegate {
    
    let states = ["Alaska",
                      "Alabama",
                      "Arkansas",
                      "American Samoa",
                      "Arizona",
                      "California",
                      "Colorado",
                      "Connecticut",
                      "District of Columbia",
                      "Delaware",
                      "Florida",
                      "Georgia",
                      "Guam",
                      "Hawaii",
                      "Iowa",
                      "Idaho",
                      "Illinois",
                      "Indiana",
                      "Kansas",
                      "Kentucky",
                      "Louisiana",
                      "Massachusetts",
                      "Maryland",
                      "Maine",
                      "Michigan",
                      "Minnesota",
                      "Missouri",
                      "Mississippi",
                      "Montana",
                      "North Carolina",
                      "North Dakota",
                      "Nebraska",
                      "New Hampshire",
                      "New Jersey",
                      "New Mexico",
                      "Nevada",
                      "New York",
                      "Ohio",
                      "Oklahoma",
                      "Oregon",
                      "Pennsylvania", 
                      "Puerto Rico",
                      "Rhode Island",
                      "South Carolina",
                      "South Dakota",
                      "Tennessee",
                      "Texas",
                      "Utah",
                      "Virginia",
                      "Virgin Islands",
                      "Vermont",
                      "Washington",
                      "Wisconsin",
                      "West Virginia",
                      "Wyoming"]
    var filteredData: [String]!
    
    var selected = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        filteredData = states
        let db = Firestore.firestore()
        self.tableView.backgroundColor = #colorLiteral(red: 0.8558170199, green: 1, blue: 0.8773060441, alpha: 1)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = filteredData[indexPath.row]
        
        return cell
    }
    // MARK: Search Bar Config
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        if searchText == "" {
            filteredData = states
        }
        else {
            for state in states {
                if state.lowercased().starts(with: searchText.lowercased()) {
                    filteredData.append(state)
                }
            }
            if (filteredData.isEmpty) {
                for state in states {
                    if state.lowercased().contains(searchText.lowercased()) {
                        filteredData.append(state)
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected = filteredData[indexPath.row]
        print(indexPath.row)
        print(selected)
        performSegue(withIdentifier: "goToRaceSelector", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RaceViewController {
            let dest = segue.destination as! RaceViewController
            print(selected)
            print(filteredData)
            dest.state = self.selected
        }
    }
}
