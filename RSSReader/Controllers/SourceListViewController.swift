//
//  ViewController.swift
//  RSSReader
//
//  Created by Eric Castillo on 4/29/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import CoreData

class SourceListViewController: UITableViewController {
    
    var sourcesArray = [Source]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var sourceURLs = ["http://feeds.macrumors.com/MacRumors-All",
                      "http://feeds.macrumors.com/MacRumors-All",
                      "http://feeds.macrumors.com/MacRumors-All"]
    var sourceNames = ["Macrumors",
                          "Macrumors",
                          "Macrumors"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadSources()
    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourcesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SourceCell", for: indexPath)
        cell.textLabel?.text = sourcesArray[indexPath.row].feedURL
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToSource", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SourceViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.feedURL = sourcesArray[indexPath.row].feedURL!
        }
    }
    
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Feed", message: "", preferredStyle: .alert)
        var alertTextField = UITextField()
        alert.addTextField { (textField) in
            textField.placeholder = "Enter a feed URL"
            alertTextField = textField
        }
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            let newSource = Source(context: self.context)
            newSource.feedURL = alertTextField.text
            newSource.name = ""
            self.sourcesArray.append(newSource)
            self.saveSources()
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - TableView Manipulation Methods
    func loadSources() {
        let request: NSFetchRequest<Source> = Source.fetchRequest()
        do {
            sourcesArray = try context.fetch(request)
        } catch {
            print("Error fetching Source request: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func saveSources() {
        do {
            try context.save()
        } catch {
            print("Error saving Source context: \(error)")
        }
        
        tableView.reloadData()
    }

}

