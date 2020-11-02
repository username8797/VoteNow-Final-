//
//  PieChartViewController.swift
//  VoteNow
//
//  Created by Amish Tyagi on 10/24/20.
//

import UIKit
import Charts
import FirebaseFirestore
class PieChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var pieChart: PieChartView!
    
    var bidenDataEntry = PieChartDataEntry()
    var trumpDataEntry = PieChartDataEntry()
    var hawkinsDataEntry = PieChartDataEntry()
    var jorgensenDataEntry = PieChartDataEntry()
    
    var entries = [PieChartDataEntry]()
    
    var state = ""
    
    var people = ["Biden", "Jo", "Trump", "Hawkins"]
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
        getData()
    }
    
    func updateChartData() {
//        print("hi")
        pieChart.backgroundColor = #colorLiteral(red: 0.8558170199, green: 1, blue: 0.8773060441, alpha: 1)
        pieChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        let chartDataSet = PieChartDataSet(entries: entries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [#colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.02807807196, blue: 0, alpha: 1), #colorLiteral(red: 0.1573992463, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)]
        
        chartDataSet.colors = colors as! [NSUIColor]
        
        pieChart.data = chartData
    }

    func getData() {
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
                        var bidenVotes = data["Biden"] as! Int
                        let bidenString = "\(bidenVotes)"
                        print("bidenString: \(bidenString)")
                        self.bidenDataEntry.value = Double(bidenString) ?? 0.0
                        var trumpVotes = data["Trump"] as! Int
                        let trumpString = "\(trumpVotes)"
                        print("trumpString: \(trumpString)")
                        self.trumpDataEntry.value = Double(trumpString) ?? 0.0
                        var hawkinsVotes = data["Hawkins"] as! Int
                        let hawkinsString = "\(hawkinsVotes)"
                        print("trumpString: \(hawkinsString)")
                        self.hawkinsDataEntry.value = Double(hawkinsString) ?? 0.0
                        var jorgensenVotes = data["Jorgensen"] as! Int
                        let jorgensenString = "\(jorgensenVotes)"
                        print("trumpString: \(jorgensenString)")
                        self.jorgensenDataEntry.value = Double(jorgensenString) ?? 0.0
                        print(self.bidenDataEntry.value)
                        print(self.trumpDataEntry.value)
                        print(self.hawkinsDataEntry.value)
                        print(self.jorgensenDataEntry.value)
                        print("almost done")
                        self.bidenDataEntry.label = "Joe Biden"
                        self.trumpDataEntry.label = "Donald Trump"
                        self.hawkinsDataEntry.label = "Howie Hawkins"
                        self.jorgensenDataEntry.label = "Jo Jorgensen"
                        
                        self.entries = [self.bidenDataEntry, self.trumpDataEntry, self.hawkinsDataEntry, self.jorgensenDataEntry]
                        self.updateChartData()
                    }
                }
            }
        }
    }
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if (highlight.x == 0) {
            print("Biden")
        } else if (highlight.x == 1) {
            print("Trump")
        } else if (highlight.x == 2) {
            print("Hawkins")
        } else if (highlight.x == 3) {
            print("Jorgensen")
        }
    }
}
