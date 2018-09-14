//
//  CameraViewController.swift
//  FunSnap
//
//  Created by Bruce Bookman on 9/7/18.
//  Copyright © 2018 Bruce Bookman. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SCSDKCreativeKit
import SCSDKBitmojiKit



class CameraViewController: UIViewController {
    
    var bitmojiSelectionView: UIView?

    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    

    @IBAction func didTapBitmoji(_ sender: UIButton) {
        let viewHeight: CGFloat = 300
        let screen: CGRect = UIScreen.main.bounds
        let bitmojiView = UIView(frame: CGRect(x: 0, y: screen.height - viewHeight, width: screen.width, height: viewHeight))
        self.view.addSubview(bitmojiView)
        bitmojiSelectionView = bitmojiView
        
        let stickerPickerVC = SCSDKBitmojiStickerPickerViewController()
        stickerPickerVC.delegate = self
        addChildViewController(stickerPickerVC)
        bitmojiView.addSubview(stickerPickerVC.view)
        stickerPickerVC.didMove(toParentViewController: self)
        
    }
    
    @IBAction func didTapCreative(_ sender: UIButton) {
        let snapImage = sceneView.snapshot()
        let photo = SCSDKSnapPhoto(image: snapImage)
        let photoContent = SCSDKPhotoSnapContent(snapPhoto: photo)
        
        let stickerImage = #imageLiteral(resourceName: "smiles")
        let sticker = SCSDKSnapSticker(stickerImage: stickerImage)

        photoContent.sticker = sticker /* Optional */
        photoContent.caption = "Snap on Snapchat!" /* Optional */
        photoContent.attachmentUrl = "https://www.snapchat.com" /* Optional */
        
        let api = SCSDKSnapAPI(content: photoContent)
        api.startSnapping { (error) in
            if let error = error {
                print("ERROR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   ", error.localizedDescription)
            }
        }
        
    }
    
    func createPhotoNode(_ image: UIImage, position: SCNVector3) -> SCNNode {
        let node = SCNNode()
        let scale: CGFloat = 0.3
        let geometry = SCNPlane(width: image.size.width * scale / image.size.height,
                                height: scale)
        geometry.firstMaterial?.diffuse.contents = image
        node.geometry = geometry
        node.position = position
        return node
    }
    
    func setImageToScene(image: UIImage) {
        if let camera = sceneView.pointOfView {
            let position = SCNVector3(x: 0, y: 0, z: -0.5)
            let convertedPosition = camera.convertPosition(position, to: nil)
            let node = createPhotoNode(image, position: convertedPosition) 
            self.sceneView.scene.rootNode.addChildNode(node)
        }
    }
}



extension CameraViewController: SCSDKBitmojiStickerPickerViewControllerDelegate {
    func bitmojiStickerPickerViewController(_ stickerPickerViewController: SCSDKBitmojiStickerPickerViewController, didSelectBitmojiWithURL bitmojiURL: String) {
        
        bitmojiSelectionView?.removeFromSuperview()
        if let image = UIImage.load(from: bitmojiURL) { 
            DispatchQueue.main.async {
                 self.setImageToScene(image:  image)
            }
            
        }
        
    }
    
    
    
}
