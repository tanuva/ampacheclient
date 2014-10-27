//
//  AlbumDetailViewController.swift
//  AmpacheClient
//
//  Created by Marcel on 12.10.14.
//  Copyright (c) 2014 FileTrain. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import CoreData

class AlbumDetailViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
	var albums: Array<Album>?
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
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if(segue.identifier == "showPlayerSegue") {
			let dest = (segue.destinationViewController as UINavigationController).viewControllers[0] as PlayerViewController
			let path = (view as UITableView).indexPathForSelectedRow()!
			let album = albums![path.section]
			var songs = Array<Song>()
			for i in path.row ..< album.songs.count {
				let albumSongs = album.songs.allObjects as Array<Song>
				songs.append(albumSongs[i])
			}

			dest.setPlaylist(songs)
		}
	}
	
	// UITableView Data Source
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellIdentifier: String = "SongCell"
		
		//the tablecell is optional to see if we can reuse cell
		var cell : ButtonTableViewCell?
		cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ButtonTableViewCell
		
		if let album = albums?[indexPath.section] {
//			cell?.textLabel?.text = (album.songs.allObjects[indexPath.row] as Song).name
//			cell?.detailTextLabel?.text = album.artist.name
			let songs = album.songs.allObjects
			cell?.song = songs[indexPath.row] as? Song
			cell?.lblTitle.text = cell?.song?.name
			cell?.player = player
		}
		else {
			"Unknown album id: \(indexPath.row)"
		}
		return cell!
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return albums?[section].name ?? "Unknown album"
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return albums?.count ?? 0
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return albums?[section].songs.count ?? 0
	}
}
