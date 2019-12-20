import ObjectiveC.runtime
import UIKit


class ViewDidAppearInjector {

    typealias ViewDidLoadRef = @convention(c)(UIViewController, Selector) -> Void

    private static let selector = #selector(UIViewController.viewDidAppear(_:))

    static func inject(into supportedClasses: [UIViewController.Type], injection: @escaping (UIViewController) -> Void) {
        guard let originalMethod = class_getInstanceMethod(UIViewController.self, selector) else {
            fatalError("\(selector) must be implemented")
        }

        var originalIMP: IMP? = nil

        let swizzledViewDidLoadBlock: @convention(block) (UIViewController) -> Void = { receiver in
            if let originalIMP = originalIMP {
                let castedIMP = unsafeBitCast(originalIMP, to: ViewDidLoadRef.self)
                castedIMP(receiver, selector)
            }

            if ViewDidAppearInjector.canInject(to: receiver, supportedClasses: supportedClasses) {
                injection(receiver)
            }
        }

        let swizzledIMP = imp_implementationWithBlock(unsafeBitCast(swizzledViewDidLoadBlock, to: AnyObject.self))
        originalIMP = method_setImplementation(originalMethod, swizzledIMP)
    }

    private static func canInject(to receiver: Any, supportedClasses: [UIViewController.Type]) -> Bool {
        let supportedClassesIDs = supportedClasses.map { ObjectIdentifier($0) }
        let receiverType = type(of: receiver)
        return supportedClassesIDs.contains(ObjectIdentifier(receiverType))
    }
}
