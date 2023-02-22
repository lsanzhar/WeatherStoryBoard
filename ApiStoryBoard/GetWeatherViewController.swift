//
//  GetWeatherViewController.swift
//  ApiStoryBoard
//
//  Created by swift on 15.02.2023.
//

import UIKit


protocol GetWeatherViewControllerDelegate: NSObjectProtocol {
    
    func getWeatherForCity(with name: String)
    
}


class GetWeatherViewController: UIViewController {


    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var getWeatherButton: UIButton!
    
    weak var delegate: GetWeatherViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherButton.layer.cornerRadius = 4
        getWeatherButton.layer.masksToBounds = true
        
        
    }
    
    @IBAction func getWeatherPressed(_ sender: Any) {
        let cityName = inputTextField.text ?? "error"
        delegate?.getWeatherForCity(with: cityName)
        dismiss(animated: true, completion: nil)
    }
    

}
