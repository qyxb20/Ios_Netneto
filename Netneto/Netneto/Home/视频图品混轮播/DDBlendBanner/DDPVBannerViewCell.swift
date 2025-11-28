//
//  DDPVBannerViewCell.swift
//  DDNewThirdDemo
//
//  Created by lll on 2022/1/12.
//

import UIKit
import AVFoundation

@objcMembers
class DDPVBannerViewCell: FSPagerViewCell {
    //自定义FSPagerViewCell
    
    lazy var player = AVPlayer()
    lazy var playerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer(player: player)
        return layer
    }()
    //简单指示器
    lazy var indicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        return activityView
    }()
    lazy var indicatorMaskView: UIView = {
        let mview = UIView()
        mview.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
        return mview
    }()
    
    func removeSomeView() {
        self.textLabel?.removeObserver(self, forKeyPath: "font", context: kvoContext)
        self.textLabel?.removeFromSuperview()
        
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer.frame = self.contentView.bounds
        self.playerLayer.videoGravity = .resize;
    }
    
    func addPlayer() {
        guard self.playerLayer.superlayer == nil else {
            return
        }
        self.contentView.layer.addSublayer(self.playerLayer)
    }
    
    func removePlayer() {
        guard self.playerLayer.superlayer != nil else {
            return
        }
        self.playerLayer.removeFromSuperlayer()
    }
    
    //网络视频
    func playUrl(url : String){
        guard let url = URL(string: url) else {
            return
        }
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        player.play()
    }
    //本地视频
    func playFileVideo(url: String) {
        let r = URL(fileURLWithPath: url)
        let item = AVPlayerItem(url: r)
        player.replaceCurrentItem(with: item)
        player.play()
    }
    
    //停止
    func stop(){
        player.pause()
    }
}

//处理蒙版
extension DDPVBannerViewCell {
    //开始加载
    func showLoad() {
        if let _ = indicatorMaskView.superview {
            indicatorMaskView.removeFromSuperview()
        }
        if let _ = indicatorView.superview {
            indicatorView.removeFromSuperview()
        }
        
        indicatorMaskView.frame = self.bounds
        addSubview(indicatorMaskView)
        
        indicatorView.frame = CGRect(x: (self.bounds.size.width - 30) / 2, y: (self.bounds.size.height - 30) / 2, width: 30, height: 30)
        addSubview(indicatorView)
        
        indicatorView.startAnimating()
    }
    
    func stopLoad() {
        indicatorView.stopAnimating()
        
        indicatorMaskView.removeFromSuperview()
        indicatorView.removeFromSuperview()
    }
}
