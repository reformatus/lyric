import Cocoa
import FlutterMacOS

// DEEP LINKING
import app_links



@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  //! DEEP LINKING
  public override func application(_ application: NSApplication,
                                  continue userActivity: NSUserActivity,
                                  restorationHandler: @escaping ([any  NSUserActivityRestoring]) -> Void) -> Bool {

    guard let url = AppLinks.shared.getUniversalLink(userActivity) else {
      return false
    }
    
    AppLinks.shared.handleLink(link: url.absoluteString)
    
    return false // Returning true will stop the propagation to other packages
  }
  // /DEEP LINKING
}
