//
//  ListNotesTableViewController.swift
//  MakeSchoolNotes
//
//  Created by Chris Orcutt on 1/10/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

// this is where table view controller related code goes here

import UIKit

class ListNotesTableViewController: UITableViewController {
    
    
    var notes = [Note](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notes = CoreDataHelper.retrieveNotes()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return notes.count
        //1
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listNotesTableViewCell", for: indexPath) as! ListNotesTableViewCell
        let note = notes[indexPath.row]
        cell.noteTitleLabel.text = note.title
        
        cell.noteModificationTimeLabel.text = note.modificationTime?.convertToString() ?? "unknown"
        return cell
        //2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        //1
        guard let identifier = segue.identifier else {return}
        switch identifier{
        case "displayNote":
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let note = notes[indexPath.row]
            let destination = segue.destination as! DisplayNoteViewController
            destination.note = note
        case "addNote":
            print ("create note bar button item tapped")
        default:
            print("unexpected segue")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let noteToDelete = notes[indexPath.row]
            CoreDataHelper.delete(note: noteToDelete)
            notes = CoreDataHelper.retrieveNotes()
            }
    }
    
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue){
        notes = CoreDataHelper.retrieveNotes()
    }
}
