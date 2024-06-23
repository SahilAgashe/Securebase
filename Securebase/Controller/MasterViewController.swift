//
//  MasterViewController.swift
//  Securebase
//
//  Created by SAHIL AMRUT AGASHE on 22/06/24.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var notes = [String]()
    var userlogin : UserLogin?
    var selectedIndexPath : IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // login if necessary
        if (isUserLoggedIn() == false) {
            login(completion: { [weak self] (uLogin) in
                self?.userlogin = uLogin

                if (self?.isUserLoggedIn() == true) {
                    // handle user logged in or not
                }
            })
        } else if let vc = detailViewController {
            if let note = vc.noteText, note.count > 0 {
                if let ip = selectedIndexPath {
                    notes[ip.row] = note
                    self.tableView.reloadRows(at: [ip], with: .automatic)
                } else {
                    notes.append(note)
                    selectedIndexPath = IndexPath(row: notes.count-1, section: 0)
                    self.tableView.insertRows(at: [selectedIndexPath!],
                                              with: .automatic)
                }
            }
        }
    }

    @objc
    func insertNewObject(_ sender: Any) {
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            // keep a pointer to the VC to get the note when coming back
            detailViewController = (segue.destination as! UINavigationController).topViewController as? DetailViewController
            guard let vc = detailViewController else { return }
            
            // set the note if they selected one
            if let indexPath = tableView.indexPathForSelectedRow {
                self.selectedIndexPath = indexPath
                let object = notes[indexPath.row]
                vc.noteText = object
            } else {
                selectedIndexPath = nil
            }
            
            vc.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            vc.navigationItem.leftItemsSupplementBackButton = true
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = notes[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

