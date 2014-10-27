//
//  FirstViewController.swift
//  AmpacheClient
//
//  Created by Marcel on 23.09.14.
//  Copyright (c) 2014 FileTrain. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController, AmpacheAPIProtocol {
	@IBOutlet weak var btnTest: UIButton!
	@IBOutlet weak var lblFirstView: UILabel!
	
	var api = AmpacheAPI()
	var managedObjectContext: NSManagedObjectContext?

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		api.delegate = self
		btnTest.addTarget(self, action: Selector("buttonTapped:"), forControlEvents: UIControlEvents.TouchUpInside)
		
		let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		managedObjectContext = appDel.managedObjectContext!
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func didReceiveResponse(result: NSDictionary) {
		println(result)
	}

	func buttonTapped(sender: UIButton!) {
		lblFirstView.text = "Blub!"
		// Read data into our own database
		api.requestDatabase()
		
//		if let context = managedObjectContext {
//			api.requestDatabase()
//			
//			var fetchRequest = NSFetchRequest(entityName: "Album")
//			var error = NSErrorPointer()
//			var objs = context.executeFetchRequest(fetchRequest, error: error)! as NSArray
//			for obj in objs {
//				println("fetched: " + (obj.valueForKey("name") as String))
//			}
//		}
	}
}

