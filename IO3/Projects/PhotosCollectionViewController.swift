//
//  PhotosCollectionViewController.swift
//  IO3
//
//  Created by Jason Tesreau on 5/14/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit
import Photos
import CoreData



class PhotosCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
   @IBOutlet weak var myCollectionView: UICollectionView!
	
//   @IBOutlet weak var imageView: UIImageView!
	
    private let reuseIdentifier = "photoCell"

    var selectedImageTag = 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var imagesArray = [UIImage]()
//
	var photos = [Photo]()
	var holder: String?
//	var photo: Photo

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
    
//	override func viewWillAppear(_ animated: Bool) {
//		fetchData()
//	}
	
    @IBAction func addPhotosFunc(_ sender: Any) {
		checkPermission {
			self.getImagesAction()
		}
    }
    
    func getImagesAction() {
        
        let picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        picker.delegate = self
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)
    }
    
    func fetchData() {
        let container = appDelegate.persistentContainer
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
		
//		let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
//
//		do {
//			try context.execute(batchDeleteRequest)
//		}
//		catch{
//			print("error handled")
//		}

        do{
            photos = try context.fetch(fetchRequest)
			
            for image in photos {
                if let placement = image.placement,
                    let filePath = image.filePath {
                    
                    if FileManager.default.fileExists(atPath: filePath) {
                        if let contentsOfFilePath = UIImage(contentsOfFile: filePath) {
                            switch placement {
//							case "top": UIImageView. = contentsOfFilePath
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
		



		
		guard let pickedimage = (info[.originalImage] as? UIImage) else { return }
		
		let imageName = UUID().uuidString
		let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
		
		if let jpegData = pickedimage.jpegData(compressionQuality: 0.8){
			try? jpegData.write(to: imagePath)
		}
		print("the t4st of all teast")
		print(imagePath)
		
		
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		let managedContext = appDelegate.persistentContainer.viewContext
		let fileEntity = NSEntityDescription.entity(forEntityName: "Photo", in: managedContext)!
		let file = NSManagedObject(entity: fileEntity, insertInto: managedContext)
		file.setValue(imagePath.path , forKey: "filePath")
		file.setValue(holder, forKey: "placement")
		photos.append(file as! Photo)
		print(photos.count)
		do{
			try managedContext.save()
		}
		catch let error as NSError{
			print("Couldn't save \(error)")
		}
		
		
		
		
//        appDelegate.saveContext()
		
		
		
//		imagesArray = [pickedimage]
		
			
			
			
			
			
//            newImage = pickedimage
//
//            imagesArray.insert(newImage!, at: 0)
//            imageDefaults.set(imagesArray, forKey: "imagesArray")
            
		
        print("DID WE ARRIVE")
		myCollectionView.reloadData()
        dismiss(animated: true)
		print("how about here")
    }



    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
		print("photos count for sections: \(photos.count)")
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosCell", for: indexPath) as! PhotoCollectionViewCell
			print("testststs")
        //cell.imageView.image = UIImage(named: imagesArray[indexPath.row] )
			print(photos[indexPath.row].filePath!)
			let filePath = photos[indexPath.row].filePath!
		
		
//			if FileManager.default.fileExists(atPath: filePath) {
			if let contentsOfFilePath = UIImage(contentsOfFile: filePath) {
				print("Big ole test")
				cell.configurecell(image: contentsOfFilePath)
			}
			else{
				print("Big ole error")
				}
//		}
//			cell.configurecell(image: imagesArray[indexPath.row])
		
        return cell
    }
	
	func checkPermission(hanler: @escaping () -> Void) {
		let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
		switch photoAuthorizationStatus {
		case .authorized:
			// Access is already granted by user
			hanler()
		case .notDetermined:
			PHPhotoLibrary.requestAuthorization { (newStatus) in
				if newStatus == PHAuthorizationStatus.authorized {
					// Access is granted by user
					hanler()
				}
			}
		default:
			print("Error: no access to photo album.")
		}
	}

	func getDocumentsDirectory() -> URL
	{
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		return documentsDirectory
	}
	
	
	 func clearImagesCache() {
		let fileManager = FileManager.default
		let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
		let documentPath = documentsURL.path
		
		do {
			let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
			for file in files {
				try fileManager.removeItem(atPath: "\(documentPath)/\(file)")
			}
		} catch {
			print("could not clear cache")
		}
		
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
