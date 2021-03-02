//
//  RoundedButton.swift
//  pizzastore
//
//  Created by Carlos Diaz Moreno on 3/2/21.
//

import UIKit



enum CustomButtonStyle : Int {
    case defaultStyle
    case affirmativeStyle
    case negativeStyle
}


@IBDesignable
final class RoundedButton: UIButton {

    var borderWidth: CGFloat = 2.0
    var borderColor = UIColor.white.cgColor
    var type: CustomButtonStyle = CustomButtonStyle.defaultStyle

    @IBInspectable var titleText: String? {
        didSet {
            self.setTitle(titleText, for: .normal)
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        }
    }
    
    @IBInspectable var buttonStyle: Int = CustomButtonStyle.defaultStyle.rawValue {
        didSet {
            type = CustomButtonStyle(rawValue: buttonStyle) ?? .defaultStyle
            setupForStyle(type: type)
        }
    }

    override init(frame: CGRect){
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 8.0
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        setupForStyle(type: type)

    }
    
    func setupForStyle(type: CustomButtonStyle) {
        switch type {
        case .affirmativeStyle:
            self.setTitleColor(UIColor.white,for: .normal)
            self.setTitleColor(UIColor.lightGray, for: .selected)
            self.backgroundColor = UIColor.green.withAlphaComponent(0.8)
        case .negativeStyle:
            self.setTitleColor(UIColor.white,for: .normal)
            self.setTitleColor(UIColor.lightGray, for: .selected)
            self.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        case .defaultStyle:
            self.setTitleColor(UIColor.white,for: .normal)
            self.setTitleColor(UIColor.lightGray, for: .selected)
            self.backgroundColor = UIColor.black
        }
    }
}
