module Erp::Tours
  class TourMailer < Erp::ApplicationMailer
    helper Erp::ApplicationHelper
    
    def sending_admin_email_tour_confirmation(tour_booking)
      @recipients = ['Sơn Nguyễn <sonnn@hoangkhang.com.vn>']
      
      @tour_booking = tour_booking
      send_email(@recipients.join("; "), "[ThichLaDi.Info] -#{Time.current.strftime('%Y%m%d')}- ĐẶT TOUR TỪ WEBSITE THICHLADI.INFO")
    end
    
    def sending_customer_email_tour_confirmation(tour_booking)
      @tour_bookingr = tour_booking
      send_email(@tour_booking.customer_email, "#{Time.current.strftime('%Y%m%d')} - XÁC NHẬN ĐẶT TOUR TỪ WEBSITE THICHLADI.INFO")
    end
  end
end
