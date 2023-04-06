//
//  HomeViewController.swift
//  WeatherApp-UIKit
//
//  Created by Anwesh on 3/30/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Constraints
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    private var sharedConstraints: [NSLayoutConstraint] = []
    
    // MARK: - Variables
    private var homeViewModel: HomeViewModel = HomeViewModel()
    private var locationManager: LocationManager = {
        LocationManager()
    }()
    
    // MARK: - UI components
    
    private lazy var loaderView: UIView = {
        let view = UIView.autoLayoutView
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.dropShadow()
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.color = .color1
        activityIndicator.startAnimating()
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 120),
            view.widthAnchor.constraint(equalToConstant: 120),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }()
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.searchBar.delegate = self
        sc.searchBar.showsBookmarkButton = true
        sc.searchBar.placeholder = "Enter US city name"
        sc.searchBar.tintColor = self.view.backgroundColor
        sc.searchBar.searchTextField.textColor = .white
        sc.searchBar.setColor(color: .white)
        let imageAppearance = UIImageView.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        imageAppearance.tintColor = .white.withAlphaComponent(0.7)
        let placeholderAppearance = UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        placeholderAppearance.textColor = .white.withAlphaComponent(0.7)
        placeholderAppearance.font = .systemFont(ofSize: 16, weight: .light)
        let appearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white, ]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes
        sc.searchBar.setImage(UIImage(systemName: "location"), for: .bookmark, state: .normal)
        
        return sc
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: - Start of primary view
    
    private lazy var primaryView: UIView = {
        let view = UIView.autoLayoutView
        view.backgroundColor = .color1
        return view
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel.autoLayoutLabel
        label.text = "No City"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel.autoLayoutLabel
        label.text = "Today, \(Date().dateDescription())"
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .white
        return label
    }()
    
    private lazy var tempIconImageView: ImageLoader = {
        let imageView = ImageLoader()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "sun.max")
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var tempDescriptionLabel: UILabel = {
        let label = UILabel.autoLayoutLabel
        label.text = "Clear"
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .white
        return label
    }()
    
    private lazy var mainTempLabel: UILabel = {
        let label = UILabel.autoLayoutLabel
        label.text = "0°"
        label.textColor = .white
        label.font = .systemFont(ofSize: 80, weight: .bold)
        return label
    }()
    
    private lazy var tempUnitsLabel: UILabel = {
        let label = UILabel.autoLayoutLabel
        label.text = "Celsius"
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .white
        return label
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView.autoLayoutImageView
        imageView.image = #imageLiteral(resourceName: "WeatherImage")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //  - End of primary view
    
    
    // MARK: - Start of Secondary view
    
    private lazy var secondaryView: UIView = {
        let view = UIView.autoLayoutView
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var secondaryViewHeaderLabel: UILabel = {
        let label = UILabel.autoLayoutLabel
        label.text = "Weather now"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .color1
        return label
    }()
    
    private var minTempContainerView: UIView = {
        let view = UIView.autoLayoutView
        return view
    }()
    
    private lazy var mintempIconImageView: UIImageView = {
        let imageView = UIImageView.autoLayoutImageView
        let image = UIImage(systemName: "thermometer.medium")
        imageView.image = image
        return imageView
    }()
    
    private lazy var minTempTitleLabel: UILabel = {
        let label = UILabel.autoLayoutLabel
        label.text = "Min temp"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .color1
        return label
    }()
    
    private lazy var minTempLabel: UILabel = {
        let label = UILabel.autoLayoutLabel
        label.text = "0"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .color1
        return label
    }()
    
    private var maxTempContainerView: UIView = {
        let view = UIView.autoLayoutView
        return view
    }()
    
    private lazy var maxtempIconImageView: UIImageView = {
        let imageView = UIImageView.autoLayoutImageView
        imageView.image = UIImage(systemName: "thermometer.high")
        return imageView
    }()
    
    private lazy var maxTempTitleLabel: UILabel = {
        let label = UILabel.autoLayoutLabel
        label.text = "Max. temp"
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .color1
        return label
    }()
    
    private lazy var maxTempLabel: UILabel = {
        let label = UILabel.autoLayoutLabel
        label.text = "0"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .color1
        return label
    }()
    
    private var windSpeedContainerView: UIView = {
        let view = UIView.autoLayoutView
        return view
    }()
    
    private lazy var windSpeedIconImageView: UIImageView = {
        let imageView = UIImageView.autoLayoutImageView
        imageView.image = UIImage(systemName: "wind")
        return imageView
    }()
    
    private lazy var windSpeedTitleLabel: UILabel = {
        let label = UILabel.autoLayoutLabel
        label.text = "Wind Speed"
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .color1
        return label
    }()
    
    private lazy var windSpeedLabel: UILabel = {
        let label = UILabel.autoLayoutLabel
        label.text = "0 m/s"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .color1
        return label
    }()
    
    private var humidityContainerView: UIView = {
        let view = UIView.autoLayoutView
        return view
    }()
    
    private lazy var humidityIconImageView: UIImageView = {
        let imageView = UIImageView.autoLayoutImageView
        imageView.image = UIImage(systemName: "humidity")
        return imageView
    }()
    
    private lazy var humidityTitleLabel: UILabel = {
        let label = UILabel.autoLayoutLabel
        label.text = "Humidity"
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .color1
        return label
    }()
    
    private lazy var humidityLabel: UILabel = {
        let label = UILabel.autoLayoutLabel
        label.text = "0%"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .color1
        return label
    }()
    
    
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupUI()
        setupDelegates()
        handleLaunch()
    }
    
    private func setupDelegates(){
        homeViewModel.delegate = self
    }
    
    
    // MARK: - Setup UI
    private func setupUI(){
        setupNavBar()
        primaryViewLayout()
        cityLabelLayout()
        timeLabelLayout()
        tempIconImageViewLayout()
        tempDescriptionLabelLayout()
        mainTempLabelLayout()
        tempUnitsLabelLayout()
        backgroundImageViewLayout()
        secondaryViewLayout()
        secondaryViewHeaderLabelLayout()
        minTempLayout()
        maxTempLayout()
        windLayout()
        humidityLayout()
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
    }
    
    // MARK: - Setup NavBar
    private func setupNavBar(){
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Weather App"
    }
    
    // MARK: - Primary View Layouts
    
    private func primaryViewLayout(){
        view.addSubview(primaryView)
        regularConstraints.append(contentsOf: [
            primaryView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.70)
        ])
        
        sharedConstraints.append(contentsOf: [
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            primaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        compactConstraints.append(contentsOf: [
            primaryView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1)
        ])
    }
    
    private func cityLabelLayout(){
        primaryView.addSubview(cityLabel)
        sharedConstraints.append(contentsOf: [
            cityLabel.topAnchor.constraint(equalTo: primaryView.topAnchor, constant: 5),
            cityLabel.leadingAnchor.constraint(equalTo: primaryView.safeAreaLayoutGuide.leadingAnchor, constant: 15),
        ])
    }
    
    private func timeLabelLayout(){
        primaryView.addSubview(timeLabel)
        sharedConstraints.append(contentsOf: [
            timeLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 5),
            timeLabel.leadingAnchor.constraint(equalTo: primaryView.safeAreaLayoutGuide.leadingAnchor, constant: 15),
        ])
    }
    
    
    private func tempIconImageViewLayout(){
        primaryView.addSubview(tempIconImageView)
        regularConstraints.append(contentsOf: [
            tempIconImageView.leadingAnchor.constraint(equalTo: primaryView.leadingAnchor, constant: 15),
            tempIconImageView.heightAnchor.constraint(equalToConstant: 50),
            tempIconImageView.widthAnchor.constraint(equalTo: tempIconImageView.heightAnchor)
        ])
        
        sharedConstraints.append(contentsOf: [
            tempIconImageView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20),
        ])
        
        compactConstraints.append(contentsOf: [
            tempIconImageView.leadingAnchor.constraint(equalTo: primaryView.leadingAnchor, constant: 60),
            tempIconImageView.heightAnchor.constraint(equalToConstant: 60),
            tempIconImageView.widthAnchor.constraint(equalTo: tempIconImageView.heightAnchor)
        ])
        
    }
    
    
    private func tempDescriptionLabelLayout(){
        primaryView.addSubview(tempDescriptionLabel)
        regularConstraints.append(contentsOf: [
            tempDescriptionLabel.leadingAnchor.constraint(equalTo: primaryView.leadingAnchor, constant: 25),
        ])
        
        sharedConstraints.append(contentsOf: [
            tempDescriptionLabel.topAnchor.constraint(equalTo: tempIconImageView.bottomAnchor, constant: 5),
        ])
        
        compactConstraints.append(contentsOf: [
            tempDescriptionLabel.centerXAnchor.constraint(equalTo: tempIconImageView.centerXAnchor)
        ])
    }
    
    private func mainTempLabelLayout(){
        primaryView.addSubview(mainTempLabel)
        regularConstraints.append(contentsOf: [
            mainTempLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 15),
            mainTempLabel.trailingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: -30)
        ])
        
        compactConstraints.append(contentsOf: [
            mainTempLabel.trailingAnchor.constraint(equalTo: primaryView.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            mainTempLabel.bottomAnchor.constraint(equalTo: primaryView.bottomAnchor,constant: -140),
        ])
    }
    
    private func tempUnitsLabelLayout(){
        primaryView.addSubview(tempUnitsLabel)
        regularConstraints.append(contentsOf: [
            tempUnitsLabel.bottomAnchor.constraint(equalTo: mainTempLabel.bottomAnchor, constant: 10),
        ])
        sharedConstraints.append(contentsOf: [
            tempUnitsLabel.centerXAnchor.constraint(equalTo: mainTempLabel.centerXAnchor)
        ])
        compactConstraints.append(contentsOf: [
            tempUnitsLabel.bottomAnchor.constraint(equalTo: primaryView.bottomAnchor, constant: -130),
        ])
    }
    
    private func backgroundImageViewLayout(){
        primaryView.addSubview(backgroundImageView)
        regularConstraints.append(contentsOf: [
            backgroundImageView.bottomAnchor.constraint(equalTo: primaryView.bottomAnchor, constant: -35),            backgroundImageView.heightAnchor.constraint(equalTo: primaryView.heightAnchor, multiplier: 0.4),
            backgroundImageView.leadingAnchor.constraint(equalTo: primaryView.leadingAnchor, constant: 10),
            backgroundImageView.trailingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: -10),
        ])
        
        compactConstraints.append(contentsOf: [
            backgroundImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: primaryView.bottomAnchor, constant: -110)
        ])
        
    }
    
    
    
    // MARK: - Secondary View Layouts
    
    private func secondaryViewLayout(){
        view.addSubview(secondaryView)
        regularConstraints.append(contentsOf: [
            secondaryView.topAnchor.constraint(equalTo: primaryView.bottomAnchor, constant: -15),
        ])
        
        sharedConstraints.append(contentsOf: [
            secondaryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            secondaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            secondaryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        compactConstraints.append(contentsOf: [
            secondaryView.heightAnchor.constraint(equalToConstant: 120),
        ])
    }
    
    private func secondaryViewHeaderLabelLayout(){
        view.addSubview(secondaryViewHeaderLabel)
        regularConstraints.append(contentsOf: [
            secondaryViewHeaderLabel.topAnchor.constraint(equalTo: secondaryView.topAnchor, constant: 15),
        ])
        
        sharedConstraints.append(contentsOf: [
            secondaryViewHeaderLabel.leadingAnchor.constraint(equalTo: secondaryView.leadingAnchor, constant: 20),
        ])
        
        compactConstraints.append(contentsOf: [
            secondaryViewHeaderLabel.topAnchor.constraint(equalTo: secondaryView.topAnchor, constant: 5),
        ])
    }
    
    private func createTempDataView(containerView: inout UIView, imageView: inout UIImageView, titleLabel: inout UILabel, dataLabel: inout UILabel){
        
        // VStack
        let vStackView = UIStackView.autoLayoutStackView
        vStackView.axis = .vertical
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(dataLabel)
        
        // HStack
        let hStackView = UIStackView.autoLayoutStackView
        hStackView.axis = .horizontal
        hStackView.addArrangedSubview(imageView)
        hStackView.addArrangedSubview(vStackView)
        hStackView.spacing = 10
        
        // ImageView config
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.7)
        imageView.tintColor = .color1
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 22.5
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = imageView.image?.applyingSymbolConfiguration(config)
        imageView.image = image
        containerView.addSubview(hStackView)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 45),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            hStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            hStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            hStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            hStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        
    }
    
    private func minTempLayout(){
        createTempDataView(containerView: &minTempContainerView, imageView: &mintempIconImageView, titleLabel: &minTempTitleLabel, dataLabel: &minTempLabel)
        secondaryView.addSubview(minTempContainerView)
        regularConstraints.append(contentsOf: [
            
            
        ])
        
        sharedConstraints.append(contentsOf: [
            minTempContainerView.topAnchor.constraint(equalTo: secondaryViewHeaderLabel.bottomAnchor, constant: 15),
            minTempContainerView.leadingAnchor.constraint(equalTo: secondaryView.leadingAnchor, constant: 30),
        ])
        
        compactConstraints.append(contentsOf: [
            
        ])
    }
    
    private func maxTempLayout(){
        createTempDataView(containerView: &maxTempContainerView, imageView: &maxtempIconImageView, titleLabel: &maxTempTitleLabel, dataLabel: &maxTempLabel)
        secondaryView.addSubview(maxTempContainerView)
        regularConstraints.append(contentsOf: [
            maxTempContainerView.trailingAnchor.constraint(equalTo: secondaryView.trailingAnchor, constant: -40),
        ])
        
        sharedConstraints.append(contentsOf: [
            maxTempContainerView.topAnchor.constraint(equalTo: minTempContainerView.topAnchor),
        ])
        compactConstraints.append(contentsOf: [
            maxTempContainerView.leadingAnchor.constraint(equalTo: minTempContainerView.trailingAnchor, constant: 30)
        ])
    }
    
    private func windLayout(){
        createTempDataView(containerView: &windSpeedContainerView, imageView: &windSpeedIconImageView, titleLabel: &windSpeedTitleLabel, dataLabel: &windSpeedLabel)
        secondaryView.addSubview(windSpeedContainerView)
        regularConstraints.append(contentsOf: [
            windSpeedContainerView.topAnchor.constraint(equalTo: minTempContainerView.bottomAnchor, constant: 20),
            windSpeedContainerView.leadingAnchor.constraint(equalTo: minTempContainerView.leadingAnchor),
        ])
        
        compactConstraints.append(contentsOf: [
            windSpeedContainerView.topAnchor.constraint(equalTo: minTempContainerView.topAnchor),
            windSpeedContainerView.leadingAnchor.constraint(equalTo: maxTempContainerView.trailingAnchor, constant: 30)
        ])
    }
    
    private func humidityLayout(){
        createTempDataView(containerView: &humidityContainerView, imageView: &humidityIconImageView, titleLabel: &humidityTitleLabel, dataLabel: &humidityLabel)
        secondaryView.addSubview(humidityContainerView)
        regularConstraints.append(contentsOf: [
            humidityContainerView.topAnchor.constraint(equalTo: windSpeedContainerView.topAnchor),
            humidityContainerView.leadingAnchor.constraint(equalTo: maxTempContainerView.leadingAnchor),
        ])
        
        compactConstraints.append(contentsOf: [
            humidityContainerView.topAnchor.constraint(equalTo: minTempContainerView.topAnchor),
            humidityContainerView.leadingAnchor.constraint(equalTo: windSpeedContainerView.trailingAnchor, constant: 30)
        ])
    }
    
}

