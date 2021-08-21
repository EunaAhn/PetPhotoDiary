//
//  ImageButton.swift
//  PetPhotoDiary
//
//  Created by Euna Ahn on 2021/05/24.
//

import UIKit

@IBDesignable open class ImageButton: UIButton {

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        let insetAmount = frame.height / 4.0;
        self.imageEdgeInsets = UIEdgeInsets(top: insetAmount, left: insetAmount, bottom: insetAmount, right: insetAmount);
    }
    
    // MARK: - Public properties
    @IBInspectable open var imageInsets: CGFloat = 0.0 {
        didSet {
            self.updateButton()
        }
    }
    
    // required for IBDesignable class to properly render
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        self.updateButton()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    open override func draw(_ rect: CGRect) {
    }
    
    fileprivate func updateButton() {
        let insetAmount = imageInsets; //frame.height / 4.0;
        self.imageEdgeInsets = UIEdgeInsets(top: insetAmount, left: insetAmount, bottom: insetAmount, right: insetAmount);
    }
    

}
