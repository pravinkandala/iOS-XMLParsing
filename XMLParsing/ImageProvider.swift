//
//  ImageProvider.swift
//  Your Project Name Here
//
//  Created by Kurt McMahon on 11/3/15.
//  Copyright (c) 2015 Northern Illinois University. All rights reserved.
//

import Foundation
import UIKit

class ImageProvider {
    
    // Optional - you can create the object and pass it instead
    static let sharedInstance = ImageProvider()
    
    let imageCache = NSCache()
    var imageDirectoryURLString = ""
    
    // Gets an image.
    func imageWithName(name: String, completion: (image: UIImage) -> Void) {
        
        let imageFileName = "\(imageDirectoryURLString)\(name)"
        let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        let imagePath = (documents as NSString).stringByAppendingPathComponent(name)

        if let cachedImage = imageCache.objectForKey(name) as? UIImage {
            completion(image: cachedImage)
        } else {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) {
                if let cachedImage = UIImage(contentsOfFile: imagePath) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.imageCache.setObject(cachedImage, forKey: name)
                        completion(image: cachedImage)
                    }
                } else {
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) {
                        if let url = NSURL(string: imageFileName), data = NSData(contentsOfURL: url), let image = UIImage(data: data) {
                            UIImageJPEGRepresentation(image, 100)!.writeToFile(imagePath, atomically: true)
                            dispatch_async(dispatch_get_main_queue()) {
                                self.imageCache.setObject(image, forKey: name)
                                completion(image: image)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Call this method to clear the cache on a memory warning.
    func clearCache() {
        imageCache.removeAllObjects()
    }
}
