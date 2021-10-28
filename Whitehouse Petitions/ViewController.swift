//
//  ViewController.swift
//  Whitehouse Petitions
//
//  Created by Nick Sagan on 28.10.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var oldPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url){
                parse(json: data)
            } else {
                showError()
            }
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "Check your Internet connection...", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            oldPetitions = petitions
            tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = petitions[indexPath.row].title
        cell.detailTextLabel?.text = petitions[indexPath.row].body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = DetailViewController()
        dvc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(dvc, animated: true)
    }
    @IBAction func credits(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "We The People API", message: "The data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Good", style: .default))
        present(ac, animated: true)
    }
    @IBAction func search(_ sender: UIBarButtonItem) {
        
        petitions = oldPetitions
 
        // create alert
        let ac = UIAlertController(title: "Filter petitions", message: nil, preferredStyle: .alert)
        // add text field
        ac.addTextField()
        
        // create filter alert button
        let submitAction = UIAlertAction(title: "Filter", style: .default) {
            // parameters we send into
            [weak self, weak ac] _ in
            // closure body
            guard let answer = ac?.textFields?[0].text else {return}
            self?.filter(answer)
        }
        
        // add created button
        ac.addAction(submitAction)
        // present alert
        present(ac, animated: true)
        
    }

    
    func filter(_ answer: String) {
        var filteredPetitions = [Petition]()
        
        for petition in petitions {
            if petition.title.contains(answer) || petition.body.contains(answer){
                filteredPetitions.append(petition)
            }
        }
        petitions = filteredPetitions
        tableView.reloadData()
    }
    
}

