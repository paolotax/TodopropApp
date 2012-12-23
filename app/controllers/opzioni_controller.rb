class OpzioniController < UIViewController
  extend IB

  attr_accessor :data_source

  ## ib outlets
  outlet :scroller, UIScrollView
  outlet :btn_kill
  outlet :menu_btn
  outlet :label_username

  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.lightTextColor
    label_username.text = "provaci ancora"
  end
  
  def kill_app(sender)
    exit(0)
  end

  def showActionSheet(sender)
    actionSheet = RDActionSheet.alloc.initWithCancelButtonTitle("Annulla",
                                                       primaryButtonTitle:"Salva",
                                                       destroyButtonTitle:"Elimina",
                                                        otherButtonTitles:"Telefona", "Invia email", "Naviga", nil)

    actionSheet.callbackBlock = lambda { |result, buttonIndex|
      
      case result
        when RDActionSheetButtonResultSelected
          puts buttonIndex
        when RDActionSheetResultResultCancelled
          puts buttonIndex
      end  
      
    }
    actionSheet.showFrom self.view;
  end
end