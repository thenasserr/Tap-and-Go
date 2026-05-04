//
//  AuthCoordinator.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 21/04/2026.
//

import UIKit
import Combine

protocol AuthCoordinator: Coordinator, AnyObject {
    var onAuthFinished: (() -> Void)? { get set }
    
    func showSignup()

    func showLogin()

    func showForgotPassword()
    
    func showVerification(email: String)
    
    func authenticationDidFinish()

}

final class DefaultAuthCoordinator: AuthCoordinator {

    private let navigationController: UINavigationController

    private let dependencyContainer: AuthDependencyContainer

    private var cancellables = Set<AnyCancellable>()

    var onAuthFinished: (() -> Void)?
    
    // MARK: - Init
    
    init(navigationController: UINavigationController, dependencyContainer: AuthDependencyContainer) {

        self.navigationController = navigationController

        self.dependencyContainer = dependencyContainer

    }
    
    deinit {
        
        print("DefaultAuthCoordinator deinit")
    }
    
}

extension DefaultAuthCoordinator {

    func start() {

        showLogin()

    }

}

// MARK: - Show Login

extension DefaultAuthCoordinator {
    
    func showLogin() {
        
        cancellables.removeAll()
        
        let viewModel = dependencyContainer.makeLoginViewModel()
        
        print("Login VM created in coordinator:", ObjectIdentifier(viewModel as AnyObject))
        
        let viewController = LoginViewController(
            viewModel: viewModel
        )
        
        bindLogin(viewModel)
        
        navigationController.setViewControllers(
            [viewController],
            animated: true
        )
    }
}

// MARK: - Show Signup

extension DefaultAuthCoordinator {
    
    func showSignup() {
        
        let viewModel =
        dependencyContainer.makeSignupViewModel()
        
        let viewController =
        SignupViewController(
            viewModel: viewModel
        )
        
        bindSignup(viewModel)
        
        navigationController.pushViewController(
            viewController,
            animated: true
        )
    }
}

private extension DefaultAuthCoordinator {

    func bindLogin(_ viewModel: LoginViewModel) {

        viewModel.loginSuccess

            .sink { [weak self] in

                self?.authenticationDidFinish()

            }

            .store(in: &cancellables)

        viewModel.signupTapped
            .handleEvents(receiveSubscription: { _ in
                print("Coordinator subscribed to signupTapped")
            })
            .sink { [weak self] in
                print("Coordinator received signupTapped")
                self?.showSignup()
            }
            .store(in: &cancellables)
        
        viewModel.forgotPasswordTapped
            .sink(receiveValue: { [weak self] in
                self?.showForgotPassword()
            })

            .store(in: &cancellables)
    }

}

// MARK: - Bind Signup

private extension DefaultAuthCoordinator {
    
    func bindSignup(_ viewModel: SignupViewModel) {
        
        viewModel.signupSuccess
            .sink { [weak self] in
                
                self?.authenticationDidFinish()
            }
            .store(in: &cancellables)
        
        viewModel.loginTapped
            .sink { [weak self] in
                
                self?.navigationController.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Finish Auth

extension DefaultAuthCoordinator {
    
    func authenticationDidFinish() {
        
        cancellables.removeAll()
        onAuthFinished?()
    }
}

// MARK: - Verification

extension DefaultAuthCoordinator {
    func showForgotPassword() {
        let viewModel = dependencyContainer.makeForgotPasswordViewModel(coordinator: self)
        let viewController = ForgotPasswordViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showVerification(email: String) {
        let viewModel = dependencyContainer.makeVerificationViewModel(email: email, coordinator: self)
        let viewController = VerificationViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
