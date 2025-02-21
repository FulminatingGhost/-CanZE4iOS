//
//  BrakingViewController.swift
//  CanZE
//
//  Created by Roberto Sonzogni on 09/02/21.
//

import Charts
import UIKit

class BrakingViewController: CanZeViewController {
    @IBOutlet var lblDebug: UILabel!

    //

    @IBOutlet var label_driver_torque_request: UILabel!
    @IBOutlet var text_driver_torque_request: UILabel!
    @IBOutlet var pb_driver_torque_request: UIProgressView!
    @IBOutlet var MaxBrakeTorque: UIProgressView!

    @IBOutlet var label_ElecBrakeWheelsTorqueApplied: UILabel!
    @IBOutlet var text_ElecBrakeWheelsTorqueApplied: UILabel!
    @IBOutlet var pb_ElecBrakeWheelsTorqueApplied: UIProgressView!

    @IBOutlet var label_diff_friction_torque: UILabel!
    @IBOutlet var text_diff_friction_torque: UILabel!
    @IBOutlet var pb_diff_friction_torque: UIProgressView!

    @IBOutlet var help_AllTorques: UILabel!

    var frictionTorque = 0.0
    var elecBrakeTorque = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = NSLocalizedString("title_activity_braking", comment: "")
        lblDebug.text = ""
        NotificationCenter.default.addObserver(self, selector: #selector(updateDebugLabel(notification:)), name: Notification.Name("updateDebugLabel"), object: nil)

        ///

        label_driver_torque_request.text = NSLocalizedString("label_driver_torque_request", comment: "")
        text_driver_torque_request.text = "-"

        label_ElecBrakeWheelsTorqueApplied.text = NSLocalizedString("label_ElecBrakeWheelsTorqueApplied", comment: "")
        text_ElecBrakeWheelsTorqueApplied.text = "-"

        label_diff_friction_torque.text = NSLocalizedString("label_diff_friction_torque", comment: "")
        text_diff_friction_torque.text = "-"

        help_AllTorques.text = NSLocalizedString("help_AllTorques", comment: "")

        // init progressview
        pb_driver_torque_request.trackImage = UIImage(view: GradientView(frame: pb_driver_torque_request.bounds)).withHorizontallyFlippedOrientation()
        pb_driver_torque_request.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
        pb_driver_torque_request.progressTintColor = view.backgroundColor
        pb_driver_torque_request.setProgress(1, animated: false)

        MaxBrakeTorque.trackImage = UIImage(view: GradientViewDecelAimRight(frame: MaxBrakeTorque.bounds)).withHorizontallyFlippedOrientation()
        MaxBrakeTorque.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
        MaxBrakeTorque.progressTintColor = view.backgroundColor
        MaxBrakeTorque.setProgress(1, animated: false)

        pb_ElecBrakeWheelsTorqueApplied.trackImage = UIImage(view: GradientViewAccel(frame: pb_ElecBrakeWheelsTorqueApplied.bounds)).withHorizontallyFlippedOrientation()
        pb_ElecBrakeWheelsTorqueApplied.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
        pb_ElecBrakeWheelsTorqueApplied.progressTintColor = view.backgroundColor
        pb_ElecBrakeWheelsTorqueApplied.setProgress(1, animated: false)

        pb_diff_friction_torque.trackImage = UIImage(view: GradientViewAccel(frame: pb_diff_friction_torque.bounds)).withHorizontallyFlippedOrientation()
        pb_diff_friction_torque.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
        pb_diff_friction_torque.progressTintColor = view.backgroundColor
        pb_diff_friction_torque.setProgress(1, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(decoded(notification:)), name: Notification.Name("decoded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endQueue2), name: Notification.Name("endQueue2"), object: nil)

        startQueue()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("decoded"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("received2"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("updateDebugLabel"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("endQueue2"), object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    @objc func updateDebugLabel(notification: Notification) {
        let dic = notification.object as? [String: String]
        DispatchQueue.main.async {
            self.lblDebug.text = dic?["debug"]
        }
        debug((dic?["debug"])!)
    }

    func startQueue() {
        if !Globals.shared.deviceIsConnected || !Globals.shared.deviceIsInitialized {
            DispatchQueue.main.async {
                self.view.makeToast("_device not connected")
            }
            return
        }

        queue2 = []

        addField(Sid.TotalPotentialResistiveWheelsTorque, intervalMs: 0)
        addField(Sid.FrictionTorque, intervalMs: 0)
        addField(Sid.ElecBrakeTorque, intervalMs: 0)

        startQueue2()
    }

    @objc func endQueue2() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.startQueue()
        }
    }

    @objc func decoded(notification: Notification) {
        let obj = notification.object as! [String: String]
        let sid = obj["sid"]

        let val = Globals.shared.fieldResultsDouble[sid!]
        if val != nil && !val!.isNaN {
            DispatchQueue.main.async {
                switch sid {
                case Sid.TotalPotentialResistiveWheelsTorque: // bluebar
                    let tprwt = -val!
                    let progress = Float(tprwt < 2047 ? tprwt : 20 / 2048.0)
                    self.MaxBrakeTorque.setProgress(1 - progress, animated: false)
                case Sid.FrictionTorque:
                    self.frictionTorque = val!

                    var progress = Float(val!) / 2048.0
                    self.pb_diff_friction_torque.setProgress(1 - progress, animated: false)
                    let um = NSLocalizedString("unit_Nm", comment: "")
                    self.text_diff_friction_torque.text = String(format: "%.0f \(um)", val!)

                    progress = Float((self.frictionTorque + self.elecBrakeTorque) / 2048.0)
                    self.pb_driver_torque_request.setProgress(1 - progress, animated: false)
                    self.text_driver_torque_request.text = String(format: "%.0f \(um)", self.frictionTorque + self.elecBrakeTorque)
                case Sid.ElecBrakeTorque:
                    self.elecBrakeTorque = val!

                    var progress = Float(val!) / 2048.0
                    self.pb_ElecBrakeWheelsTorqueApplied.setProgress(1 - progress, animated: false)
                    let um = NSLocalizedString("unit_Nm", comment: "")
                    self.text_ElecBrakeWheelsTorqueApplied.text = String(format: "%.0f \(um)", val!)

                    progress = Float((self.frictionTorque + self.elecBrakeTorque) / 2048.0)
                    self.pb_driver_torque_request.setProgress(1 - progress, animated: false)
                    self.text_driver_torque_request.text = String(format: "%.0f \(um)", self.frictionTorque + self.elecBrakeTorque)
                default:
                    print("unknown sid \(sid!)")
                }
            }
        }
    }
}
