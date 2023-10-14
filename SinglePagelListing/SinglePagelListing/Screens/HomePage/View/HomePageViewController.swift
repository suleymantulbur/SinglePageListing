import UIKit

final class HomePageViewController: UIViewController {
    //MARK: - Variable(S)
    private var viewModel: IHomePageViewModel
    private var errorShowing : Bool = false
    //MARK: - View(s)
    private let refreshControl = UIRefreshControl()
    private let informationView = InformationView()
    
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private let tableSpinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .medium
        spinner.startAnimating()
        return spinner
    }()
    
    private let errorLabel : UILabel = {
        let label = UILabel()
        label.text = AppConstants.emptyListErrorText
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        viewModel.fetchIntialData()
    }
    
    init(viewModel: IHomePageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.view = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let apperance = UINavigationBarAppearance()
        apperance.configureWithOpaqueBackground()
        apperance.shadowColor = .systemGray6
        apperance.backgroundColor = .systemGray6
        
        navigationController?.navigationBar.standardAppearance = apperance
        navigationController?.navigationBar.scrollEdgeAppearance = apperance
        navigationController?.navigationBar.compactAppearance = apperance
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: - Layout
extension HomePageViewController {
    
    private func initView(){
        view.backgroundColor = .white
        makeTableView()
    }
    
    private func makeTableView(){
        prepareTableView()
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func prepareTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PersonCell.self, forCellReuseIdentifier: PersonCell.cellIdentifier)
        tableView.backgroundView = errorLabel
        tableView.backgroundView?.isHidden = true
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(change), for: .valueChanged)
    }
    
}

//MARK: - Tableview
extension HomePageViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {AppConstants.tableCellHeight}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {viewModel.peopleCount}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.cellIdentifier) as! PersonCell
        if viewModel.peopleCount != 0 {
            cell.updateLabel(viewModel.peopleList[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = self.viewModel.peopleList.count - 1
        if indexPath.row == lastIndex {
            if errorShowing {return}
            viewModel.fetchMoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if errorShowing{
            informationView.setViewColor(.red)
            return informationView
        }
        if viewModel.reachedMaxCount {
            informationView.setLabelText(AppConstants.allDataFetched)
            informationView.setViewColor(.green)
            
            return informationView
        }
        if viewModel.pageLoadingStatus == .loading {
            return tableSpinner
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {AppConstants.tableFooterHeight}
    
}
//MARK: - Delegate Impl
extension HomePageViewController : HomePageViewOutput {
    func fetched(){
        errorShowing = false
        tableView.refreshControl?.endRefreshing()
        tableView.refreshControl = viewModel.reachedMaxCount || viewModel.peopleCount == 0 ? refreshControl : nil
        tableView.backgroundView?.isHidden = !viewModel.peopleList.isEmpty
        tableView.reloadData()
        
    }
    
    func didNotFetch(onError : String) {
        errorShowing = true
        tableView.refreshControl?.endRefreshing()
        tableView.refreshControl = refreshControl
        informationView.setLabelText(onError)
        tableView.reloadData()
    }
    
    func reloadTableView(){
        errorShowing = false
        tableView.refreshControl?.endRefreshing()
        tableView.backgroundView?.isHidden = false
        tableView.reloadData()
    }
    
    func stopLoadingAnimation(){
        tableSpinner.stopAnimating()
    }
    
    func startLoadingAnimation(){
        if ((tableView.refreshControl?.isRefreshing) != nil){return}
        tableView.refreshControl = nil
        tableSpinner.startAnimating()
    }
}
//MARK: - Objc Functions

extension HomePageViewController{
    @objc func change(){
        viewModel.refreshPage()
    }
}





