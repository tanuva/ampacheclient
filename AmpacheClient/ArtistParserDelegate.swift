//
//  XMLParserDelegate.swift
//  AmpacheClient
//
//  Created by Marcel on 25.09.14.
//  Copyright (c) 2014 FileTrain. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ArtistParserDelegate: NSObject, NSXMLParserDelegate {
	var artists = Array<Artist>()
	var artistBuffer: Artist?
	var buffer = NSMutableString(format: "")
	var context: NSManagedObjectContext
	
	override init() {
		let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		context = appDel.managedObjectContext!
		super.init()
	}
	
	func newArtist() -> Artist {
		return NSEntityDescription.insertNewObjectForEntityForName("Artist", inManagedObjectContext: context) as Artist
	}
	
	// === NSXMLParserDelegate protocol ===
	func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!) {
//		println("sta elm: \(elementName)")
		buffer.setString("")
		
		if(elementName == "artist") {
			artistBuffer = newArtist()
			artistBuffer!.ampacheId = NSNumber(integer: (attributeDict["id"] as String).toInt()!)
		}
	}
	
	func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
//		println("end elm: \(elementName) value: \(buffer)")
		switch(elementName) {
		case "name":
			artistBuffer!.name = buffer
		case "artist":
			// We read one whole artist tag, store it in the list
			artists.append(artistBuffer!)
			println("parsed artist \(artistBuffer!.ampacheId)")
		default:
			println("Ignored element: \(elementName)")
		}
		
		buffer.setString("")
	}
	
	func parser(parser: NSXMLParser!, foundCharacters string: String) {
//		println("    art chars: \(string)")
		buffer.appendString(string)
	}
	
	func parseErrorOcurred(parser: NSXMLParser, error: NSError) {
		println("Error: \(error.localizedDescription)")
	}
}
