//
//  AmpacheClient.swift
//  AmpacheClient
//
//  Created by Marcel on 04.10.14.
//  Copyright (c) 2014 FileTrain. All rights reserved.
//

import Foundation
import CoreData

class Song: NSManagedObject {

    @NSManaged var ampacheId: NSNumber
    @NSManaged var name: String
    @NSManaged var track: NSNumber
    @NSManaged var url: String
    @NSManaged var album: AmpacheClient.Album
    @NSManaged var artist: AmpacheClient.Artist

}
