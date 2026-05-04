//
//  ForgotPasswordViewController.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 29/04/2026.
//

import UIKit
import Combine

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var sendCodeButton: AppMainButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    private let viewModel: ForgotPasswordViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(viewModel: ForgotPasswordViewModel) {
        self.viewModel = viewModel
        
        super.init(
            nibName: "ForgotPasswordViewController",
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
    
    // MARK: - Deinit
    
    deinit {
        print("✅ ForgotPasswordViewController deinit")
    }
    
    @IBAction func sendCodeTapped(_ sender: Any) {
        viewModel.sendCode()
    }
}

// MARK: - Setup UI

private extension ForgotPasswordViewController {
    
    func setupUI() {
        title = "Forgot Password"
        
        view.backgroundColor = UIColor(hex: "#121223")

        titleLabel.text = "Forgot Password"
        titleLabel.font = AppFonts.title()
        titleLabel.textColor = AppColors.textPrimary
        titleLabel.textAlignment = .center
        
        subtitleLabel.text = "Enter your email address and we’ll send you a verification code."
        subtitleLabel.font = AppFonts.subtitle()
        subtitleLabel.textColor = AppColors.textSecondary
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        
        emailTitleLabel.text = "EMAIL"
        emailTitleLabel.font = AppFonts.caption()
        emailTitleLabel.textColor = AppColors.textPrimary
        
        emailTextField.placeholder = "example@gmail.com"
        emailTextField.keyboardType = .emailAddress
        emailTextField.textContentType = .emailAddress
        
        sendCodeButton.setTitle("SEND CODE", for: .normal)
        sendCodeButton.setEnabled(false)
    }
}

// MARK: - Actions Setup

private extension ForgotPasswordViewController {
    
    func setupActions() {
        emailTextField.addTarget(
            self,
            action: #selector(emailChanged),
            for: .editingChanged
        )
    }
}

// MARK: - Binding

private extension ForgotPasswordViewController {
    
    func bindViewModel() {
        viewModel.success
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let message else { return }
                
                let alert = UIAlertController(
                    title: "Email Sent",
                    message: message,
                    preferredStyle: .alert
                )
                
                alert.addAction(
                    UIAlertAction(
                        title: "OK",
                        style: .default,
                        handler: { [weak self] _ in
                            self?.navigationController?.popViewController(animated: true)
                        }
                    )
                )
                
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.isSendEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] enabled in
                self?.sendCodeButton.setEnabled(enabled)
            }
            .store(in: &cancellables)
        
        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.sendCodeButton.setLoading(isLoading)
            }
            .store(in: &cancellables)
        
        viewModel.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let message else { return }
                self?.showError(message)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Actions

private extension ForgotPasswordViewController {
    
    @objc
    func emailChanged() {
        viewModel.updateEmail(emailTextField.text ?? "")
    }
}

// MARK: - Alert

private extension ForgotPasswordViewController {
    
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
