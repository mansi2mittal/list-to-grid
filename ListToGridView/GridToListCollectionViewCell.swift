//
//  GridToListCollectionViewCell.swift
//  ListToGridView
//
//  Created by Appinventiv on 13/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class GridToListCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageLabel: UILabel!
    
    func populateWithData(_ cloth : ClothModel)  {
        
        imageLabel.text = cloth.label
        imageView.image = cloth.image
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }


  }

class GridFlowLayout : UICollectionViewFlowLayout
{
    let itemHeight: CGFloat = 150
    let itemWidth: CGFloat = 150
    
    override init()
    {
        super.init()
        setUpLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLayout()
    {
        minimumInteritemSpacing = 3
        minimumLineSpacing = 3
        scrollDirection = .vertical
    }
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width: itemWidth, height: itemHeight)
        }
        get {
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }

    
}
