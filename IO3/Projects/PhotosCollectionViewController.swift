//
//  PhotosCollectionViewController.swift
//  IO3
//
//  Created by Jason Tesreau on 5/14/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "photoCell"

class PhotosCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var myCollectionView: UICollectionView!
    var imagesArray :[UIImage] = []
    
//    var assetCollection: PHAssetCollection!
//    var photosAsset: PHFetchResult<AnyObject>!
//    var assetThumbnailSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let fetchOptions = PHFetchOptions()
//
//        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
//
//        if let first_Obj:AnyObject = collection.firstObject{
//            //found the album
//            self.assetCollection = first_Obj as! PHAssetCollection
//        }

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        getImagesAction()
        // Do any additional setup after loading the view.
    }
    
    func getImagesAction() {
        
        let picker:UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        picker.delegate = self
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedimage = (info[.editedImage] as? UIImage){
            imagesArray = [pickedimage]
            
        }
        myCollectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }



    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items

        return imagesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosCell", for: indexPath) as! PhotoCollectionViewCell
        //cell.imageView.image = UIImage(named: imagesArray[indexPath.row] )
        cell.configurecell(image: imagesArray[indexPath.row])
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
