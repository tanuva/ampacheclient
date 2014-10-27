//
//  PlayerViewController.swift
//  AmpacheClient
//
//  Created by Marcel on 04.10.14.
//  Copyright (c) 2014 FileTrain. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import MediaPlayer

class PlayerViewController : UIViewController {
	let player: AVQueuePlayer
	var playlist: Dictionary<AVPlayerItem, Song>
	var playing = false
	
	@IBOutlet weak var btnPlay: UIButton!
	@IBOutlet weak var volumeView: UIView!
	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var lblSubTitle: UILabel!
	
	required init(coder aDecoder:NSCoder) {
		let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		player = appDel.player!
		playlist = Dictionary<AVPlayerItem, Song>(minimumCapacity: 16)
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		player.addObserver(self, forKeyPath: "currentItem", options: nil, context: nil)
		volumeView.backgroundColor = UIColor.clearColor()
		let volView = MPVolumeView(frame: volumeView.bounds)
		volumeView.addSubview(volView)
	}
	
	override func viewDidDisappear(animated: Bool) {
		player.removeObserver(self, forKeyPath: "currentItem")
	}
	
	override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
		if keyPath == "status" {
			switch(player.status) {
			case AVPlayerStatus.ReadyToPlay:
				println("player ready")
			case AVPlayerStatus.Failed:
				println("player failed")
			case AVPlayerStatus.Unknown:
				println("player unknown")
			default:
				fatalError("kaputt")
			}
		}
		println(keyPath)
		if keyPath == "currentItem" {
			let curSong = playlist[player.currentItem]
			lblTitle.text = curSong?.name
			lblSubTitle.text = "\(curSong?.artist.name) - \(curSong?.album.name)"
		}
	}
	
	@IBAction func btnPlay_touchUpInside(sender: UIButton) {
		println("playing \(player.currentItem)")
		if(playing) {
			player.pause()
			btnPlay.setTitle("|>", forState: UIControlState.Normal)
			playing = false
		}
		else {
			player.play()
			btnPlay.setTitle("||", forState: UIControlState.Normal)
			playing = true
		}
	}
	
	@IBAction func volumeSliderChanged(sender: UISlider) {
		player.volume = sender.value
	}
	
	func setPlaylist(songs: [Song]) {
		player.removeAllItems()
		playlist.removeAll(keepCapacity: true)
		
		for song in songs {
			var item = AVPlayerItem(URL: NSURL(string: song.url))
			playlist[item] = song
			player.insertItem(item, afterItem: nil)
		}
		
//		player.currentItem.addObserver(self, forKeyPath: "status", options: nil, context: nil)
	}
	
	func enqueueSong(song: Song, afterCurrent isNext: Bool = false) {
		var item = AVPlayerItem(URL: NSURL(string: song.url))
		if(isNext) {
			player.insertItem(item, afterItem: player.currentItem)
		} else {
			player.insertItem(item, afterItem: nil)
		}
	}
}