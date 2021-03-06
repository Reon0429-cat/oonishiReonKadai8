//
//  FirstViewController.swift
//  oonishiReonKadai8
//
//  Created by 大西玲音 on 2021/06/27.
//

import UIKit
import RxSwift
import RxCocoa

final class FirstViewController: UIViewController {
    
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var numberSlider: UISlider!
    
    // 二画面で共通のuseCaseインスタンスを注入
    private let viewModel: ViewModelType = ViewModel(
        valueUseCase: ModelLocator.shared.valueUseCase
    )
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.inputs.viewWillAppear()
        
    }
    
    private func setupBindings() {
        viewModel.outputs.event
            .drive(onNext: { [weak self] event in
                switch event {
                    case .changeSliderValue(let value):
                        self?.numberSlider.value = value
                }
            })
            .disposed(by: disposeBag)
        
        numberSlider.rx.value
            .subscribe(onNext: { [weak self] value in
                // スライダーが移動したことだけを伝える
                self?.viewModel.inputs.sliderValueDidChanged(value: value)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.numberText
            .drive(numberLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}
