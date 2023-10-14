import Foundation

protocol DataServiceProtocol{
    var delegate : DataServiceDelegate? {get set}
    func fetchData(_ next: String?)
}
