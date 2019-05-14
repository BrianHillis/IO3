//
//  PhotoCollectionViewCell.swift
//  IO3
//
//  Created by Jason Tesreau on 5/14/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    func configurecell(image: UIImage){
        
        
        imageView.image = image
        
    }
}
