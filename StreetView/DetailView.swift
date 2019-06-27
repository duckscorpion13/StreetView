
import UIKit

@objc protocol DetailViewDelegate {
	@objc optional func detailViewCancel()
	@objc optional func detailViewCreate()
	@objc optional func detailViewEdit()
	@objc optional func detailViewGo()
}

class DetailView : UIView {
    
    var delegate: DetailViewDelegate? = nil
    var latitude: String?
    var longitude: String?
	
	var star = 2.5 {
		didSet {
			self.m_starLabel.text = "(\(star))"
		}
	}
	
	var title = "" {
		didSet {
			self.m_titleLabel.text = "\(title)"
		}
	}
	var snippet = "" {
		didSet {
			self.m_snippetLabel.text = "\(snippet)"
		}
	}
	var location = "" {
		didSet {
			self.m_locationLabel.text = "\(location)"
		}
	}
    let m_starLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "2.5"
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textColor = UIColor.black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
	
	let m_stackView: UIStackView = {
		let stack = UIStackView()
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.axis = .vertical
		stack.distribution = .equalSpacing
		stack.alignment = .fill
		stack.spacing = 15
		return stack
	}()
    
    let m_titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.text = "title"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.italicSystemFont(ofSize: 20)
        lbl.adjustsFontSizeToFitWidth = true
        //title.minimumScaleFactor = 0.2
        lbl.numberOfLines = 1
        return lbl
    }()
    
    let m_snippetLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .blue
        lbl.text = "snippet"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 14)
		lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
	
    let m_locationLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .brown
        lbl.text = "location"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 14)
		lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
	
    
    let m_cancelButton : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "cancel"), for: UIControl.State())
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func cancel() {
      delegate?.detailViewCancel?()
    }
    
    let m_createButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Create", for: UIControl.State())
        btn.backgroundColor = .brown
        btn.setTitleColor(UIColor.white, for: UIControl.State())
        btn.titleLabel?.font = UIFont.italicSystemFont(ofSize: 18)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(create), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func create() {
        delegate?.detailViewCreate?()
    }
  
  let m_editButton : UIButton = {
    let btn = UIButton()
    btn.setTitle("Edit", for: UIControl.State())
    btn.backgroundColor = .blue
    btn.setTitleColor(UIColor.white, for: UIControl.State())
    btn.titleLabel?.font = UIFont.italicSystemFont(ofSize: 18)
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.addTarget(self, action: #selector(edit), for: .touchUpInside)
    return btn
  }()
  
  @objc private func edit() {
    delegate?.detailViewEdit?()
  }
  
  let m_goButton : UIButton = {
    let btn = UIButton()
    btn.setTitle("Go", for: UIControl.State())
    btn.backgroundColor = UIColor.red
    btn.setTitleColor(UIColor.white, for: UIControl.State())
    btn.titleLabel?.font = UIFont.italicSystemFont(ofSize: 18)
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.addTarget(self, action: #selector(go), for: .touchUpInside)
    return btn
  }()
  
  @objc func go() {
    delegate?.detailViewGo?()
  }
	
	let m_imgView: UIImageView = {
		let imgView = UIImageView(image: nil)
		imgView.translatesAutoresizingMaskIntoConstraints = false
		return imgView
	}()
	
    override init(frame: CGRect) {
        super.init(frame: frame)
      
		translatesAutoresizingMaskIntoConstraints = false
        addSubview(m_titleLabel)
        m_titleLabel.topAnchor.constraint(equalTo: self.readableContentGuide.topAnchor).isActive = true
        m_titleLabel.leadingAnchor.constraint(equalTo: self.readableContentGuide.leadingAnchor).isActive = true
		
		addSubview(m_starLabel)
      	m_starLabel.centerYAnchor.constraint(equalTo: m_titleLabel.centerYAnchor, constant: 0).isActive = true
      	m_starLabel.leadingAnchor.constraint(equalTo: m_titleLabel.trailingAnchor, constant: 0).isActive = true
		
		addSubview(m_snippetLabel)
        m_snippetLabel.topAnchor.constraint(equalTo: m_starLabel.bottomAnchor, constant: 8).isActive = true
        m_snippetLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
		
		addSubview(m_locationLabel)
        m_locationLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        m_locationLabel.topAnchor.constraint(equalTo: m_snippetLabel.bottomAnchor, constant: 8).isActive = true
		
		addSubview(m_imgView)
		m_imgView.topAnchor.constraint(equalTo: m_locationLabel.bottomAnchor).isActive = true
		m_imgView.bottomAnchor.constraint(equalTo: readableContentGuide.bottomAnchor).isActive = true
		m_imgView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		m_imgView.widthAnchor.constraint(equalTo: m_imgView.heightAnchor).isActive = true
		
		addSubview(m_cancelButton)
		m_cancelButton.centerYAnchor.constraint(equalTo: m_titleLabel.centerYAnchor, constant: 0).isActive = true
		m_cancelButton.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor).isActive = true
		m_cancelButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
		m_cancelButton.widthAnchor.constraint(equalTo: m_cancelButton.heightAnchor).isActive = true
		
		m_stackView.addArrangedSubview(m_createButton)
		m_stackView.addArrangedSubview(m_editButton)
		m_stackView.addArrangedSubview(m_goButton)
		addSubview(m_stackView)
		m_stackView.topAnchor.constraint(equalTo: m_titleLabel.bottomAnchor).isActive = true
		m_stackView.widthAnchor.constraint(equalToConstant: frame.width / 3)
		m_stackView.trailingAnchor.constraint(equalTo: m_cancelButton.leadingAnchor, constant: -8).isActive = true
		m_stackView.bottomAnchor.constraint(equalTo: readableContentGuide.bottomAnchor).isActive = true
		
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

