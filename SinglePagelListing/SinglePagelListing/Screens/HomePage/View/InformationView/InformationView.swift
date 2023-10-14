import Foundation
import UIKit

class InformationView: UIView {
    private let label: UILabel
    
    override init(frame: CGRect) {
        self.label = UILabel()
        
        super.init(frame: frame)
        
        setupView()
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
    }
    
    private func setupLabel() {
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setViewColor(_ color: UIColor) {
        backgroundColor = color
    }
    
    func setLabelText(_ text: String) {
        label.text = text
    }
}
