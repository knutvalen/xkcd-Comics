import Foundation
import Reachability

final class ReachabilityService {
	private var reachability: Reachability?
	
	func configure(delegate: ReachabilityActionDelegate) throws {
		let reachability = try Reachability()
		
		self.reachability = reachability
		
		reachability.whenReachable = { reachability in
			delegate.reachabilityChanged(true)
		}
		
		reachability.whenUnreachable = { reachability in
			delegate.reachabilityChanged(false)
		}
		
		try reachability.startNotifier()
	}
	
	deinit {
		reachability?.stopNotifier()
		reachability = nil
	}
	
}
