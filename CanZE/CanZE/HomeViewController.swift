//
//  HomeViewController.swift
//  CanZE
//
//  Created by Roberto Sonzogni on 17/12/20.
//

import Toast_Swift
import UIKit

class HomeViewController: CanZeViewController {
    @IBOutlet var btnConsumption: ButtonWithImage!
    @IBOutlet var btnBattery: ButtonWithImage!
    @IBOutlet var btnClimate: ButtonWithImage!
    @IBOutlet var btnCharging: ButtonWithImage!
    @IBOutlet var btnDriving: ButtonWithImage!
    @IBOutlet var btnBraking: ButtonWithImage!
    @IBOutlet var btnAvgSpeed: ButtonWithImage!
    @IBOutlet var lblNews: UILabel!
    @IBOutlet var lblMain: UILabel!

    @IBOutlet var btnChargingTech: ButtonWithImage!
    @IBOutlet var btnChargingGraph: ButtonWithImage!
    @IBOutlet var btnFirmware: ButtonWithImage!
    @IBOutlet var btnAllData: ButtonWithImage!
    @IBOutlet var btnVoltageHeatmap: ButtonWithImage!
    @IBOutlet var btnTemperatureHeatmap: ButtonWithImage!
    @IBOutlet var btnDtcReadout: ButtonWithImage!
    @IBOutlet var btnChargingPrediction: ButtonWithImage!
    @IBOutlet var btnElmTesting: ButtonWithImage!
    @IBOutlet var btnChargingHistory: ButtonWithImage!
    @IBOutlet var btn12VBattery: ButtonWithImage!
    @IBOutlet var btnRange: ButtonWithImage!
    @IBOutlet var btnLeakCurrents: ButtonWithImage!
    @IBOutlet var btnTires: ButtonWithImage!

    @IBOutlet var pg: UIPageControl!
    @IBOutlet var sv: UIScrollView!
    @IBOutlet var cv: UIView!

    var firstRun = true
    var msg = ""
    var isHtml = false

//    var last = "button_bluetooth_connected"
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var max: CGFloat = 0.0
        for v in cv.subviews {
            for vv in v.subviews {
                if vv.frame.origin.y + vv.frame.size.height > max {
                    max = vv.frame.origin.y + vv.frame.size.height
                }
            }
        }

        var f = cv.frame
        f.size.height = max //+ 20
        cv.frame = f

        sv.contentSize = cv.frame.size
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        navigationController?.navigationBar.barTintColor = UIColor(white: 0.95, alpha: 1)

        sv.delegate = self

//         if navigationItem.rightBarButtonItems != nil && navigationItem.rightBarButtonItems!.count > 1 {
//             for b in navigationItem.rightBarButtonItems! {
//                b.tintColor = .orange
//             }
//         } else if navigationItem.rightBarButtonItem != nil {
//        navigationItem.rightBarButtonItem!.tintColor = .green
//         }

        /*
                 let b = navigationItem.rightBarButtonItems?.last
                 b!.tintColor = .blue

                 Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { _ in
                     let b = self.navigationItem.rightBarButtonItems?.last
                     var n = ""
                     if self.last == "button_bluetooth_disconnected" {
                         n = "button_bluetooth_searching_1"
         //                b!.tintColor = .blue
                     } else if self.last == "button_bluetooth_searching_1" {
                         n = "button_bluetooth_searching_2"
         //                b!.tintColor = .blue
                     } else if self.last == "button_bluetooth_searching_2" {
                         n = "button_bluetooth_searching_3"
         //                b!.tintColor = .blue
                     } else {
                         n = "button_bluetooth_disconnected"
         //                b!.tintColor = UIColor(white: 0.0, alpha: 0.4)
         //                b!.tintColor = .blue
                     }
                     self.last = n
                     print(n)
                     b?.image = UIImage(named: n)
                 }
                  */

        // icona
        let v = UIImageView(image: UIImage(named: "CanZEiconSmall.jpg"))
        let item1 = UIBarButtonItem(customView: v)
        // print(item1.customView?.frame)  // 0,0,55.66,55.66  (167x132)

