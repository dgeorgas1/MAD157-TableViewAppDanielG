//
//  ViewController.swift
//  TableViewApp
//
//  Created by student on 2/28/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //[Genre], [Artists, bool value to check if section should be collapsed]
    var artistArray = [
        ["🔽Alternative Metal"], ["Breaking Benjamin", "Bring Me The Horizon", "Chevelle", "Deftones", "Disturbed", "Korn", "Linkin Park", "Mastodon", "Rage Against the Machine", "Sevendust", "Slipknot", "Stone Sour", "System of a Down", "Three Days Grace", "Tool", true],
        
        ["🔽Country"], ["Alan Jackson", "Blake Shelton", "Brad Paisley", "Carrie Underwood", "Dolly Parton", "Faith Hill", "Garth Brooks", "George Strait", "Johnny Cash", "Kenny Chesney", "Luke Bryan", "Miranda Lambert", "Shania Twain", "Tim McGraw", "Willie Nelson", true],
        
        ["🔽Hip Hop"],["Cardi B", "Drake", "Eminem", "Future", "J. Cole", "Jay-Z", "Kanye West", "Kendrick Lamar", "Lil Wayne", "Megan Thee Stallion", "Nas", "Nicki Minaj", "Post Malone", "Snoop Dogg", "Travis Scott", true],
        
        ["🔽Pop"], ["Adele", "Ariana Grande", "Beyoncé", "Bruno Mars", "Drake", "Dua Lipa", "Ed Sheeran", "Justin Bieber", "Katy Perry", "Lady Gaga", "Maroon 5", "Rihanna", "Shawn Mendes", "Taylor Swift", "The Weeknd", true],

        ["🔽Rock"], ["AC/DC", "Coldplay", "Foo Fighters", "Guns N' Roses", "Led Zeppelin", "Nirvana", "Pearl Jam", "Pink Floyd", "Queen", "Radiohead", "Red Hot Chili Peppers", "The Beatles", "The Rolling Stones", "The Who", "U2", true]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Connection outlets for dataSource and delegate to ViewController made in Main Storyboard
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return artistArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let collapsed = artistArray[section].last as? Bool, collapsed {
            return 0
        }
        
        //Genre
        if section % 2 == 0 {
            return artistArray[section].count
        }
        //Artists minus bool value
        else {
            return artistArray[section].count - 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TableView cell identifier set in attributes inspector
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = artistArray[indexPath.section][indexPath.row] as? String
        
        tableView.backgroundColor = UIColor(red: 100/255.0, green: 127/255.0, blue: 155/255.0, alpha: 1.0)
        
        if indexPath.section % 2 == 0 {
            cell.backgroundColor = UIColor(red: 73/255.0, green: 166/255.0, blue: 70/255.0, alpha: 1.0)
        }
        else {
            cell.backgroundColor = UIColor(red: 100/255.0, green: 127/255.0, blue: 155/255.0, alpha: 1.0)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        //Genre is clicked
        let artistSection = section + 1
        if section % 2 == 0 {
            if artistSection < artistArray.count {
                //Change bool value to determine whether Artist section should be collapsed or expanded
                artistArray[artistSection][15] = !(artistArray[artistSection][15] as? Bool ?? false)
                tableView.reloadSections(IndexSet(integer: artistSection), with: .automatic)
                
                //Reverse arrow emoji
                if let genre = artistArray[section][0] as? String {
                    let upArrow = "🔼"
                    let downArrow = "🔽"
                    
                    if genre.contains(upArrow) {
                        artistArray[section][0] = genre.replacingOccurrences(of: upArrow, with: downArrow)
                    }
                    else {
                        artistArray[section][0] = genre.replacingOccurrences(of: downArrow, with: upArrow)
                    }
                    tableView.reloadSections(IndexSet(integer: section), with: .automatic)
                }
            }
        }
        //Artist is clicked
        else {
            let artist = artistArray[section][indexPath.row] as? String
            let alert = UIAlertController(title: "Would You Like To Change The Artist Name?", message: "Enter An Artist Name", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: {
                (textField) in textField.placeholder = "Artist Name"
            })
            
            let changeAction = UIAlertAction(title: "Change", style: .default, handler: {
                action -> Void in
                let newArtist = alert.textFields![0] as UITextField
                if let position = self.artistArray[section].firstIndex(where: {$0 as? String == artist}){
                    self.artistArray[section][position] = newArtist.text!
                    
                    //Sort array with changed artist name
                    let arrayOriginal = self.artistArray[section]
                    let arrayToSort = arrayOriginal[0..<arrayOriginal.count - 1]
                    var arraySorted = arrayToSort.sorted { ($0 as? String)! < ($1 as? String)! }
                    arraySorted = arraySorted + [arrayOriginal.last!]
                    self.artistArray[section] = arraySorted
                }
                else {
                }
                tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            })
            alert.addAction(changeAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                action -> Void in
            })
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
