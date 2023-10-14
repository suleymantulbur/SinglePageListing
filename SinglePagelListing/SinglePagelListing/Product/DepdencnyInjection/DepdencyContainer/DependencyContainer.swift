import Foundation

public final class DependencyContainer{
    public static let shared = DependencyContainer()
    private let dependencyManager = DependencyManager.shared
    private init() {}
    
    public func registerDependencies(){
        dependencyManager.register(value: DataService(), for: DataServiceProtocol.self)
    }
}
