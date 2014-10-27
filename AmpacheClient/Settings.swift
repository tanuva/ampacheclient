//
//  Settings.swift
//  AmpacheClient
//
//  Created by Marcel on 04.10.14.
//  Copyright (c) 2014 FileTrain. All rights reserved.
//

import Foundation
import CoreData

class Settings: NSManagedObject {

    @NSManaged var firstRun: NSNumber
    @NSManaged var username: String
    @NSManaged var passwordHash: String
    @NSManaged var hostname: String

}
