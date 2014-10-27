//
//  SongParserDelegate.swift
//  AmpacheClient
//
//  Created by Marcel on 29.09.14.
//  Copyright (c) 2014 FileTrain. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SongParserDelegate: NSObject, NSXMLParserDelegate {
	var songs = Array<Song>()
	var songBuffer: Song?
	var buffer = NSMutableString(format: "")
	var context: NSManagedObjectContext
	
	override init() {
		let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		context = appDel.managedObjectContext!
		super.init()
	}
	
	func newSong() -> Song {
		return NSEntityDescription.insertNewObjectForEntityForName("Song", inManagedObjectContext: context) as Song
	}
	
	// === NSXMLParserDelegate protocol ===
	func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!) {
		buffer.setString("")
		
		switch(elementName) {
		case "song":
			songBuffer = newSong()
			songBuffer!.ampacheId = NSNumber(integer: (attributeDict["id"] as String).toInt()!)
		case "artist":
			// fetch artist
			var artistId = attributeDict["id"] as String
			var fr = NSFetchRequest(entityName: "Artist")
			fr.predicate = NSPredicate(format: "ampacheId == %@", NSNumber(integer: artistId.toInt()!))
			fr.fetchLimit = 1
			var error = NSErrorPointer()
			var result = context.executeFetchRequest(fr, error: error) as NSArray?
			if let artist = result {
				songBuffer!.artist = artist[0] as Artist
			}
			else {
				println("Found song id \(songBuffer!.ampacheId) with unknown artist \(artistId)")
			}
		case "album":
			// fetch album
			var albumId = attributeDict["id"] as String
			var fr = NSFetchRequest(entityName: "Album")
			fr.predicate = NSPredicate(format: "ampacheId == %@", NSNumber(integer: albumId.toInt()!))
			fr.fetchLimit = 1
			var error = NSErrorPointer()
			var result = context.executeFetchRequest(fr, error: error) as NSArray?
			if let album = result {
				songBuffer!.album = album[0] as Album
			}
			else {
				println("Found song id \(songBuffer!.ampacheId) with unknown album \(albumId)")
			}
		default:
			println("Ignored element: \(elementName)")
		}
	}
	
	func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
		switch(elementName) {
		case "title":
			songBuffer!.name = buffer
		case "track":
			songBuffer!.track = NSNumber(integer: String(buffer).toInt()!)
		case "url":
			songBuffer!.url = buffer
		case "song":
			// We read one whole artist tag, store it in the list
			songs.append(songBuffer!)
			println("parsed song \(songBuffer!.ampacheId)")
		default:
			break
		}
		
		buffer.setString("")
	}
	
	func parser(parser: NSXMLParser!, foundCharacters string: String) {
		buffer.appendString(string)
	}
	
	func parseErrorOcurred(parser: NSXMLParser, error: NSError) {
		println("Error: \(error.localizedDescription)")
	}
}
