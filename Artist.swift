//
//  AmpacheClient.swift
//  AmpacheClient
//
//  Created by Marcel on 04.10.14.
//  Copyright (c) 2014 FileTrain. All rights reserved.
//

import Foundation
import CoreData

class Artist: NSManagedObject {

    @NSManaged var ampacheId: NSNumber
    @NSManaged var name: String
    @NSManaged var albums: NSOrderedSet
    @NSManaged var songs: NSOrderedSet

}
