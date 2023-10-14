import Foundation
enum HomePageLoadingStatus : Equatable {
    case loading
    case loaded
    case error(String)
}

