package dev.pam.payments
import android.content.Context
import android.view.View
import android.widget.FrameLayout
import androidx.activity.ComponentActivity
import com.stripe.android.PaymentConfiguration
import com.stripe.android.paymentsheet.PaymentSheet
import com.stripe.android.paymentsheet.PaymentSheetResult
import dev.pam.nativeapp.protocol.WireMap
import dev.pam.nativeapp.protocol.WireValue
import dev.pam.nativeapp.views.NativeViewFactory
class PaymentSheetFactory(private val applicationContext:Context):NativeViewFactory{
 override fun create(context:Context,emit:(ByteArray)->Unit):View=PaymentHost(context,emit)
 override fun update(view:View,properties:Map<String,WireValue>)=(view as PaymentHost).update(properties)
 override fun release(view:View)=(view as PaymentHost).release()
 private class PaymentHost(context:Context,private val emit:(ByteArray)->Unit):FrameLayout(context){private var request="";private val activity=context as? ComponentActivity;private val sheet:PaymentSheet?=activity?.let{PaymentSheet.Builder{result:PaymentSheetResult->finish(result)}.build(it)}
  fun update(v:Map<String,WireValue>){val next=v.text("requestId");if(next==request)return;request=next;val a=activity;val s=sheet;if(a==null||s==null){send(3,"PaymentSheet requires an Activity context.");return};val key=v.text("publishableKey");val secret=v.text("clientSecret");val merchant=v.text("merchant");try{PaymentConfiguration.init(a,key);val configuration=PaymentSheet.Configuration.Builder(merchant).build();if(secret.startsWith("seti_"))s.presentWithSetupIntent(secret,configuration)else s.presentWithPaymentIntent(secret,configuration)}catch(e:Exception){send(3,e.message.orEmpty())}}
  private fun finish(result:PaymentSheetResult)=when(result){is PaymentSheetResult.Completed->send(1,"");is PaymentSheetResult.Canceled->send(2,"");is PaymentSheetResult.Failed->send(3,result.error.message.orEmpty())};private fun send(result:Long,message:String)=emit(WireMap.encode(mapOf("result" to WireValue.Integer(result),"message" to WireValue.Text(message.take(1024)))));fun release(){};private fun Map<String,WireValue>.text(k:String)=(get(k)as?WireValue.Text)?.value.orEmpty()}
}
