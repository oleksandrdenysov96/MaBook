//
//  MBLocationOnboardingViewController.swift
//  MaBook
//
//  Created by Oleksandr Denysov on 19.12.2023.
//

import UIKit

class MBLocationOnboardingViewController: UIViewController {
    
    private var country: String?
    private var language: String?
    private var locationsData: MBOnboardingResponse?
    private let locationOnboardingView = MBLocationOnboardingView()
    private let loader = MBLoader()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        locationOnboardingView.isHidden = true
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
        loader.stopLoader()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.locationOnboardingView.isHidden = false
            self?.locationOnboardingView.alpha = 1
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
        guard let data = locationsData else {
            return
        }
        let vc = MBOnboardingListViewController(data: data.data.countries)
        vc.delegate = self
        present(vc, animated: true)

    }
    
    func mbLocationOnboardingViewDidTapLanguage(onboardingView: MBLocationOnboardingView) {
    }
    
    func mbLocationOnboardingViewDidTapReady(onboardingView: MBLocationOnboardingView) {

    }
}

extension MBLocationOnboardingViewController: MBOnboardingListViewControllerDelegate {
    func didSelectCountry(_ country: String) {
        self.country = country
        locationOnboardingView.modifyButtonTitle(countryTitle: country)
    }
    
    func didSelectLanguage(_ language: String) {
        self.language = language
        locationOnboardingView.modifyButtonTitle(languageTitle: language)
    }
    
    func didTapClose() {
        dismiss(animated: true)
    }
    

}
