import Foundation
import Firebase

class AnalyticsManager {
    static let shared = AnalyticsManager()
    private init() {}
    
    func logScreenView(screenName: String, screenClass: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenClass
        ])
    }
    
    func logAppOpen() {
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
    }
    
    func logButtonClick(buttonName: String, screenName: String) {
        Analytics.logEvent("button_click", parameters: [
            "button_name": buttonName,
            "screen_name": screenName
        ])
    }
    
    func logFeatureUsage(featureName: String) {
        Analytics.logEvent("feature_usage", parameters: [
            "feature_name": featureName
        ])
    }
} 