// MARK: - Trait collection
extension HomeViewController{
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        
        layoutTrait(traitCollection: traitCollection)
    }
    
    func layoutTrait(traitCollection:UITraitCollection) {
        
        
        
        if (sharedConstraints.first?.isActive == false) {
            // activating shared constraints
            NSLayoutConstraint.activate(sharedConstraints)
        }
        
        if DeviceTypeAndOrientation.isIpad{
            if compactConstraints.first?.isActive == true {
                NSLayoutConstraint.deactivate(compactConstraints)
            }
            // activating compact constraints
            NSLayoutConstraint.activate(regularConstraints)
            return
        }
        
        if (traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular) {
            if compactConstraints.first?.isActive == true {
                NSLayoutConstraint.deactivate(compactConstraints)
            }
            // activating compact constraints
            NSLayoutConstraint.activate(regularConstraints)
        } else {
            
            if regularConstraints.first?.isActive == true {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            // activating regular constraints
            NSLayoutConstraint.activate(compactConstraints)
        }
    }
}

// MARK: - UISearchController Delegate
extension HomeViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            searchController.searchBar.showsBookmarkButton = false
        } else {
            searchController.searchBar.showsBookmarkButton = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let string = searchBar.text?.trimmingCharacters(in: .whitespaces)
        guard let cityName = string, cityName.count > 0 else{return}
        homeViewModel.getWeatherInfoUsingCity(cityName)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar){
        onLocationBtnClicked()
    }
}


// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate{
    
    func onWeatherDataFetchedFromAPI(data: WeatherModel) {
        let cityName: String = data.name + ", " + (data.sys?.country ?? "")
        let timeString: String = "Today, \(Date().dateDescription())"
        let tempDescription: String = data.weather.first?.main ?? "-"
        let mainTemp: String = Int(data.main.temp).description + "°"
        let minTemp: String = "\(data.main.tempMin.description)°"
        let maxTemp: String = "\(data.main.tempMax.description)°"
        let wind: String = "\(data.main.pressure.description) m/s"
        let humidity: String = "\(data.main.humidity.description) %"
        cityLabel.text = cityName
        timeLabel.text = timeString
        tempDescriptionLabel.text = tempDescription
        mainTempLabel.text = mainTemp
        minTempLabel.text = minTemp
        maxTempLabel.text = maxTemp
        windSpeedLabel.text = wind
        humidityLabel.text = humidity
        tempIconImageView.loadImageWithUrl(URL(string: "https://openweathermap.org/img/wn/\(data.weather.first?.icon ?? "")@2x.png")!)
        searchController.searchBar.text = nil
        searchController.dismiss(animated: true)
        hideLoader()
        if data.sys?.country == "US"{
            setLastSearchedCity(cityName: data.name)
        }
    }
    
    func onHttpError(message: String) {
        hideLoader()
        AlertUtil().showAlert(title: "Oops!", message: message, vc: self)
    }
    
    func showLoader() {
        view.addSubview(loaderView)
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func hideLoader(){
        loaderView.removeFromSuperview()
    }
}

