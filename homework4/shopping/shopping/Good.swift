//
//  Good.swift
//  shopping
//
//  Created by Astinna on 2020/11/12.
//  Copyright © 2020 NJU. All rights reserved.
//
import UIKit
import os.log
class Good: NSObject, NSCoding{
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
       guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
           os_log("Unable to decode the name for a Good object.", log: OSLog.default, type: .debug)
           return nil
       }
       
       // Because photo is an optional property of Meal, just use conditional cast.
       let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
       
       let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
       
        guard let reason = aDecoder.decodeObject(forKey: PropertyKey.reason) as? String else {
            os_log("Unable to decode the reason for a Good object.", log: OSLog.default, type: .debug)
            return nil
        }
        
       // Must call designated initializer.
        self.init(name: name, photo: photo, reason: reason, rating: rating)
    }
    
  
    struct PropertyKey{
        static let name="name"
        static let photo="photo"
        static let reason="reason"
        static let rating="rating"
    }

    
    var name: String
    var photo: UIImage?
    var reason: String
    var rating: Int
    
    init?(name: String, photo: UIImage?, reason: String, rating: Int){
        if name.isEmpty||reason.isEmpty||rating<0{
            return nil
        }
        self.name=name
        self.photo=photo
        self.reason=reason
        self.rating=rating
    }
    
    //MASK:NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(reason, forKey: PropertyKey.reason)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        
    }
    //MASK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("goods")
}



