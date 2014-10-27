//
//  AlbumsViewController.swift
//  AmpacheClient
//
//  Created by Marcel on 27.09.14.
//  Copyright (c) 2014 FileTrain. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import CoreData

class AlbumsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
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

		// fetch albums from Core Data
		var fetchRequest = NSFetchRequest(entityName: "Album")
		var error = NSErrorPointer()
		albums = context.executeFetchRequest(fetchRequest, error: error) as? Array<Album>
		albums?.sort({ (a: Album, b: Album) in
			return a.name.localizedCaseInsensitiveCompare(b.name) == NSComparisonResult.OrderedAscending
		})
		println("albums: \(albums!.count)")
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if(segue.identifier == "showDetailsSegue") {
			let dest = segue.destinationViewController as AlbumDetailViewController
			let indexPath = (view as UITableView).indexPathForSelectedRow()!
			if let album = albums?[indexPath.row] {
				dest.title = album.artist.name
				dest.albums = [album]
			}
			else {
				fatalError("AlbumsViewController::prepareForSegue: Invalid album array index!")
			}
		}
	}
	
	// UITableView Data Source
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellIdentifier: String = "AlbumCell"
		
		//the tablecell is optional to see if we can reuse cell
		var cell : ButtonTableViewCell?
		cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ButtonTableViewCell
		
		if let album = albums?[indexPath.row] {
			cell?.textLabel.text = album.name
			cell?.detailTextLabel?.text = album.artist.name
		}
		else {
			"Unknown album id: \(indexPath.row)"
		}
		return cell!
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return albums?.count ?? 0
	}
}
