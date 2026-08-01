import Foundation
import PamNative
import StripePaymentSheet
import UIKit

public final class PamPaymentSheetFactory: NativeViewFactory, @unchecked Sendable {
    public init() {}
    public func create(context:AnyObject?,emit:@escaping(Data)->Void)->UIView{PaymentHostView(emit:emit)}
    public func update(view:UIView,properties:[String:WireValue]){(view as? PaymentHostView)?.update(properties)}
    public func release(view:UIView){(view as? PaymentHostView)?.releaseSheet()}
}
private final class PaymentHostView:UIView,@unchecked Sendable {
    private let emit:(Data)->Void;private var request="";private var sheet:PaymentSheet?
    init(emit:@escaping(Data)->Void){self.emit=emit;super.init(frame:.zero)};required init?(coder:NSCoder){nil}
    func update(_ values:[String:WireValue]){let next=values.text("requestId");guard next != request else{return};request=next;guard let controller=viewController else{finish(.failed(error:PaymentError.missingController));return};STPAPIClient.shared.publishableKey=values.text("publishableKey");var config=PaymentSheet.Configuration();config.merchantDisplayName=values.text("merchant");let returnURL=values.text("returnUrl");if !returnURL.isEmpty{config.returnURL=returnURL};let secret=values.text("clientSecret");let created=secret.hasPrefix("seti_") ? PaymentSheet(setupIntentClientSecret:secret,configuration:config) : PaymentSheet(paymentIntentClientSecret:secret,configuration:config);sheet=created;created.present(from:controller){[weak self] result in self?.finish(result);self?.sheet=nil}}
    private func finish(_ result:PaymentSheetResult){switch result{case.completed:send(1,"");case.canceled:send(2,"");case.failed(let error):send(3,error.localizedDescription)}}
    private func send(_ result:Int64,_ message:String){if let data=try?WireMap.encode(["result":.integer(result),"message":.text(String(message.prefix(1024)))]){emit(data)}}
    private var viewController:UIViewController?{var responder:UIResponder?=self;while let current=responder{if let controller=current as?UIViewController{return controller};responder=current.next};return nil};func releaseSheet(){sheet=nil}
}
private enum PaymentError:LocalizedError{case missingController;var errorDescription:String?{"PaymentSheet requires a presenting view controller."}}
private extension Dictionary where Key==String,Value==WireValue{func text(_ key:String)->String{if case let.text(value)?=self[key]{return value};return""}}
