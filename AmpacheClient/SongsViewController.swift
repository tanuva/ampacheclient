//
//  SongsViewController.swift
//  AmpacheClient
//
//  Created by Marcel on 04.10.14.
//  Copyright (c) 2014 FileTrain. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import CoreData

class SongsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
	var songs: Array<Song>?
	var context: NSManagedObjectContext
	var player: AVQueuePlayer
	
	required init(coder aDecoder: NSCoder) {
		let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		context = appDel.managedObjectContext!
		player = appDel.player!
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// fetch artists from Core Data
		var fetchRequest = NSFetchRequest(entityName: "Song")
		var error = NSErrorPointer()
		songs = context.executeFetchRequest(fetchRequest, error: error) as? Array<Song>
		songs?.sort({ (a: Song, b: Song) in
			return a.name.localizedCaseInsensitiveCompare(b.name) == NSComparisonResult.OrderedAscending
		})
		println("Songs: \(songs!.count)")
	}
	
	// UITableView Data Source
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellIdentifier: String = "SongCell"
		
		//the tablecell is optional to see if we can reuse cell
		var cell : UITableViewCell?
		cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
		
		if let song = songs?[indexPath.row] {
			cell?.textLabel.text = song.name
			cell?.detailTextLabel?.text = song.artist.name + " - " + song.album.name
		}
		else {
			"Unknown song id: \(indexPath.row)"
		}
		return cell!
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return songs?.count ?? 0
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if(segue.identifier == "showPlayerSegue") {
			let dest = (segue.destinationViewController as UINavigationController).viewControllers[0] as PlayerViewController
			let path = (view as UITableView).indexPathForSelectedRow()!
			dest.setPlaylist([songs![path.row]])
		}
	}
}
