class UserController < UIViewController

  stylesheet :main

  def init
    super && self.tap {}
  end
  
  def viewDidLoad

    super
    
    @data = [{
        fieldName: "username",
        value: "paolotax"
      },{
        fieldName: "password",
        value: "sisboccia"
    }]

    @table_view = UITableView.grouped   # !?
    @table_view.dataSource = self
    @table_view.delegate = self

    self.view << @table_view   # !?

    @modal_view = UIControl.alloc.initWithFrame(self.view.bounds)  # [[0, 0, 320, 460]], if you are the "show me the numbers" type
    @modal_view.backgroundColor = :black.uicolor(0.5)  # black, with alpha of 0.5
    @modal_view.alpha = 0.0  # hide the view

    self.view << @modal_view

    @button_kill = subview(UIButton.rounded_rect, :ok_button)
    @button_kill.when(UIControlEventTouchUpInside) do
      exit(0)
    end

    gravatar_url = Gravatar.getURL("paolo.tassinari@gmail.com")
    image = UIImage.imageWithData(NSData.dataWithContentsOfURL(gravatar_url))

    @image_view = UIImageView.alloc.initWithImage(image.rounded(10))
    @image_view.frame = [[60, 157], [200, 200]]
    view.addSubview(@image_view)
  end

  def tableView(table_view, numberOfRowsInSection:section)
   2
  end

  def tableView(table_view, cellForRowAtIndexPath:index_path)

    cell = table_view.dequeueReusableCellWithIdentifier('Cell')
    unless cell
      cell = UITableViewCell.alloc.initWithStyle(:value1.uitablecellstyle,   # !?
                                 reuseIdentifier:'Cell')
    end

    cell.textLabel.text = @data[index_path.row][:fieldName]
    cell.detailTextLabel.text = @data[index_path.row][:value]
    return cell
  end

  # def tableView(table_view, titleForHeaderInSection:section)
  #   "Settings"
  # end



  def tableView(table_view, didSelectRowAtIndexPath:index_path)
    table_view.deselectRowAtIndexPath(index_path, animated:true)
  end


end