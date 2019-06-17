//
//  ViewController.swift
//  CoreDataUsingCodable
//
//  Created by Steven Curtis on 16/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var container: NSPersistentContainer!
    var data = [NSManagedObject]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Create the persistent container and point to the xcdatamodeld - so matches the xcdatamodeld filename
        container = NSPersistentContainer(name: "CoreDataUsingCodable")
        
        // load the database if it exists, if not create it.
        container.loadPersistentStores { storeDescription, error in
            // resolve conflict by using correct NSMergePolicy
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }

        retrieveDataFromURL()
        loadSavedData()
    }
    
    func loadSavedData() {
        let request: NSFetchRequest<Commit> = Commit.fetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            // fetch is performed on the NSManagedObjectContext
            data = try container.viewContext.fetch(request)
            print("Got \(data.count) commits")
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    // save changes from memory back to the database (from memory)
    // viewContext is checked for changes
    // then saves are comitted to the store
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }

    func retrieveDataFromURL() {
        let gitUrl = URL(string: "https://api.github.com/repos/apple/swift/commits?per_page=100")
        // request happens on the background thread
        URLSession.shared.dataTask(with: gitUrl!) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let commitData = try decoder.decode([CommitNode].self, from: data)

                print("Received \(commitData.count) new commits.")

                // Move back on the main thread, as we call tableview.reload
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    for commitNode in commitData {
                        let commit = Commit(context: self.container.viewContext)
                        self.configure(commit: commit, usingNode: commitNode)
                    }
                    self.saveContext()
                    self.loadSavedData()
                }
            } catch let err {
                print("Err", err)
            }
            }.resume()
    }
    
    func configure(commit: Commit, usingNode: CommitNode){
        // requires NSManagedObject subclass
        commit.sha = usingNode.sha
        commit.message = usingNode.commit.message
        commit.url = usingNode.html_url

        let formatter = ISO8601DateFormatter()
        commit.date = (formatter.date(from: usingNode.commit.committer.date )! as NSDate)
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = (data[indexPath.row] as! Commit).message
        cell.detailTextLabel?.text = (data[indexPath.row] as! Commit).date?.description
        return cell
    }
}
