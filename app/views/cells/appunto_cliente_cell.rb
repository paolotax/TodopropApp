class AppuntoClienteCell < UITableViewCell
  
  extend IB

  attr_accessor :appunto

  outlet :labelDestinatario, UILabel # @property IBOutlet UILabel * title;
  outlet :labelNote, UILabel
  outlet :labelTelefono, UILabel
  outlet :labelCreatedAt, UILabel

  def appunto=(appunto)
    @appunto = appunto

    @labelDestinatario.text = self.appunto.destinatario
    @labelNote.text         = self.appunto.note
    @labelTelefono.text     = self.appunto.stato
    #@labelCreatedAt.text    = self.appunto.created_at

    self.setNeedsLayout
    # self.setNeedsDisplay
    # @appunto
  end

  def self.heightForCellWithAppunto(appunto)
    sizeToFit = appunto.note.sizeWithFont(UIFont.systemFontOfSize(12), constrainedToSize: CGSizeMake(200, Float::MAX), lineBreakMode:UILineBreakModeWordWrap)
    
    return [70, sizeToFit.height + 90].max
  end

  def layoutSubviews
    super
    noteFrame = CGRectOffset(@labelDestinatario.frame, 0, 25);
    noteFrame.size.height = self.class.heightForCellWithAppunto(self.appunto) - 90
    @labelNote.frame = noteFrame
    
    puts "layout"

  end

end