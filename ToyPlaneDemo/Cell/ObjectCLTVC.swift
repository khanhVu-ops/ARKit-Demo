//
//  ObjectCLTVC.swift
//  ToyPlaneDemo
//
//  Created by BHSoft on 25/08/2022.
//

import UIKit

class ObjectCLTVC: UICollectionViewCell {

    @IBOutlet weak var imgObject: UIImageView!
    @IBOutlet weak var lbNameObject: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(model: Object3DModel) {
        guard let url = URL(string: model.thumbnail ?? "") else {
            return
        }
        imgObject.sd_setImage(with: url)
        lbNameObject.text = model.displayName
    }
}
