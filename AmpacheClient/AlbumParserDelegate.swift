//
//  AlbumParserDelegate.swift
//  AmpacheClient
//
//  Created by Marcel on 27.09.14.
//  Copyright (c) 2014 FileTrain. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AlbumParserDelegate: NSObject, NSXMLParserDelegate {
	var albums = Array<Album>()
	var albumBuffer: Album?
	var buffer = NSMutableString(format: "")
	var context: NSManagedObjectContext
	
	override init() {
		let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		context = appDel.managedObjectContext!
		super.init()
	}
	
	func newAlbum() -> Album {
		return NSEntityDescription.insertNewObjectForEntityForName("Album", inManagedObjectContext: context) as Album
	}
	
	// === NSXMLParserDelegate protocol ===
	func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!) {
		buffer.setString("")
		
		switch(elementName) {
		case "album":
			albumBuffer = newAlbum()
			albumBuffer!.ampacheId = NSNumber(integer: (attributeDict["id"] as String).toInt()!)
		case "artist":
			var artistId = attributeDict["id"] as String
			var fr = NSFetchRequest(entityName: "Artist")
			var predicate = NSPredicate(format: "ampacheId == %@", NSNumber(integer: artistId.toInt()!))
			fr.predicate = predicate
			fr.fetchLimit = 1
			var error = NSErrorPointer()
			var result = context.executeFetchRequest(fr, error: error) as NSArray?
			if let artist = result {
				albumBuffer!.artist = artist[0] as Artist
			}
			else {
				println("Found album id \(albumBuffer!.ampacheId) with unknown artist \(artistId)")
			}
			
		default:
			break
		}
	}
	
	func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
		switch(elementName) {
		case "name":
			albumBuffer!.name = buffer
		case "album":
			// We read one whole album tag, store it in the list
			albums.append(albumBuffer!)
			println("parsed album \(albumBuffer!.ampacheId)")
		case "year":
			albumBuffer!.year = NSNumber(integer: String(buffer).toInt()!)
		default:
//			println("Ignored element: \(elementName)")
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
