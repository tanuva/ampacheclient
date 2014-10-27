//
//  ArtistsViewController.swift
//  AmpacheClient
//
//  Created by Marcel on 27.09.14.
//  Copyright (c) 2014 FileTrain. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import CoreData

class ArtistsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
	var artists: Array<Artist>?
	var context: NSManagedObjectContext
	var player: AVQueuePlayer
	
	required init(coder aDecoder: NSCoder) {
		// get some context
		let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		context = appDel.managedObjectContext!
		player = appDel.player!
		
		super.init(coder: aDecoder)
		println("init coder. doing nothing.")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// fetch artists from Core Data
		var fetchRequest = NSFetchRequest(entityName: "Artist")
		var error = NSErrorPointer()
		artists = (context.executeFetchRequest(fetchRequest, error: error)! as Array<Artist>)
		artists?.sort({ (a: Artist, b: Artist) in
			return a.name.localizedCaseInsensitiveCompare(b.name) == NSComparisonResult.OrderedAscending
		})
		println("artists: \(artists!.count)")
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if(segue.identifier == "showDetailsSegue") {
			let dest = segue.destinationViewController as AlbumDetailViewController
			let indexPath = (view as UITableView).indexPathForSelectedRow()!
			let artist = artists![indexPath.row]
			dest.title = artist.name
			dest.albums = (artist.albums.array as [Album])
		}
	}
	
	// UITableView Data Source
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellIdentifier: String = "ArtistCell"
		
		//the tablecell is optional to see if we can reuse cell
		var cell : ButtonTableViewCell
		cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as ButtonTableViewCell
		
		if let artist = artists?[indexPath.row] {
			cell.player = player
			cell.artist = artist
			cell.lblTitle.text = artist.name ?? "Unknown artist id: \(indexPath.row)"
		}
		return cell
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return artists?.count ?? 0
	}
}
