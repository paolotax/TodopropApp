class OpzioniController < UIViewController
  extend IB

  attr_accessor :data_source


  ## ib outlets
  outlet :scroller, UIScrollView
  outlet :btn_kill
  outlet :label_username


  def kill_app(sender)
    App.reset
  end


end