 class ImageController < UIViewController
  
  def viewDidLoad
    view.backgroundColor = UIColor.grayColor
    init_picker_btn
    init_image_picker
  end

  def imagePickerController(picker, didFinishPickingImage:image, editingInfo:info)
    self.dismissModalViewControllerAnimated(true)
    add_image_view(image)
    apply_image_filter
  end

  private
  def init_picker_btn
    view.addSubview(UIButton.buttonWithType(UIButtonTypeRoundedRect).tap do |btn|
      btn.frame = [[110, 100], [100, 50]]
      btn.setTitle("Pick photo", forState:UIControlStateNormal)
      btn.addTarget(self, action: :touched, forControlEvents:UIControlEventTouchUpInside)
    end)
  end

  def init_image_picker
    @image_picker = UIImagePickerController.alloc.init
    @image_picker.delegate = self
    @image_picker.sourceType = camera_available ?
      UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary
  end

  def add_image_view(image)
    @image_view.removeFromSuperview if @image_view
    @image_view = UIImageView.alloc.initWithImage(image)
    @image_view.frame = [[60, 200], [200, 200]]
    view.addSubview(@image_view)
  end

  def touched
    presentModalViewController(@image_picker, animated:true)
  end

  def camera_available
    UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceTypeCamera)
  end

  def apply_image_filter
    ci_image = CIImage.imageWithCGImage(@image_view.image.CGImage)
    filter = CIFilter.filterWithName("CIColorInvert")

    filter.setValue(ci_image, forKey:KCIInputImageKey)
    adjusted_image = filter.valueForKey(KCIOutputImageKey)

    new_image = UIImage.imageWithCIImage(adjusted_image)
    @image_view.image = new_image
  end
end