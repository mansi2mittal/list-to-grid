//
//  ViewController.swift
//  ListToGridView
//
//  Created by Appinventiv on 13/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var clothData : [[String :Any]] =
        [
            [  "ClothFabric" : "Cotton" , "ClothImage" : #imageLiteral(resourceName: "Image-1")],
            [ "ClothFabric" : "Cotton" ,"ClothImage" : #imageLiteral(resourceName: "Image-2")],
            [  "ClothFabric" : "Cotton" ,"ClothImage" : #imageLiteral(resourceName: "Image-3") ],
            [ "ClothFabric" : "Cotton" ,"ClothImage" : #imageLiteral(resourceName: "Image-4")],
            [ "ClothFabric" : "Cotton" ,"ClothImage" : #imageLiteral(resourceName: "Image-5")],
            [ "ClothFabric" : "Cotton" ,"ClothImage" : #imageLiteral(resourceName: "Image-7")],
            [ "ClothFabric" : "Cotton" ,"ClothImage" : #imageLiteral(resourceName: "Image-8")],
            [ "ClothFabric" : "Cotton" ,"ClothImage" : #imageLiteral(resourceName: "Image-9")],
            [ "ClothFabric" : "Cotton" ,"ClothImage" : #imageLiteral(resourceName: "Image-10")],
            [ "ClothFabric" : "Cotton" ,"ClothImage" : #imageLiteral(resourceName: "Image-11")],
            [ "ClothFabric" : "Cotton" ,"ClothImage" : #imageLiteral(resourceName: "Image-12")]
            
    ]
    
    // variable to detect what case of enum ( flow layout or grid layout) is been needed
    var detectTypeOfFlow = Flow.list
    
    // variable to detect whether we want the cell selection for action on the cell or while the deletionmode is on
    var cellSelection = DidSelect.cellSelectionMode
    
    // array of selected items to delete
    
    var arrayOfSelectedItems = [IndexPath]()
    
    
    @IBOutlet weak var gridButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
 
    @IBOutlet weak var cellCloseButton: UIButton!
 
    @IBOutlet weak var clothCollectionView: UICollectionView!
    
    
    let listFlowLayoutObject = ListFlowLayout()
    let gridFlowLayoutObject = GridFlowLayout()
    
    var indexPathOfSelectedCellInList = IndexPath()
    var indexPathOfSelectedCellIngrid = IndexPath()
    
    
    // MARK: VIEW LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clothCollectionView.dataSource = self
        clothCollectionView.delegate = self
        deleteButton.isHidden = true
        deleteButton.isEnabled = false
        cellCloseButton.isHidden = true
        cellCloseButton.isEnabled = false
        
        let cellNib = UINib( nibName : "ListToGridView" , bundle : nil)
        
        clothCollectionView.register(cellNib, forCellWithReuseIdentifier: "CollectionViewCellID")
        
        let cellNibGrid = UINib( nibName : "GridToListCollectionViewCell" , bundle : nil)
        
        clothCollectionView.register(cellNibGrid, forCellWithReuseIdentifier: "GridToListID")
        
       // Setting up Initial layout as List Layout
    
       clothCollectionView.collectionViewLayout = ListFlowLayout()
        
      // MARK :  ADDING GESTURE RECOGNIZER
        
        let longPressGestureRecognizer : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGestureRecognizer.minimumPressDuration = 0.5
        longPressGestureRecognizer.delegate = self
        self.clothCollectionView?.addGestureRecognizer(longPressGestureRecognizer)
        
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: ACTIONS
    
    @IBAction func gridButtonTapped(_ sender: Any) {
        
        clothCollectionView.reloadData()
        
        if gridButton.isSelected == true
        {
            detectTypeOfFlow = Flow.grid
            UIView.animate(withDuration: 0.9) { () -> Void in
            self.clothCollectionView.collectionViewLayout.invalidateLayout()
            
            self.clothCollectionView.setCollectionViewLayout(self.gridFlowLayoutObject, animated: true)
            }
            
            gridButton.isSelected = false
        }
        else {
            detectTypeOfFlow = Flow.list
            gridButton.isSelected = true
            
            UIView.animate(withDuration: 0.9) { () -> Void in
                self.clothCollectionView.collectionViewLayout.invalidateLayout()
                
                self.clothCollectionView.setCollectionViewLayout(self.listFlowLayoutObject, animated: true)
        }
       
    }
    
}
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
     for index in arrayOfSelectedItems.sorted().reversed()
     {
        clothData.remove(at: index.row)
        clothCollectionView.deleteItems(at:[index])
        
        }
        
        deleteButton.isHidden = true
        deleteButton.isEnabled = false
        gridButton.isHidden = false
        gridButton.isEnabled = true
        cellSelection = DidSelect.cellSelectionMode
        
        
        arrayOfSelectedItems.removeAll()
        
    }
    
    // MARK : CLOSING THE CELL SELECTED
    
    @IBAction func cellCloseButton(_ sender: Any) {
        
        if detectTypeOfFlow == Flow.list
        {
        
        clothCollectionView.reloadItems(at: [indexPathOfSelectedCellInList])
           
            }
            
        else
        {
        clothCollectionView.reloadItems(at: [indexPathOfSelectedCellIngrid])
        }
        
        gridButton.isHidden = false
        gridButton.isEnabled = true
        cellCloseButton.isHidden = true
        cellCloseButton.isEnabled = false

        }
    }

// MARK: Extension of view controller

extension ViewController : UICollectionViewDataSource , UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout , UIGestureRecognizerDelegate
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return clothData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if detectTypeOfFlow == Flow.grid {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridToListID", for: indexPath) as? GridToListCollectionViewCell
                else {
                    fatalError(" Cell Not Found")
            }
            let clothCell = ClothModel(withData:  clothData[indexPath.item])
            
            cell.populateWithData(clothCell)
            cell.layer.borderWidth = 5
            cell.layer.borderColor = UIColor.white.cgColor
            
            return cell
        }
        else
        {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellID", for: indexPath) as? ClothCell
                else {
                    fatalError(" Cell Not Found")
            }
            let clothCell = ClothModel(withData:  clothData[indexPath.item])
            
            cell.populateWithData(clothCell)
            
            cell.layer.borderWidth = 5
            cell.layer.borderColor = UIColor.white.cgColor
            
            return cell
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if cellSelection == DidSelect.deletionModeOn
        {
        
        if detectTypeOfFlow == Flow.list // if deletion mode of cell is on
        {
        
        let cellNew = collectionView.cellForItem(at: indexPath) as? ClothCell
        cellNew?.layer.borderColor = UIColor.black.cgColor
        arrayOfSelectedItems.append(indexPath)
        }
        else
            
        {   let cellNew = collectionView.cellForItem(at: indexPath) as? GridToListCollectionViewCell
            cellNew?.layer.borderColor = UIColor.black.cgColor
            arrayOfSelectedItems.append(indexPath)
            
        }
        }
        else     // if selection mode of cell is on
        {
            if detectTypeOfFlow == Flow.list
            {
               let cellNew = collectionView.cellForItem(at: indexPath) as? ClothCell
                indexPathOfSelectedCellInList = indexPath
                // enabling the close button to close the cell
                cellCloseButton.isHidden = false
                cellCloseButton.isEnabled = true
                
              cellNew?.superview?.bringSubview(toFront: cellNew!)
             UIView.animate( withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .transitionCrossDissolve, animations: ({
            cellNew?.frame = collectionView.bounds
            }), completion: nil)
                
                gridButton.isHidden = true
                gridButton.isEnabled = false
           }
            else
            {
                let cellNew = collectionView.cellForItem(at: indexPath) as? GridToListCollectionViewCell
                // enabling the close button to close the cell
                indexPathOfSelectedCellIngrid = indexPath
                cellCloseButton.isHidden = false
                cellCloseButton.isEnabled = true
                cellNew?.superview?.bringSubview(toFront: cellNew!)
                UIView.animate( withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .transitionCrossDissolve, animations: ({
                    cellNew?.frame = collectionView.bounds
                }), completion: nil)
                gridButton.isHidden = true
                gridButton.isEnabled = false

    }
    }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell =  self.clothCollectionView.cellForItem(at: indexPath)
        selectedCell?.layer.borderColor = UIColor.white.cgColor
        arrayOfSelectedItems.remove(at: arrayOfSelectedItems.index(of:indexPath )!)
    }
    
    
    
// FUNCTION TO HANDLE THE LONG PRESS GESTURE
    func handleLongPress(gesture : UILongPressGestureRecognizer!) {
            if gesture.state != .ended {
                return
            }
        cellSelection = DidSelect.deletionModeOn
        gridButton.isHidden = true
        gridButton.isEnabled = false
        deleteButton.isHidden = false
        deleteButton.isEnabled = true
    
            clothCollectionView.allowsMultipleSelection = true
            let locationOfCell = gesture.location(in: self.clothCollectionView)
            
            if let indexPath = self.clothCollectionView.indexPathForItem(at: locationOfCell) {
                // get the cell at indexPath (the one you long pressed)
                // do stuff with the cell
                
                clothCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                collectionView(clothCollectionView , didSelectItemAt : indexPath )
                
            } else {
                print("couldn't find index path")
            }
        }
    }
// MARK: - Navigation

// Model to typecast the key and values to appropriate type

class ClothModel {
    
    var image  : UIImage!
    var label : String!
    
    init(withData data : [String:Any]) {
        image = data["ClothImage"] as! UIImage
        label  = data["ClothFabric"] as! String
        
    }
    
}

// Indicator to detect whether list layout is been needed or grid layout

enum Flow
{
    case grid
    case list
}

enum DidSelect
{
    case deletionModeOn
    case cellSelectionMode
}




