import Foundation
public protocol DataServiceDelegate:AnyObject{
    func dataFetchedSuccessfully(response:FetchResponse)
    func initalDataDidNotFetch()
    func moreDataDidNotFetch(_ errorText : String)
}
