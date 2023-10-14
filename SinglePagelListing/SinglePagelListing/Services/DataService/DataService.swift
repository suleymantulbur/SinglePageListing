import Foundation

final class DataService: DataServiceProtocol{
    public weak var delegate: DataServiceDelegate?
    private let maxRetryCount = AppConstants.maxRetryCount
    private var current = 1
    
    public func fetchData(_ next: String?) {
        DataSource.fetch(next: next) {[weak self] response, error in
            
            if let response{
                
                self?.current = 1
                
                if response.people.isEmpty{
                    self?.delegate?.initalDataDidNotFetch()
                    return
                }
                self?.delegate?.dataFetchedSuccessfully(response: response)
                return
            }
            
            if self!.current>self!.maxRetryCount{
                self?.current = 1
                self?.delegate?.moreDataDidNotFetch(error?.errorDescription ?? AppConstants.unhandledError)
                return
            }
            
            self?.current += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                print("retying")
                self?.fetchData(next)
            }
            
            
        }
    }
}
