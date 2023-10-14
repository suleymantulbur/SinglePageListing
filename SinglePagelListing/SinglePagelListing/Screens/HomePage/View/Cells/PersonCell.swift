import Foundation
import UIKit

final class PersonCell : UITableViewCell{
    public static let cellIdentifier = AppConstants.personCellIdentifier
    
    private let personInformationLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: PersonCell.cellIdentifier)
        selectionStyle = .none
        makeLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLabel(){
        addSubview(personInformationLabel)
        
        NSLayoutConstraint.activate([
            personInformationLabel.topAnchor.constraint(equalTo:topAnchor),
            personInformationLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            personInformationLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    public func updateLabel(_ person:Person){
        personInformationLabel.text = "\(person.fullName)(\(person.id))"
    }
}
