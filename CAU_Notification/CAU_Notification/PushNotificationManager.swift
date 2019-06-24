//
//  PushNotificationManager.swift
//  CAU_Notification
//
//  Created by Tars on 5/22/19.
//  Copyright © 2019 Changsung Lim. All rights reserved.
//

import Firebase
import FirebaseMessaging
import UserNotifications

class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {

    let userID: String
    init(userID: String) {
        self.userID = userID
        super.init()
    }

    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {didAllow, Error in
                // 유저의 Notification 허용 여부에 따라 관련 값들을 수정
                    data_center.notiOnOff = didAllow
                    let ref = Database.database().reference()
                    ref.child("users/\(self.userID)/push_notification").setValue(didAllow)
            })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        updateFirebaseDBPushTokenIfNeeded()
    }

    func updateFirebaseDBPushTokenIfNeeded() {
        let ref = Database.database().reference()
        // Firebase Database에 fcmToken 등록하기
        if let token = Messaging.messaging().fcmToken {
            ref.child("users/\(userID)/fcmToken").setValue(token)
        }
    }

    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        }
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        updateFirebaseDBPushTokenIfNeeded()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
    }
}
