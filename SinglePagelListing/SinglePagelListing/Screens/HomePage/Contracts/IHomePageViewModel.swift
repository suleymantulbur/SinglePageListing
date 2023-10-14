import Foundation

protocol IHomePageViewModel : AnyObject{
    var view: HomePageViewOutput? { get set }
    var pageLoadingStatus : HomePageLoadingStatus {get}
    var peopleList : [Person]{get}
    var peopleCount : Int {get}
    var reachedMaxCount : Bool {get}
    func fetchIntialData()
    func fetchMoreData()
    func refreshPage()
}