        // nome app
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.text = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
        let item2 = UIBarButtonItem(customView: label)

        // mostra su nav bar
        let items = Array(arrayLiteral: item1, item2)
        navigationItem.leftBarButtonItems = items

        btnConsumption.setTitle(NSLocalizedString("button_Consumption", comment: "").uppercased(), for: .normal)
        btnConsumption.setImage(#imageLiteral(resourceName: "button_consumption"), for: .normal)
        btnBattery.setTitle(NSLocalizedString("button_Battery", comment: "").uppercased(), for: .normal)
        btnBattery.setImage(#imageLiteral(resourceName: "button_battery"), for: .normal)
        btnClimate.setTitle(NSLocalizedString("button_Climate", comment: "").uppercased(), for: .normal)
        btnClimate.setImage(#imageLiteral(resourceName: "button_climate"), for: .normal)
        btnCharging.setTitle(NSLocalizedString("button_Charging", comment: "").uppercased(), for: .normal)
        btnCharging.setImage(#imageLiteral(resourceName: "button_charge"), for: .normal)
        btnDriving.setTitle(NSLocalizedString("button_Driving", comment: "").uppercased(), for: .normal)
        btnDriving.setImage(#imageLiteral(resourceName: "button_drive"), for: .normal)
        btnBraking.setTitle(NSLocalizedString("button_Braking", comment: "").uppercased(), for: .normal)
        btnBraking.setImage(#imageLiteral(resourceName: "button_brake"), for: .normal)
        btnAvgSpeed.setTitle(NSLocalizedString("button_speedcontrol", comment: "").uppercased(), for: .normal)
        btnAvgSpeed.setImage(#imageLiteral(resourceName: "button_speedcam"), for: .normal)

        lblNews.text = ""
        lblMain.text = NSLocalizedString("help_Main", comment: "")

        getNews()

        loadSettings()

        btnChargingTech.setTitle(NSLocalizedString("button_Charging", comment: "").uppercased(), for: .normal)
        btnChargingTech.setImage(#imageLiteral(resourceName: "button_charge"), for: .normal)
        btnChargingGraph.setTitle(NSLocalizedString("button_ChargingGraphs", comment: "").uppercased(), for: .normal)
        btnChargingGraph.setImage(#imageLiteral(resourceName: "button_charging_graphs"), for: .normal)
        btnFirmware.setTitle(NSLocalizedString("button_Firmware", comment: "").uppercased(), for: .normal)
        btnFirmware.setImage(#imageLiteral(resourceName: "button_firmware"), for: .normal)
        btnAllData.setTitle(NSLocalizedString("button_alldata", comment: "").uppercased(), for: .normal)
        btnAllData.setImage(#imageLiteral(resourceName: "button_alldata"), for: .normal)
        btnVoltageHeatmap.setTitle(NSLocalizedString("button_HeatmapVoltage", comment: "").uppercased(), for: .normal)
        btnVoltageHeatmap.setImage(#imageLiteral(resourceName: "button_lightning"), for: .normal)
        btnTemperatureHeatmap.setTitle(NSLocalizedString("button_HeatmapTemperature", comment: "").uppercased(), for: .normal)
        btnTemperatureHeatmap.setImage(#imageLiteral(resourceName: "button_batterytemp"), for: .normal)
        btnDtcReadout.setTitle(NSLocalizedString("button_DtcReadout", comment: "").uppercased(), for: .normal)
        btnDtcReadout.setImage(#imageLiteral(resourceName: "button_attention"), for: .normal)
        btnChargingPrediction.setTitle(NSLocalizedString("button_ChargingPrediction", comment: "").uppercased(), for: .normal)
        btnChargingPrediction.setImage(#imageLiteral(resourceName: "button_prediction"), for: .normal)
        btnElmTesting.setTitle(NSLocalizedString("button_ElmTesting", comment: "").uppercased(), for: .normal)
        btnElmTesting.setImage(#imageLiteral(resourceName: "button_elm327"), for: .normal)
        btnChargingHistory.setTitle(NSLocalizedString("button_chargingHistory", comment: "").uppercased(), for: .normal)
        btnChargingHistory.setImage(#imageLiteral(resourceName: "button_charginghist"), for: .normal)
        btn12VBattery.setTitle(NSLocalizedString("button_AuxBatt", comment: "").uppercased(), for: .normal)
        btn12VBattery.setImage(#imageLiteral(resourceName: "button_auxbat"), for: .normal)
        btnRange.setTitle(NSLocalizedString("button_Range", comment: "").uppercased(), for: .normal)
        btnRange.setImage(#imageLiteral(resourceName: "button_range"), for: .normal)
        btnLeakCurrents.setTitle(NSLocalizedString("button_LeakCurrents", comment: "").uppercased(), for: .normal)
        btnLeakCurrents.setImage(#imageLiteral(resourceName: "button_leak"), for: .normal)
        btnTires.setTitle(NSLocalizedString("button_Tires", comment: "").uppercased(), for: .normal)
        btnTires.setImage(#imageLiteral(resourceName: "button_tire"), for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if Utils.isPh2() {
            btnTires.alpha = 0
            btnTires.isEnabled = false
        } else {
            btnTires.alpha = 1
            btnTires.isEnabled = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !ud.bool(forKey: "disclaimer") {
            performSegue(withIdentifier: "disclaimer", sender: nil)
        } else if deviceIsConnectable() {
            // connect()
        } else {
            view.makeToast(NSLocalizedString("toast_AdjustSettings", comment: ""))
        }
    }

    func getNews() {
        if firstRun {
            var request = URLRequest(url: URL(string: "https://raw.githubusercontent.com/fesch/CanZE/Development/NEWS.json")!, timeoutInterval: 5)
            request.httpMethod = "GET"

            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                //              print(String(data: data, encoding: .utf8)!)

                // app version check ?

                let decoder = JSONDecoder()
                do {
                    let newsData = try decoder.decode(AnyDecodable.self, from: data).value as! [String: Any]

                    if let newsText = newsData["news"] as? String {
                        if newsText.contains("<") {
                            self.isHtml = true
                        }
                        DispatchQueue.main.async {
                            if self.isHtml {
                                self.lblNews.attributedText = newsText.htmlToAttributedString
                            } else {
                                self.lblNews.text = newsText
                            }
                        }
                        self.firstRun = false
                    }

                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.lblNews.text = "error"
                    }
                }
            }

            task.resume()
        }
    }

    @IBAction func pg(sender: UIPageControl) {
        let r = CGRect(x: sv.frame.size.width * CGFloat(sender.currentPage), y: 0, width: sv.frame.size.width, height: 1)
        sv.scrollRectToVisible(r, animated: true)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = sv.contentOffset
        let pageNum = offset.x / sv.frame.size.width
        pg.currentPage = Int(pageNum)

        switch pg.currentPage {
        case 0:
            // icona
            var items = navigationItem.leftBarButtonItems
            let item2 = items!.last
            let v = UIImageView(image: UIImage(named: "CanZEiconSmall.jpg"))
            let item1 = UIBarButtonItem(customView: v)
            items = Array(arrayLiteral: item1, item2!)
            navigationItem.leftBarButtonItems = items
        case 1:
            // icona
            var items = navigationItem.leftBarButtonItems
            let item2 = items!.last
            let v = UIImageView(image: UIImage(named: "fragment_technical"))
            let item1 = UIBarButtonItem(customView: v)
            items = Array(arrayLiteral: item1, item2!)
            navigationItem.leftBarButtonItems = items
        case 2:
            // icona
            var items = navigationItem.leftBarButtonItems
            let item2 = items!.last
            let v = UIImageView(image: UIImage(named: "fragment_experimental"))
            let item1 = UIBarButtonItem(customView: v)
            items = Array(arrayLiteral: item1, item2!)
            navigationItem.leftBarButtonItems = items
        default:
            print("pg.currentPage out of range")
        }
    }
}
