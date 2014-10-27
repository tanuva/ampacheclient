//
//  ButtonTableViewCell.swift
//  AmpacheClient
//
//  Created by Marcel on 19.10.14.
//  Copyright (c) 2014 FileTrain. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class ButtonTableViewCell : UITableViewCell {
	var player: AVQueuePlayer?
	var song: Song?
	var album: Album?
	var artist: Artist?
	
	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var lblSubTitle: UILabel!
	
	@IBAction func btnAddToPlaylist(sender: UIButton) {
		var pressPlay = false
		
		if player?.items().count == 0 {
			// If this was the first item added to the playlist, start playing it now
			pressPlay = true
		}
		
		if let actualSong = song {
			player?.insertItem(AVPlayerItem(URL: NSURL(string: actualSong.url)), afterItem: nil)
		} else if let actualAlbum = album {
			appendAlbum(actualAlbum)
		} else if let actualArtist = artist {
			appendArtist(actualArtist)
		}
		
		if pressPlay == true {
			player?.play()
		}
	}
	
	func appendAlbum(album: Album!) {
		// Sort songs by track number before enqueueing them
		var sortedSongs = (album.songs.allObjects as Array<Song>).sorted({ (a: Song, b: Song) in
			return a.track.compare(b.track) == NSComparisonResult.OrderedAscending
		})
		
		for song in sortedSongs {
			player?.insertItem(AVPlayerItem(URL: NSURL(string: song.url)), afterItem: nil)
		}
	}
	
	func appendArtist(artist: Artist!) {
		// Albums should be sorted alphabetically already
		for album in (artist.albums.array as Array<Album>) {
			appendAlbum(album)
		}
	}
}
