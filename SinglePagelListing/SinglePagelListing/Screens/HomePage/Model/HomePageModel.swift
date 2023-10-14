import Foundation

struct HomePageModel{
    var people : [Person] = []
    var next : String? = nil
    var reachedMaxCount : Bool = false
    var loadingStauts : HomePageLoadingStatus = .loading
    
    public mutating func resetModel(){
        people.removeAll()
        next = nil
        reachedMaxCount = false
        loadingStauts = .loading
    }
}
