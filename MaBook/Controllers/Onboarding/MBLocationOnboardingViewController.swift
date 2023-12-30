//
//  MBLocationOnboardingViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 19.12.2023.
//

import UIKit

class MBLocationOnboardingViewController: UIViewController {
    
    private var country: String? {
        didSet {
            if let country = country {
                locationOnboardingView
                    .configureCountryButtonLabel(with: country)
            }
        }
    }
    private var language: String? {
        didSet {
            if let language = language {
                locationOnboardingView
                    .configureLanguageButtonLabel(with: language)
            }
        }
    }

    private var locationsData: MBOnboardingResponse? {
        didSet {
            guard let data = locationsData,
                  let url = URL(string: data.data.onboardingImage) else {
                MBLogger.shared.debugInfo(
                    "end: locations vc failed with locations data retrieving"
                )
                return
            }
            locationOnboardingView.configureImage(with: url)
        }
    }

    private let locationOnboardingView = MBLocationOnboardingView()
    private let loader = MBLoader()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(loader)
        view.addSubview(locationOnboardingView)

        locationOnboardingView.delegate = self
        fetchLocations()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }


    private func fetchLocations() {
        loader.startLoader()
        OnboardingManager.shared.getLocations { [weak self] result in
            switch result {
            case .success(let data):
                self?.locationsData = data
                self?.showUI()
            case .failure(let failure):
                MBLogger.shared.debugInfo(
                    "end: username sign up vc ended with failure while fetch locations"
                )
                MBLogger.shared.debugInfo("error - \(failure)")

                self?.presentSingleOptionErrorAlert(
                    title: "Damn...",
                    message: "Something went wrong, try again later",
                    buttonTitle: "Got it"
                )
            }
        }
    }

    private func showUI() {
        DispatchQueue.main.async { [weak self] in
            self?.loader.stopLoader()
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.locationOnboardingView.isHidden = false
                self?.locationOnboardingView.alpha = 1
            }
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            locationOnboardingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationOnboardingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            locationOnboardingView.rightAnchor.constraint(equalTo: view.rightAnchor),
            locationOnboardingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension MBLocationOnboardingViewController: MBLocationOnboardingViewDelegate {
    func mbLocationOnboardingViewDidTapCountry(onboardingView: MBLocationOnboardingView) {
        guard let data = locationsData else { return }
        presentListController(with: data.data.countries, title: "Select your country")
    }
    
    func mbLocationOnboardingViewDidTapLanguage(onboardingView: MBLocationOnboardingView) {
        guard let data = locationsData else { return }
        presentListController(with: data.data.languages, title: "Select book language")
    }

    func presentListController(with listData: [String: [String]], title: String) {
        let vc = MBOnboardingListViewController(data: listData)
        let navVC = UINavigationController(rootViewController: vc)

        vc.delegate = self
        vc.title = title
        present(navVC, animated: true)
    }

    func mbLocationOnboardingViewDidTapReady(onboardingView: MBLocationOnboardingView) {
        if let country = country, let language = language,
           country != "Country" && language != "Book Language" {
            OnboardingManager.shared.completeOnboardingWith(
                country: country, language: language) { success in
                    if success {
                        AuthManager.shared.getUser { _ in }
                    }
                }
            let vc = MBPermissionsOnboardingViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MBLocationOnboardingViewController: MBOnboardingListViewControllerDelegate {
    func shouldBeDismissedWithSelection(item: String?) {
        if let item = item, let locationsData = locationsData {
            locationsData.data.countries.values.forEach { array in
                if array.contains(item) {
                    self.country = item
                }
            }
            locationsData.data.languages.values.forEach { array in
                if array.contains(item) {
                    self.language = item
                }
            }
        }
        dismiss(animated: true)

        if let country = country, let language = language,
           country != "Country" && language != "Book Language" {
            locationOnboardingView.configureReadyButtonState()
        }
    }
}
