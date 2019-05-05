//
//  MeditationViewController.swift
//  KarthikMeditationApp
//
//  Created by Karthik K Manoj on 04/05/19.
//  Copyright © 2019 Karthik K Manoj. All rights reserved.
//

import UIKit
import AVFoundation

class MeditationViewController: UIViewController {

    var isPlaying = false
    
    var isRestart = false
    
    var player : AVPlayer!
    
    var playerItem : AVPlayerItem!
    
    var meditaion : Meditation! {
        
        didSet {
        
            setupImage()
        
            setupAudioPlayerAndPlay()
            
        }
        
    }
    
    let pausePlayButton : UIButton = {
       
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.tintColor = .white
        
        let image = UIImage(named: "pause")
        
        button.setImage(image, for: .normal)
        
        button.addTarget(self, action: #selector(MeditationViewController.handlePause), for: .touchUpInside)
        
        button.isHidden = true
        
        return button
        
    }()
    
    
    let activityIndicatorView : UIActivityIndicatorView = {
       
        let aView = UIActivityIndicatorView(style: .whiteLarge)
        
        aView.startAnimating()
        
        aView.translatesAutoresizingMaskIntoConstraints = false
        
        return aView
        
    }()
    
    let containerView : UIView = {
       
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        return view
        
    }()
    
    let imageView : UIImageView = {
       
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.isUserInteractionEnabled = true
        
        return imageView
        
    }()
    
    let audioLengthLabel : UILabel = {
        
        let label = UILabel()
        
        label.text = "00:00"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .white
        
        label.font = UIFont.boldSystemFont(ofSize: 13)
        
        label.textAlignment = .right
        
        return label
    }()
    
    let currentTimeLabel : UILabel = {
        
        let label = UILabel()
        
        label.text = "00:00"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .white
        
        label.font = UIFont.boldSystemFont(ofSize: 13)
        
        label.textAlignment = .right
        
        return label
    }()
    
    let audioSlider : UISlider = {
        
        let slider = UISlider()
        
        slider.isUserInteractionEnabled = false
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        slider.minimumTrackTintColor = .white
        
        slider.maximumTrackTintColor = .gray
        
        slider.addTarget(self, action: #selector(MeditationViewController.handleSliderChange), for: .valueChanged)
        
        return slider
        
    }()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupView()
        
        setupGradientLayer()
        
        setupNavBar()

    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
        player?.removeObserver(self, forKeyPath: "currentItem.loadedTimeRanges")
        
    }

}

extension MeditationViewController {
    
    func setupNavBar() {
        
        let navBar = self.navigationController?.navigationBar
            
        navBar?.setBackgroundImage(UIImage(), for: .default)
        
        navBar?.shadowImage = UIImage()
        
        navBar?.tintColor = UIColor.white
        
        let buttonItem = UIBarButtonItem.menuButton(self, action: #selector(MeditationViewController.handleClose), imageName: "minimize")
    
        buttonItem.tintColor = .white
        
        navigationItem.rightBarButtonItem = buttonItem
        
                
    }
    
    func setupGradientLayer() {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = containerView.bounds
        
        gradientLayer.colors = [UIColor.clear, UIColor.black]
        
        gradientLayer.locations = [0.7, 1.2]
        
        containerView.layer.addSublayer(gradientLayer)
        
    }
    func setupView() {
        
        view.addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        imageView.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: imageView.leftAnchor).isActive = true
        
        containerView.rightAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true
        
        containerView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        
        containerView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        
        containerView.addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        activityIndicatorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        containerView.addSubview(pausePlayButton)
        
        pausePlayButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        pausePlayButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        pausePlayButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        pausePlayButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        containerView.addSubview(audioLengthLabel)
        
        audioLengthLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant : -20).isActive = true
        
        audioLengthLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant : -50).isActive = true
        
        audioLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        audioLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        containerView.addSubview(audioSlider)
        
        containerView.addSubview(currentTimeLabel)
        
        audioSlider.rightAnchor.constraint(equalTo: audioLengthLabel.leftAnchor).isActive = true
        
        audioSlider.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant : -50).isActive = true
    
        audioSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor, constant : 10).isActive = true
        
        audioSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        currentTimeLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        
        currentTimeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant : -50).isActive = true
        
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
    
        
    }
    
    func setupAudioPlayerAndPlay() {
        
        guard let audioURL = URL(string: meditaion.session.link) else { return }
        
        playerItem = AVPlayerItem(url: audioURL)
        
        player = AVPlayer(playerItem: playerItem)
        
        player.play()
        
        player.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MeditationViewController.handlePlayerEnd),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
        
        let interval = CMTime(value: 1, timescale: 2)
        
        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] (progrssTime) in
            
            let seconds = CMTimeGetSeconds(progrssTime)
            
            let secondsString = String(format: "%02d", Int(seconds) % 60)
            
            let minutesString = String(format : "%02d", Int(seconds) / 60)
            
            self?.currentTimeLabel.text = "\(minutesString):\(secondsString)"
            
            if let duration = self?.player.currentItem?.duration {
                
                let durationSeconds = CMTimeGetSeconds(duration)
            
                self?.audioSlider.value = Float(seconds / durationSeconds)
                
            }
        }
        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "currentItem.loadedTimeRanges" {
            
            activityIndicatorView.stopAnimating()
            
            pausePlayButton.isHidden = false
            
            audioSlider.isUserInteractionEnabled = true
            
            isPlaying = true
            
            if let duration = player.currentItem?.duration {
                
                let seconds = CMTimeGetSeconds(duration)
                
                let secondsText = Int(seconds) % 60
                
                let minuteText = String(format: "%02d", Int(seconds) / 60)
                
                audioLengthLabel.text = "\(minuteText):\(secondsText)"
            }
            
        }
    }
    
    func setupImage() {
        
        guard let imageURL = URL(string: meditaion.session.imageLink) else { return }
        
        imageView.kf.setImage(with: imageURL)
        
    }
    
    
    @objc func handleSliderChange() {
    
        if let duration = player.currentItem?.duration {
            
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(audioSlider.value) * totalSeconds
            
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            player.seek(to: seekTime) { (completedSeek) in
                
                print("CS",completedSeek)
                

                if self.isPlaying && completedSeek {

                    self.player.play()
                }
            }
            
        }
        
    }
    
    @objc func handlePause() {
        
        print("HANDLE PAUSE")
        
        if isRestart {
            
            player.seek(to: .zero)
            
            player.play()
            
            audioSlider.minimumValue = 0
            
            isRestart = false
            
            print("res calu")
            
        }
        
        if isPlaying {
        
            player.pause()
            
            pausePlayButton .setImage(UIImage(named: "play"), for: .normal)
            
        } else {
            
            player.play()
            
            pausePlayButton .setImage(UIImage(named: "pause"), for: .normal)
        }
        
        isPlaying = !isPlaying
        
    
    }
    
    
    @objc func handlePlayerEnd() {
        
        pausePlayButton.setImage(UIImage(named: "restart"), for: .normal)
            
        isPlaying = false
        
        isRestart = true
    }

    @objc func handleClose() {
        
        dismiss(animated: true, completion: nil)
    }
    

}
