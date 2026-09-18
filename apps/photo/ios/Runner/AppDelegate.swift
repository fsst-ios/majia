import Flutter
import Photos
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(name: "jufu/photos", binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler { [weak self] call, result in
        guard call.method == "saveImage",
              let arguments = call.arguments as? [String: Any],
              let typedData = arguments["bytes"] as? FlutterStandardTypedData else {
          result(FlutterMethodNotImplemented)
          return
        }
        self?.saveToPhotoLibrary(typedData.data, result: result)
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func saveToPhotoLibrary(_ data: Data, result: @escaping FlutterResult) {
    guard let image = UIImage(data: data) else {
      result(FlutterError(code: "invalid_image", message: "The generated image could not be read.", details: nil))
      return
    }
    let save: () -> Void = {
      PHPhotoLibrary.shared().performChanges({
        PHAssetChangeRequest.creationRequestForAsset(from: image)
      }) { success, error in
        DispatchQueue.main.async {
          success ? result(true) : result(FlutterError(code: "save_failed", message: error?.localizedDescription ?? "Could not save the photo.", details: nil))
        }
      }
    }
    if #available(iOS 14, *) {
      PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
        guard status == .authorized || status == .limited else {
          result(FlutterError(code: "photo_permission_denied", message: "Photo Library access is required to save the edited image.", details: nil))
          return
        }
        save()
      }
    } else {
      PHPhotoLibrary.requestAuthorization { status in
        guard status == .authorized else {
          result(FlutterError(code: "photo_permission_denied", message: "Photo Library access is required to save the edited image.", details: nil))
          return
        }
        save()
      }
    }
  }
}
