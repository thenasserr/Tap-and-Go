//
//  LoginViewController.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 21/04/2026.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var contentView: UIStackView!
    @IBOutlet weak var headerView: UIStackView!
    
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: AppMainButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    
    private let viewModel: LoginViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(viewModel: LoginViewModel) {
        
        self.viewModel = viewModel
        
        print("Login VM received by VC:", ObjectIdentifier(viewModel as AnyObject))
        
        super.init(
            nibName: "LoginViewController",
            bundle: nil
        )
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        setupActions()
        bindViewModel()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        viewModel.login()
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        print("Signup Tapped")
        viewModel.signupTapped.send()
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        viewModel.forgotPasswordTapped.send()
    }
}

// MARK: - Setup UI

private extension LoginViewController {
    
    func setupUI() {
        
        view.backgroundColor = UIColor(hex: "#121223")
        headerView.backgroundColor = UIColor(hex: "#121223")
        contentView.backgroundColor = .systemBackground
        
        contentView.layer.cornerRadius = 24
        contentView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        
        contentView.layer.masksToBounds = true
        contentView.isLayoutMarginsRelativeArrangement = true
        contentView.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
        
        titleLabel.text = "Log In"
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        subtitleLabel.text = "Please sign in to your existing account"
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        subtitleLabel.textAlignment = .center
        
        setupEmailField()
        setupPasswordField()
        setupRememberAndForgot()
        setupLoginButton()
        setupBottomSignup()

    }
    
    func setupEmailField() {
        
        emailTitleLabel.text = "EMAIL"
        emailTitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        emailTitleLabel.textColor = UIColor(hex: "#32343E")
        
        emailTextField.placeholder = "example@gmail.com"
        emailTextField.keyboardType = .emailAddress
        emailTextField.textContentType = .emailAddress
    }
    
    func setupPasswordField() {
        
        passwordTitleLabel.text = "PASSWORD"
        passwordTitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        passwordTitleLabel.textColor = UIColor(hex: "#32343E")
        
        passwordTextField.placeholder = "********"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .none
        passwordTextField.backgroundColor = .clear
        passwordTextField.textContentType = .password
    }
        
        func setupRememberAndForgot() {
            
            forgotPasswordButton.setTitle(
                "Forgot Password",
                for: .normal
            )
            forgotPasswordButton.setTitleColor(
                UIColor(hex: "#FF7622"),
                for: .normal
            )
            forgotPasswordButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        }
        
        func setupLoginButton() {
            
            loginButton.setTitle(
                "LOG IN",
                for: .normal
            )
            loginButton.backgroundColor = UIColor(hex: "#FF7622")
            loginButton.setEnabled(false)
        }
        
        func setupBottomSignup() {
            
            bottomLabel.text = "Don’t have an account?"
            bottomLabel.font = .systemFont(ofSize: 16, weight: .regular)
            bottomLabel.textColor = UIColor(hex: "#646982")
            
            signupButton.setTitle(
                "SIGN UP",
                for: .normal
            )
            signupButton.setTitleColor(
                UIColor(hex: "#FF7622"),
                for: .normal
            )
            signupButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        }
    }
    
    // MARK: - Actions Setup
    
    private extension LoginViewController {
        
        func setupActions() {
            
            emailTextField.addTarget(
                self,
                action: #selector(emailChanged),
                for: .editingChanged
            )
            
            passwordTextField.addTarget(
                self,
                action: #selector(passwordChanged),
                for: .editingChanged
            )

            forgotPasswordButton.addTarget(
                self,
                action: #selector(forgotPasswordTapped),
                for: .touchUpInside
            )
        }
    }
    
    // MARK: - Bind ViewModel
    
    private extension LoginViewController {
        
        func bindViewModel() {
            
            viewModel.$isLoading
                .receive(on: DispatchQueue.main)
                .sink { [weak self] isLoading in
                    guard let self else { return }
                    self.loginButton.setLoading(isLoading)
                    self.loginButton.setEnabled(self.viewModel.isLoginEnabled)
                }
                .store(in: &cancellables)
            
            viewModel.$isLoginEnabled
                .receive(on: DispatchQueue.main)
                .sink { [weak self] enabled in
                    
                    self?.loginButton.setEnabled(enabled)
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
    
    private extension LoginViewController {
        
        @objc
        func emailChanged() {
            
            viewModel.email = emailTextField.text ?? ""
        }
        
        @objc
        func passwordChanged() {
            
            viewModel.password = passwordTextField.text ?? ""
        }
    }
    
    // MARK: - Alerts
    
private extension LoginViewController {
        
        func showError(_ message: String) {
            
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            present(alert, animated: true)
        }
        
        func showInfo(_ message: String) {
            
            let alert = UIAlertController(title: "Coming Soon", message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            present(alert, animated: true)
        }
    }
