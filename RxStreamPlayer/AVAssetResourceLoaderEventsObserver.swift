//
//  AVAssetResourceLoaderEventsObserver.swift
//  RxStreamPlayer
//
//  Created by Anton Efimenko on 03.01.17.
//  Copyright © 2017 Anton Efimenko. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift

enum AssetLoadingEvents {
	case shouldWaitForLoading(AVAssetResourceLoadingRequestProtocol)
	case didCancelLoading(AVAssetResourceLoadingRequestProtocol)
	/// this event will send when AVAssetResourceLoaderEventsObserver will deinit
	case observerDeinit
}

protocol AVAssetResourceLoaderEventsObserverProtocol {
	var loaderEvents: Observable<AssetLoadingEvents> { get }
	var shouldWaitForLoading: Bool { get set }
}

@objc final class AVAssetResourceLoaderEventsObserver : NSObject {
	internal let publishSubject = PublishSubject<AssetLoadingEvents>()
	var shouldWaitForLoading: Bool
	
	init(shouldWaitForLoading: Bool = true) {
		self.shouldWaitForLoading = shouldWaitForLoading
	}
	
	deinit {
		publishSubject.onNext(.observerDeinit)
	}
}

extension AVAssetResourceLoaderEventsObserver : AVAssetResourceLoaderEventsObserverProtocol {
	var loaderEvents: Observable<AssetLoadingEvents> {
		return publishSubject
	}
}

extension AVAssetResourceLoaderEventsObserver : AVAssetResourceLoaderDelegate {	
	func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
		publishSubject.onNext(.didCancelLoading(loadingRequest))
	}
	
	func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
		publishSubject.onNext(.shouldWaitForLoading(loadingRequest))
		return shouldWaitForLoading
	}
}
