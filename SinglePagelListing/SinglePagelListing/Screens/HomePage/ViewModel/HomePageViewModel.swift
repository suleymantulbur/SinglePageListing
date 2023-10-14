import Foundation

final class HomePageViewModel : IHomePageViewModel{
    private var homePageModel: HomePageModel
    
    var reachedMaxCount: Bool {homePageModel.reachedMaxCount && peopleCount != 0}
    var pageLoadingStatus : HomePageLoadingStatus{homePageModel.loadingStauts}
    var peopleList : [Person]{homePageModel.people}
    var peopleCount : Int {homePageModel.people.count}
    @Dependency var dataService : DataServiceProtocol
    weak var view: HomePageViewOutput?
    
    init(view: HomePageViewOutput? = nil) {
        self.view = view
        self.homePageModel = HomePageModel()
        dataService.delegate = self
    }
    
    func fetchIntialData(){
        fetchData()
    }
    func fetchMoreData(){
        if reachedMaxCount{return}
        fetchData()
    }
    func refreshPage(){
        homePageModel.resetModel()
        fetchData()
    }
    
}

//MARK: - Private funcs
extension HomePageViewModel {
    private func fetchData(){
        handleLoadingChange(loadingStatus: .loading)
        dataService.fetchData(homePageModel.next)
    }
    private func handleLoadingChange(loadingStatus:HomePageLoadingStatus){
        homePageModel.loadingStauts = loadingStatus
        switch loadingStatus {
        case .loading:
            view?.startLoadingAnimation()
        case .loaded:
            view?.stopLoadingAnimation()
        case .error(let message):
            view?.didNotFetch(onError: "An error occurred due to \(message)")
        }
        
    }
}
//MARK: - Data service notifications
extension HomePageViewModel : DataServiceDelegate{
    
    func dataFetchedSuccessfully(response:FetchResponse) {
        handleLoadingChange(loadingStatus: .loaded)
        self.homePageModel.people.append(contentsOf: response.people.filter{ person in
            !self.homePageModel.people.contains{$0.id == person.id}
        })
        self.homePageModel.next = response.next
        self.homePageModel.reachedMaxCount = response.next == nil
        self.view?.fetched()
    }
    
    func initalDataDidNotFetch() {
        handleLoadingChange(loadingStatus: .loaded)
        self.view?.reloadTableView()
    }
    func moreDataDidNotFetch(_ errorText:String) {
        handleLoadingChange(loadingStatus: .error(errorText))
    }
    
}

