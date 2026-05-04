//
//  SignupViewController.swift
//  Meal Time
//
//  Created by Ibrahim Nasser Ibrahim on 21/04/2026.
//

import UIKit
import Combine

class SignupViewController: UIViewController {
    
    private let viewModel: SignupViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    private let nameTextField = UITextField()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let confirmPasswordTextField = UITextField()
    private let signupButton = UIButton(type: .system)
    private let loginButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Init
    
    init(viewModel: SignupViewModel) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
}

// MARK: - UI

private extension SignupViewController {
    
    func setupUI() {
        
        view.backgroundColor = .systemBackground
        title = "Sign Up"
        
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        confirmPasswordTextField.placeholder = "Confirm Password"
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.isSecureTextEntry = true
        
        signupButton.setTitle("Create Account", for: .normal)
        loginButton.setTitle("Already have an account? Login", for: .normal)
        
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [
            nameTextField,
            emailTextField,
            passwordTextField,
            confirmPasswordTextField,
            signupButton,
            loginButton,
            activityIndicator
        ])
        
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - Binding

private extension SignupViewController {
    
    func bindViewModel() {
        
        bindInputs()
        bindOutputs()
    }
}

// MARK: - Inputs

private extension SignupViewController {
    
    func bindInputs() {
        
        nameTextField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        confirmPasswordTextField.addTarget(
            self,
            action: #selector(confirmPasswordChanged),
            for: .editingChanged
        )
    }
    
    @objc
    func nameChanged() {
        
        viewModel.name = nameTextField.text ?? ""
    }
    
    @objc
    func emailChanged() {
        
        viewModel.email = emailTextField.text ?? ""
    }
    
    @objc
    func passwordChanged() {
        
        viewModel.password = passwordTextField.text ?? ""
    }
    
    @objc
    func confirmPasswordChanged() {
        
        viewModel.confirmPassword = confirmPasswordTextField.text ?? ""
    }
    
}

// MARK: - Outputs

private extension SignupViewController {
    
    func bindOutputs() {
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                
                if isLoading {
                    
                    self?.activityIndicator.startAnimating()
                    
                } else {
                    
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isSignupEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] enabled in
                
                self?.signupButton.isEnabled = enabled
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                
                guard let message else { return }
                
                self?.showError(message)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Actions

private extension SignupViewController {
    
    @objc
    func signupTapped() {
        
        viewModel.signup()
    }
    
    @objc
    func loginTapped() {
        
        viewModel.loginTapped.send()
    }
}

// MARK: - Alert

private extension SignupViewController {
    
    func showError(_ message: String) {
        
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
}
