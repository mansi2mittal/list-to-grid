//
//  ListToGridView.swift
//  ListToGridView
//
//  Created by Appinventiv on 13/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//


import UIKit

class ClothCell : UICollectionViewCell
{
    

    @IBOutlet weak var clothImage: UIImageView!
    @IBOutlet weak var clothLabel: UILabel!
    
    func populateWithData(_ cloth : ClothModel)  {
        
        clothImage.image = cloth.image
        clothLabel.text = cloth.label
       
    }
    
   override func awakeFromNib()
        
    { super.awakeFromNib()
        
    }
}

   class ListFlowLayout : UICollectionViewFlowLayout
    
    {
    let itemHeight: CGFloat = 92
    
    override init()
    {
        super.init()
        setUpLayout()
    }
    func itemWidth() -> CGFloat
    {
        return ( collectionView!.frame.width)
    }
    
    required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLayout()
    {
        minimumInteritemSpacing = 3
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width:itemWidth(), height: itemHeight)
        }
        get {
            return CGSize(width:itemWidth(), height: itemHeight)
        }
    }
    
}
