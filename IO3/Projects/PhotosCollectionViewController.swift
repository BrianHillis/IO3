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
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    var selectedImageTag = 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var imagesArray = [UIImage]()
//    var newImage: UIImage?
//
//    let imageDefaults = UserDefaults.standard
//
//    imagesArray.insert(newImage, at: 0)
//    imageDefaults.set(imagesArray, forKey: "imagesArray")
    
    override func viewDidLoad() {
        super.viewDidLoad()

       fetchData()
//        imagesArray = imageDefaults.array(forKey: "imagesArray") as! [UIImage]

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func addPhotosFunc(_ sender: Any) {
        getImagesAction()
    }
    
    func getImagesAction() {
        
        let picker:UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        picker.delegate = self
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)
    }
    
    func fetchData() {
        let container = appDelegate.persistentContainer
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<Image>(entityName: "Image")
        
        do{
            let images = try context.fetch(fetchRequest)
            
            for image in images {
                if let placement = image.placement,
                    let filePath = image.filePath {
                    
                    if FileManager.default.fileExists(atPath: filePath) {
                        if let contentsOfFilePath = UIImage(contentsOfFile: filePath) {
                            switch placement {
                            case "top": imageView.image = contentsOfFilePath
                            default: break
                            }
                        }
                    }
                }
            }
        } catch {
            print("in catch for image fetch request")
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        let fileManager = FileManager.default
        
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("docURL: \(documentsURL)")
        
        let documentPath = documentsURL.path
        print("docPath: \(documentPath)")
        
        let filePath = documentsURL.appendingPathComponent("\(String(selectedImageTag)).png")
        print("filePath: \(filePath)")
        
        
        do{
            let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
            
            for file in files {
                if "\(documentPath)/\(file)" == filePath.path {
                    try fileManager.removeItem(atPath: filePath.path)
                }
            }
        } catch {
            print("Couldnt add image from doc directory: \(error)")
        }
        
        do {
            if let pngImageData = UIImagePNGRepresentation(image) {
                try pngImageData.write(to: filePath, options: .atomic)
            }
        } catch {
            print("couldnt write image")
        }
        
        let container  = appDelegate.persistentContainer
        let context = container.viewContext
        let entity = Image(context: context)
        entity.filePath = filePath.path
        
        switch selectedImageTag {
        case 1: entity.placement = "top"
        case 2: entity.placement = "middle"
        case 3: entity.placement = "bottom"
        default:
            break
        }
        appDelegate.saveContext()
        
        
        if let pickedimage = (info[.originalImage] as? UIImage){
            imagesArray = [pickedimage]
//            newImage = pickedimage
//
//            imagesArray.insert(newImage!, at: 0)
//            imageDefaults.set(imagesArray, forKey: "imagesArray")
            
        }
//        print("DID WE ARRIVE")
        
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
