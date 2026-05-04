//
//  AppCoordinator.swift
//  Meal Time
//
//  Created by Ibrahim Nasser Ibrahim on 22/04/2026.
//

import UIKit

protocol AppCoordinator: Coordinator, AnyObject {
    
    func showHomeFlow()
    func showAuthFlowAfterLogout()
}

final class DefaultAppCoordinator: AppCoordinator {
    
    private let window: UIWindow
    private let dependencyContainer: AppDependencyContainer
    
    private var navigationController: UINavigationController?
    private var splashCoordinator: SplashCoordinator?
    private var authCoordinator: AuthCoordinator?
    private var homeCoordinator: HomeCoordinator?
    
    // MARK: - Init
    
    init(
        window: UIWindow,
        dependencyContainer: AppDependencyContainer
    ) {
        
        self.window = window
        self.dependencyContainer = dependencyContainer
    }
}

// MARK: - Start

extension DefaultAppCoordinator {
    
    func start() {
        
        let navigationController = dependencyContainer.makeRootNavigationController()
        
        self.navigationController = navigationController
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        routeInitialScreen()
    }
}

// MARK: - Splash Flow

private extension DefaultAppCoordinator {
    
    func showSplash() {
        
        guard let navigationController else { return }
        
        var coordinator = dependencyContainer.makeSplashCoordinator(
            navigationController: navigationController
        )
        
        coordinator.onAuthenticationRequired = { [weak self] in
            
            self?.showAuthFlow()
        }
        
        coordinator.onHomeRequired = { [weak self] in
            
            self?.showHomeFlow()
        }
        
        splashCoordinator = coordinator
        
        coordinator.start()
    }
}

// MARK: - Auth Flow

extension DefaultAppCoordinator {
    
    func showAuthFlow() {
        
        guard let navigationController else { return }
        
        splashCoordinator = nil
        homeCoordinator = nil
        
        let authContainer =
        dependencyContainer.makeAuthDependencyContainer()
        
        var coordinator =
        authContainer.makeAuthCoordinator(
            navigationController: navigationController
        )
        
        coordinator.onAuthFinished = { [weak self] in
            
            self?.showHomeFlow()
        }
        
        authCoordinator = coordinator
        
        coordinator.start()
    }
}

// MARK: - Home Flow

extension DefaultAppCoordinator {
    
    func showHomeFlow() {
        
        guard let navigationController else { return }
        
        splashCoordinator = nil
        authCoordinator = nil
        
        let homeContainer =
        dependencyContainer.makeHomeDependencyContainer()
        
        var coordinator =
        homeContainer.makeHomeCoordinator(
            navigationController: navigationController
        )
        
        coordinator.onLogout = { [weak self] in
            
            self?.showAuthFlowAfterLogout()
        }
        
        homeCoordinator = coordinator
        
        coordinator.start()
    }
}

// MARK: - Logout Navigation

extension DefaultAppCoordinator {
    
    func showAuthFlowAfterLogout() {
        
        splashCoordinator = nil
        homeCoordinator = nil
        authCoordinator = nil
        
        showAuthFlow()
    }
}

// MARK: - Initial Routing

private extension DefaultAppCoordinator {
    
    func routeInitialScreen() {
        
        let authContainer = dependencyContainer.makeAuthDependencyContainer()
        let user = authContainer.makeGetCurrentUserUseCase().execute()
        
        if user != nil {
            
            showHomeFlow()
            return
        }
        
        if dependencyContainer.makeOnboardingStorage().hasSeenOnboarding {
            
            showAuthFlow()
            return
        }
        
        showSplash()
    }
}
