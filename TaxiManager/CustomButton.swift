import UIKit


@IBDesignable class CustomButton: UIButton {
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
    }
}
