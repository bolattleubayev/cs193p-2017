//
//  ImageGalleryDocumentTableViewController.swift
//  AssignmentImageGallery
//
//  Created by macbook on 11/5/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit

class ImageGalleryDocumentTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // adding double tap gesture recognition
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    // function that is called when double tap found
    @objc func doubleTapped(sender: UITapGestureRecognizer) {
        if let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView)) {
            if let cell = tableView.cellForRow(at: indexPath) as? GallerySectionTableViewCell {
                cell.textLabel?.isHidden = true // hide the label soit didn't overlap with textfield
                cell.isEditing = true // enable editing
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return GalleryDatabase.documents.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // How many elements the section has?
        return GalleryDatabase.documents[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
            if let inputCell = cell as? GallerySectionTableViewCell {
                if inputCell.isEditing { // if we edited the cell
                    inputCell.textLabel?.isHidden = false // unhide the cell label
                    for i in 0..<GalleryDatabase.documents[0].count { // go through the model to find the entry that needed changes
                        if cell.textLabel?.text == GalleryDatabase.documents[0][i].name { // if found
                            GalleryDatabase.documents[0][i].name = inputCell.cellName // change its name
                            inputCell.cellName = "" // wrap up the renaming
                            inputCell.isEditing = false
                        }
                    }
                }
            }
            // Updating the tableView to match with model
            tableView.deleteRows(at: [indexPath], with: .fade)
            cell.textLabel?.text = GalleryDatabase.documents[indexPath.section][indexPath.row].name
            tableView.insertRows(at: [indexPath], with: .fade)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeleteCell", for: indexPath)
            
            // Configure the cell...
            cell.textLabel?.text = GalleryDatabase.documents[indexPath.section][indexPath.row].name
            return cell
        }
    }
    
    private var galleryNames: [String]? // array of strings needed to avoid repetition of names
    
    // adding a new gallery
    @IBAction func newImageGallery(_ sender: UIBarButtonItem) {
        
        galleryNames = []
        
        for i in 0..<GalleryDatabase.documents[0].count {
            galleryNames?.append(GalleryDatabase.documents[0][i].name)
        }
        
        GalleryDatabase.insert(section: 0, index: 0, newItem: ImageGallerySection(name: "Unitiled".madeUnique(withRespectTo: galleryNames!), items: []))
        
        tableView.reloadData()
    }
    
    // making master table view collapsable
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    // MARK: - Deleting, Adding, and Moving galleries
    // Override to support editing the table view.
    // delete swipe
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            if indexPath.section == 1 {
                GalleryDatabase.remove(section: indexPath.section, index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                // adding gallery to deleted
                GalleryDatabase.insert(section: 1, index: 0, newItem: GalleryDatabase.documents[indexPath.section][indexPath.row])
                tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .fade)
                // removing from main
                GalleryDatabase.remove(section: indexPath.section, index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    // restore swipe
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .normal, title: "Restore") { (contextualAction, view, boolValue) in
            boolValue(true) // pass true if you want the handler to allow the action
            // adding gallery to main
            GalleryDatabase.insert(section: 0, index: 0, newItem: GalleryDatabase.documents[indexPath.section][indexPath.row])
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            // removing from deleted
            GalleryDatabase.remove(section: indexPath.section, index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        
        return swipeActions
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
        if segue.identifier == "GoToGallery" {
            if let galleryName = (sender as? UITableViewCell)?.textLabel { // resolving Any? type of the sender
                if let igcvc = segue.destination.contents as? ImageGalleryCollectionViewController { // igcvc - Image Gallery Collection View Controller, we need to refer to segue.destination.contents, as segue points to Navigation Controller
                    
                    let cell = sender as! UITableViewCell
                    let indexPath = tableView.indexPath(for: cell)
                    
                    // putting needed view
                    igcvc.galleryArray = GalleryDatabase.documents[(indexPath?.section)!][(indexPath?.row)!]
                    igcvc.galleryNameAtIGCVC = galleryName.text!
                    igcvc.title = galleryName.text!
                }
            }
        }
    }
    
    
    /// Put titles for sections
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Galleries"
        case 1:
            return "Recently Deleted"
        default:
            return "?"
        }
    }
}
