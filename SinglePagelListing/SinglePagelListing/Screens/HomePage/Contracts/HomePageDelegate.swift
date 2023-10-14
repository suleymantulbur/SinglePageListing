import Foundation

public protocol HomePageViewOutput: AnyObject{
    func fetched()
    func didNotFetch(onError : String)
    func reloadTableView()
    func startLoadingAnimation()
    func stopLoadingAnimation()
}
