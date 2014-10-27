//
//  AmpacheClient.swift
//  AmpacheClient
//
//  Created by Marcel on 04.10.14.
//  Copyright (c) 2014 FileTrain. All rights reserved.
//

import Foundation
import CoreData

class Album: NSManagedObject {

    @NSManaged var ampacheId: NSNumber
    @NSManaged var name: String
    @NSManaged var year: NSNumber
    @NSManaged var artist: AmpacheClient.Artist
    @NSManaged var songs: NSSet

}
