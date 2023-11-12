//
//  ViewController.swift
//  iWeather
//
//  Created by Thais Aquino on 9/11/2023.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var backgroundView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "background")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "headerBackground")
        view.layer.cornerRadius = 20
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.6
        return view
    }()
    
    private lazy var cityView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = UIColor.softGray
        return label
    }()
    
    private lazy var temperatureView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 70, weight: .bold)
        label.textAlignment = .left
        label.textColor = UIColor.primaryColor
        return label
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var umidityLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Umidity"
        view.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        view.textColor = UIColor.contrastColor
        view.textAlignment = .left
        return view
    }()
    
    private lazy var umidityValueLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        view.textColor = UIColor.contrastColor
        view.textAlignment = .left
        return view
    }()
    
    private lazy var windLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Wind"
        view.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        view.textColor = UIColor.contrastColor
        view.textAlignment = .left
        return view
    }()
    
    private lazy var windValueLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        view.textColor = UIColor.contrastColor
        view.textAlignment = .left
        return view
    }()
    
    private lazy var stackUmidity: UIStackView = {
        let view = UIStackView(arrangedSubviews: [umidityLabel, umidityValueLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackWind: UIStackView = {
        let view = UIStackView(arrangedSubviews: [windLabel, windValueLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var statsStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            stackUmidity, stackWind
        ])
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.softtGray
        view.spacing = 3
        view.layer.cornerRadius = 10
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
        return view
    }()
    
    private lazy var hourlyForecastLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "PREVISÃO POR HORA"
        view.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        view.textColor = UIColor.contrastColor
        view.textAlignment = .center
        return view
    }()
    
    private lazy var hourlyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 67, height: 90)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.dataSource = self
        view.register(HourlyForecastCollectionViewCell.self, forCellWithReuseIdentifier: HourlyForecastCollectionViewCell.identifier)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var dailyForecastLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "PROXIMOS DIAS"
        view.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        view.textColor = UIColor.contrastColor
        view.textAlignment = .center
        return view
    }()
    
    private lazy var dailyForecastTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: DailyForecastTableViewCell.identifier)
        
        return view
    }()
    
    private let service = Service()
    private let city = City(lat: "47.590358", lon: "9.590579", name: "Kressbronn")
    private var forecastResponse: ForecastResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    private func fetchData() {
        service.fetchData(city: city) { [weak self] response in
            self?.forecastResponse = response
            
            Task { @MainActor in
                self?.loadData()
            }
        }
    }
    
    private func loadData() {
        backgroundView.image = forecastResponse?.current.dt.isDayTime() == true ? UIImage(named: "backgroundDay") : UIImage(named: "backgroundNight")
        cityView.text = city.name
        temperatureView.text = (forecastResponse?.current.temp ?? 0).toCelsius()
        umidityValueLabel.text = "\(forecastResponse?.current.humidity ?? 0)"
        windValueLabel.text = (forecastResponse?.current.windSpeed ?? 0).toKmh()
        weatherIcon.image = UIImage(named: forecastResponse?.current.weather.first?.icon ?? "")
        
        hourlyCollectionView.reloadData()
        dailyForecastTableView.reloadData()
    }
}

extension ViewController: SetupViewProtocol {
    
    func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        headerView.addSubview(cityView)
        headerView.addSubview(temperatureView)
        headerView.addSubview(weatherIcon)
        
        view.addSubview(backgroundView)
        view.addSubview(headerView)
        view.addSubview(statsStack)
        view.addSubview(hourlyForecastLabel)
        view.addSubview(hourlyCollectionView)
        view.addSubview(dailyForecastLabel)
        view.addSubview(dailyForecastTableView)
    }
    
    func setConstraints() {
        backgroundView.setConstaintsToParent(view)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 35),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -35),
            headerView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            cityView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15),
            cityView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            cityView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            cityView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            temperatureView.topAnchor.constraint(equalTo: cityView.bottomAnchor, constant: 12),
            temperatureView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 18),
            temperatureView.heightAnchor.constraint(equalToConstant: 71)
        ])
        
        NSLayoutConstraint.activate([
            weatherIcon.centerYAnchor.constraint(equalTo: temperatureView.centerYAnchor),
            weatherIcon.leadingAnchor.constraint(equalTo: temperatureView.trailingAnchor, constant: 8),
            weatherIcon.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -18),
            weatherIcon.heightAnchor.constraint(equalToConstant: 86),
            weatherIcon.widthAnchor.constraint(equalToConstant: 86)
        ])
        
        NSLayoutConstraint.activate([
            statsStack.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            statsStack.widthAnchor.constraint(equalToConstant: 206),
            statsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            hourlyForecastLabel.topAnchor.constraint(equalTo: statsStack.bottomAnchor, constant: 29),
            hourlyForecastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            hourlyForecastLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35)
        ])
        
        NSLayoutConstraint.activate([
            hourlyCollectionView.topAnchor.constraint(equalTo: hourlyForecastLabel.bottomAnchor, constant: 29),
            hourlyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hourlyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hourlyCollectionView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            dailyForecastLabel.topAnchor.constraint(equalTo: hourlyCollectionView.bottomAnchor, constant: 29),
            dailyForecastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            dailyForecastLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35)
        ])
        
        NSLayoutConstraint.activate([
            dailyForecastTableView.topAnchor.constraint(equalTo: dailyForecastLabel.bottomAnchor, constant: 16),
            dailyForecastTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dailyForecastTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dailyForecastTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastResponse?.hourly.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCollectionViewCell.identifier, for: indexPath) as? HourlyForecastCollectionViewCell else {
            return UICollectionViewCell()
        }
        let hour = forecastResponse?.hourly[indexPath.row]
        cell.loadData(time: hour?.dt.toHourFormat(),
                      iconID: hour?.weather.first?.icon,
                      temp: hour?.temp.toCelsius())
        
        return cell
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastResponse?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastTableViewCell.identifier, for: indexPath) as? DailyForecastTableViewCell else {
            return UITableViewCell()
        }
        let day = forecastResponse?.daily[indexPath.row]
        cell.loadData(weekDay: day?.dt.toWeekdayName(), 
                      min: day?.temp.min.toCelsius(),
                      max: day?.temp.max.toCelsius(),
                      iconID: day?.weather.first?.icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
