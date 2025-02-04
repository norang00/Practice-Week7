//
//  ViewController.swift
//  Week7
//
//  Created by Kyuhee hong on 2/3/25.
//

import UIKit
import CoreLocation
import SnapKit
import MapKit

class ViewController: UIViewController {
    
    //1. 위치 매니저 생성: 위치에 관련된 대부분을 담당
    // -> 대부분의 프레임워크에 이런 식으로 매니저가 마련되어 있다. 프로토콜과 함께 동작한다.
    lazy var locationManager = CLLocationManager()
    
    let locationButton = UIButton()
    let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //3. 위치 프로토콜 연결
        locationManager.delegate = self
        // checkDeviceLocation()
        
        // View
        configureView()
        
        // Completion Handler 통합 연습
        NetworkManager.shared.getLotto2 { lotto, error in
            
            //1. 둘 다 조건을 만족해야 하는데 돌아오는 값의 한 쪽은 어쨌든 nil일 테니 결국 return 될 듯
            // => early exit 이 되어버린다! 성공케이스가 존재하지 않음
            guard let lotto1 = lotto,
                  let error1 = error else {
                return
            }
            
            //2. 먼저 쓰인 가드문에서 return 되면 나중 가드문인 error 는 안타게 된다
            guard let lotto2 = lotto else {
                return
            }
            guard let error2 = error else {
                return
            }
            // => Optional 지정 자체는 나쁘지 않은데 guard 문으로 해결 할 때 이런 부분을 잘 고려해주어야 한다
        }
        
        NetworkManager.shared.getLotto3 { response in
            switch response {
            case .success(let success):
                print(success)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func configureView() {
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        
        view.backgroundColor = .white
        locationButton.backgroundColor = .red
        view.addSubview(locationButton)
        locationButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        locationButton.addTarget(self, action: #selector(locationButtonClicked), for: .touchUpInside)
    }
    
    @objc
    func locationButtonClicked() {
        print(#function)
        
        // 어디에서 권한이 어떻게 바뀔지 모르기 때문에 이 시점부터 다시 다 타야 한다.
        
        checkDeviceLocation()
        
    }
    
    
    //Alert: 아이폰의 위치 서비스가 켜져 있는지 확인 후, 권한 요청을 위한 허용 Alert 을 보낸다
    func checkDeviceLocation() {
        print(Thread.isMainThread)
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                // 현재 사용자 위치 권한 상태 확인
                // if 허용된 상태 > 권한 띄울 필요 X
                // if 거부된 상태 > 아이폰 설정화면으로 이동
                // if notDetermined > 권한 띄워주기
                print(#function, self.locationManager.authorizationStatus.rawValue)
                self.checkCurrentLocation()
                
                DispatchQueue.main.async {
                    self.navigationItem.title = "wow"
                }
                
                
                
            } else {
                DispatchQueue.main.async {
                    print("위치 서비스가 꺼져 있어서, 위치 권한 요청을 할 수 없습니다.")
                }
            }
        }
    }
    
    func checkCurrentLocation() {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            print("이 상태에서만 권한 문구를 띄울 수 있음")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // 위치 서비스 관련 Alert를 띄워준다.
            // Info.plist 의 권한과 동일해야 한다.
            //            self.locationManager.requestWhenInUseAuthorization()
            
            locationManager.requestWhenInUseAuthorization()
            // locationManager.requestAlwaysAuthorization()
            
            
//        case .restricted: -> GPS 가 없는 기기 이거나, 자녀 보호 기능 등
//            print("")
            
        case .denied:
            print("거부한 상태이기 때문에, 설정으로 이동하는 Alert 를 띄워준다")
            
        case .authorizedAlways:
            print("always")
            
        case .authorizedWhenInUse:
            print("정상 로직 실행할 수 있다.")
            // 정상 로직 실행이 가능한 시점에 위치 정보 가져오는 것을 시작한다.
            locationManager.startUpdatingLocation()
            
//        case .authorized: -> deprecated
//            print("")
            
        default:
            print("오류 발생")
        }
    }
    
    func setRegionAndAnnotation(_ coordinate: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        
        mapView.setRegion(region, animated: false)
    }
    
}

//2. 위치 프로토콜 선언
extension ViewController: CLLocationManagerDelegate {
    
    // 사용자의 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        print(locations)
        print(locations.last?.coordinate)
        
        if let coordinate = locations.last?.coordinate {
            setRegionAndAnnotation(coordinate)
        }
        
        // 위도, 경도를 받아서 하고 싶은 기능들을 여기서 호출할 수 있다.
        // 날씨 정보를 호출하는 API 를 여기서 사용하거나
        // 지도를 현재 위치의 중심으로 이동시키는 기능이라거나
        
        // 실시간 위치가 더이상 필요하지 않은 시점에는 stop 을 해주어야 한다.
        locationManager.stopUpdatingLocation()
    }
    
    // 사용자의 위치를 가지고 오는 데 실패한 경우
    // ex. 기기 자체 위치 서비스가 꺼져있을 때 / 사용자가 위치 정보 공유를 허용하지 않았을 때 / 자녀 보호 기능 등
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(#function)
        
    }
    
    // 사용자의 권한상태가 변경될 때
    // ex. 허용했었지만 시스템에서 안함으로 바꾸는 경우 등
    
    // iOS14+
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkCurrentLocation()
    }
    
    // iOS14-
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
        checkCurrentLocation()
    }
}
