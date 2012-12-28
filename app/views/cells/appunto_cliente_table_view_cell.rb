class AppuntoClienteTableViewCell < UITableViewCell

  attr_accessor :appunto

  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    super
    self.textLabel.adjustsFontSizeToFitWidth = true
    self.textLabel.textColor = UIColor.darkGrayColor
    self.detailTextLabel.font = UIFont.systemFontOfSize 12
    self.detailTextLabel.numberOfLines = 0
    
    self
  end

  def appunto=(appunto)
    @appunto = appunto

    self.textLabel.text = self.appunto.destinatario
    self.detailTextLabel.text = "#{self.appunto.note}"

    stato_image = UIImage.imageNamed("task-#{self.appunto.stato}")
    self.imageView.setImage(stato_image)

    #self.imageView = {url: self.appunto.user.avatar_url.to_url, placeholder: UIImage.imageNamed("profile-image-placeholder")}

    self.setNeedsLayout

    @appunto
  end

  def self.heightForCellWithAppunto(appunto)
    sizeToFit = appunto.note.sizeWithFont(UIFont.systemFontOfSize(12), constrainedToSize: CGSizeMake(220, Float::MAX), lineBreakMode:UILineBreakModeWordWrap)
    
    return [70, sizeToFit.height + 45].max
  end

  def layoutSubviews
    super

    self.imageView.frame = CGRectMake(14, 10, 32, 32);
    self.textLabel.frame = CGRectMake(70, 10, 200, 20);

    detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0, 25);
    detailTextLabelFrame.size.height = self.class.heightForCellWithAppunto(self.appunto) - 45
    self.detailTextLabel.frame = detailTextLabelFrame
  end

end