// MARK: - Functions
extension HomeViewController{
    
    private func handleLaunch(){
        if locationManager.isLocationPermissionEnabled(){
            print("Location permission enabled and location is turned on Loading current location weather")
            onLocationBtnClicked()
        }
        else if let city = getLastSearchedCity(){
            print("Loading the Last Searched city")
            homeViewModel.getWeatherInfoUsingCity(city)
        }
    }
    
    private func onLocationBtnClicked(){
        let status = locationManager.authorizationStatus()
        print("Location Authorization Status:- \(status.description)")
        switch status{
        case .authorizedWhenInUse:
            if let (lat, long) = locationManager.getCurrentLocation(){
                homeViewModel.getWeatherInfoUsingLatLong(lat: lat, long: long)
            }
            else{
                AlertUtil().showAlert(message: "Unable to get your Location", vc: self)
            }
            break
        default:
            print(status.rawValue)
            print("No authorizedWhenInUse permission")
            AlertUtil().showLocationPermissionAlert(vc: self)
            break
        }
    }
    
    private func setLastSearchedCity(cityName: String){
        UserDefaults.standard.set(cityName, forKey: "setLastSearchedCity")
    }
    
    private func getLastSearchedCity() -> String?{
        UserDefaults.standard.value(forKey: "setLastSearchedCity") as? String
    }
}

enum DeviceTypeAndOrientation {
    static var isIpad: Bool {
        return UIView().traitCollection.horizontalSizeClass == .regular && UIView().traitCollection.verticalSizeClass == .regular
    }
    
    static var isLandscape: Bool {
        return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false
    }
}
