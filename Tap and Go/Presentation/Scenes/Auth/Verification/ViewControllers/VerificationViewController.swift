//
//  VerificationViewController.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 29/04/2026.
//

import UIKit
import Combine

class VerificationViewController: UIViewController {

    @IBOutlet weak var verifyButton: AppMainButton!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    private let viewModel: VerificationViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(viewModel: VerificationViewModel) {
        self.viewModel = viewModel
        
        super.init(
            nibName: "VerificationViewController",
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
        print("✅ VerificationViewController deinit")
    }
    @IBAction func verifyTapped(_ sender: Any) {
        viewModel.verify()
    }
}

// MARK: - Setup UI

private extension VerificationViewController {
    
    func setupUI() {
        view.backgroundColor = AppColors.background
        title = "Verification"
        
        titleLabel.text = "Verification"
        titleLabel.font = AppFonts.title()
        titleLabel.textColor = AppColors.textPrimary
        titleLabel.textAlignment = .center
        
        subtitleLabel.text = "We have sent a code to your email\n\(viewModel.emailText)"
        subtitleLabel.font = AppFonts.subtitle()
        subtitleLabel.textColor = AppColors.textSecondary
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        
        otpTextField.placeholder = "Enter 6-digit code"
        otpTextField.keyboardType = .numberPad
        otpTextField.textContentType = .oneTimeCode
        otpTextField.textAlignment = .center
        
        verifyButton.setTitle("VERIFY", for: .normal)
        verifyButton.setEnabled(false)
    }
}

// MARK: - Actions Setup

private extension VerificationViewController {
    
    func setupActions() {
        otpTextField.addTarget(
            self,
            action: #selector(otpChanged),
            for: .editingChanged
        )
    }
}

// MARK: - Binding

private extension VerificationViewController {
    
    func bindViewModel() {
        viewModel.otp
            .receive(on: DispatchQueue.main)
            .sink { [weak self] otp in
                self?.otpTextField.text = otp
            }
            .store(in: &cancellables)
        
        viewModel.isVerifyEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] enabled in
                self?.verifyButton.setEnabled(enabled)
            }
            .store(in: &cancellables)
        
        viewModel.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let message else { return }
                self?.showInfo(message)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Actions

private extension VerificationViewController {
    
    @objc
    func otpChanged() {
        viewModel.updateOTP(otpTextField.text ?? "")
    }
}

// MARK: - Alert

private extension VerificationViewController {
    
    func showInfo(_ message: String) {
        let alert = UIAlertController(
            title: "Coming Soon",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
