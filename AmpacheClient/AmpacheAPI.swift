//
//  AmpacheAPI.swift
//  AmpacheClient
//
//  Created by Marcel on 23.09.14.
//  Copyright (c) 2014 FileTrain. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol AmpacheAPIProtocol {
	func didReceiveResponse(results: NSDictionary)
}

class AuthParserDelegate: NSObject, NSXMLParserDelegate {
	var token: String?
	var buffer = NSMutableString()
	
	func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!) {
//		println("sta elm: \(elementName)")
		buffer.setString("")
	}
	
	func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
//		println("end elm: \(elementName)")
		
		if(elementName == "auth") {
			token = (buffer.copy() as String)
			buffer.setString("")
			println("token: \(token)")
		}
	}
	
	func parser(parser: NSXMLParser!, foundCharacters string: String) {
//		println("    chars: \(string)")
		buffer.appendString(string)
	}
	
	func parseErrorOcurred(parser: NSXMLParser, error: NSError) {
		println("Error: \(error.localizedDescription)")
	}
}

class AmpacheAPI : NSObject, NSXMLParserDelegate {
	var delegate: AmpacheAPIProtocol?
	var hostname = "http://192.168.1.210/owncloud/index.php/apps/music/ampache"
//	var hostname = "http://192.168.0.14/owncloud/index.php/apps/music/ampache"
	var username = "admin"
	var passwordHash = "16c64e70aad7bd7c1bd1a1e10f5593890641d9a9467eeab31674087976de8cc3" // "f5r3cbqyzlbl"
	var token: String?

	var buffer = NSMutableString()
	var curDelegate: NSXMLParserDelegate?
	var context: NSManagedObjectContext
	
	override init() {
		let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		context = appDel.managedObjectContext!
		super.init()
	}
	
	func sha256(data : NSData) -> NSString {
		var hash = [UInt8](count: Int(CC_SHA256_DIGEST_LENGTH), repeatedValue: 0)
		CC_SHA256(data.bytes, CC_LONG(data.length), &hash)

		let resstr = NSMutableString()
		for byte in hash {
			resstr.appendFormat("%02hhx", byte)
		}
		return resstr
	}
	
	func generatePassphrase(passwordHash: NSString, timestamp: Int) -> NSString {
		// Ampache passphrase: sha256(unixtime + sha256(password)) where '+' denotes concatenation
		
		// Concatenate timestamp and password hash
		var dataStr = "\(timestamp)\(passwordHash)"
		var data = dataStr.dataUsingEncoding(NSASCIIStringEncoding)!
		let passphrase = sha256(data)
		return passphrase
	}
	
	func requestDatabase() {
		var artists = requestArtists()
		var albums = requestAlbums()
		var songs = requestSongs(albums)
		
		var error = NSErrorPointer()
//		if(!context.save(error)) {
//			println(error.debugDescription)
//		}
	}
	
	func authenticate() {
		let timestamp = Int(NSDate().timeIntervalSince1970)
		let passphrase = generatePassphrase(passwordHash, timestamp: timestamp)
		var urlPath = "\(hostname)/server/xml.server.php?action=handshake&auth=\(passphrase)&timestamp=\(timestamp)&version=350001&user=\(username)"

		var url = NSURL(string: urlPath)
		println("Request: \(url)")
//		var request = NSURLRequest(URL: url)
//		var connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
//		connection.start()
		
		var parser = NSXMLParser(contentsOfURL: url)!
		var curDelegate = AuthParserDelegate()
		parser.delegate = curDelegate
		var success = parser.parse()
		if(success) {
			token = curDelegate.token!
		} else {
			println("Couldn't get a login token.")
		}
	}
	
	func requestArtists() -> Array<Artist> {
		if let unwrapToken = token {
			var urlPath = "\(hostname)/server/xml.server.php?auth=\(unwrapToken)&action=artists"
			var url = NSURL(string: urlPath)
			println("Request: \(url)")
			
			var parser = NSXMLParser(contentsOfURL: url)!
			var curDelegate = ArtistParserDelegate()
			parser.delegate = curDelegate
			var success = parser.parse()
			var data = curDelegate.artists
			return data
		}
		else {
			authenticate()
			return requestArtists()
		}
	}
	
	func requestAlbums() -> Array<Album> {
		if let unwrapToken = token {
			var urlPath = "\(hostname)/server/xml.server.php?auth=\(unwrapToken)&action=albums"
			var url = NSURL(string: urlPath)
			println("Request: \(url)")
			
			var parser = NSXMLParser(contentsOfURL: url)!
			var curDelegate = AlbumParserDelegate()
			parser.delegate = curDelegate
			var success = parser.parse()
			var data = curDelegate.albums
			return data
		}
		else {
			authenticate()
			return requestAlbums()
		}
	}
	
	func requestSongs(albums: Array<Album>) -> Array<Song> {
		if let unwrapToken = token {
			var urlPath = "\(hostname)/server/xml.server.php?auth=\(unwrapToken)&action=album_songs&filter="
			var result = Array<Song>()
			
			for album in albums {
				var url = NSURL(string: "\(urlPath)\(album.ampacheId)")
				println("Request: \(url)")
			
				var parser = NSXMLParser(contentsOfURL: url)!
				var curDelegate = SongParserDelegate()
				parser.delegate = curDelegate
				var success = parser.parse()
				for song in curDelegate.songs {
					result.append(song)
				}
			}
			
			return result
		}
		else {
			authenticate()
			return requestSongs(albums)
		}
	}
	
	// === NSURLConnection delegate method ===
	/*func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
		println("Failed with error:\(error.localizedDescription)")
	}

	func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
		//New request so we need to clear the data object
		self.data = NSMutableData()
	}
	
	func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
		//Append incoming data
		self.data.appendData(data)
	}
	
	func connectionDidFinishLoading(connection: NSURLConnection!) {
		//Finished receiving data and convert it to a JSON object
		println(data)
//		delegate?.didReceiveResponse(jsonResult)
	}*/
}
