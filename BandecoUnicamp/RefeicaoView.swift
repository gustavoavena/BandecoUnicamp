//
//  RefeicaoView.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 215//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

@IBDesignable
class RefeicaoView: UIView {
	
	/// view that is loaded from xib file
	fileprivate var contentView: UIView!

	@IBOutlet var pratos: [UILabel]!
	@IBOutlet weak var salada: UILabel!
	@IBOutlet weak var suco: UILabel!
	@IBOutlet weak var data: UILabel!
	@IBOutlet weak var refeicao: UILabel!
	@IBOutlet weak var arrozFeijao: UILabel!
	@IBOutlet weak var sobremesa: UILabel!

	//MARK: Initialization
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setupXib()
	}
	
	//MARK: IBDesignable
	
	//## 3 - UNCOMMENT: Solution
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupXib()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupXib()
	}
	
	public init(frame: CGRect, cardapio: [String: Any]) {
		super.init(frame: frame)
		setupXib()
		
		
		self.arrozFeijao.text = cardapio["arroz_feijao"] as! String
		self.salada.text = cardapio["salada"] as! String
		self.suco.text = cardapio["suco"] as! String
		self.sobremesa.text = cardapio["sobremesa"] as! String
		
		let pratos = cardapio["prato_principal"]  as! [String]
		for i in 0..<pratos.count {
			
			self.pratos[i].text = pratos[i]
		}
	}
	
	
	//## 1 - UNCOMMENT: XIB Appears
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		setupXib()
	}


}



//MARK: Xib functions
extension RefeicaoView {
	
	/// Instantiate the view defined in a xib file using the same name of the class
	///
	/// - Returns: the first view found in the xib or nil if it was unable to find any view
	func loadViewFromXib() -> UIView? {
		// first of all, load the bundle where the xib is.
		let bundle = Bundle(for: type(of: self))
		
		// load the xib from the main bundle
		let xib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
		
		// load the view inside the xib
		return xib.instantiate(withOwner: self, options: nil).first as? UIView
	}
	
	/// Loads the xib, associates it to the contentView and add it to the view's hierarchy
	func setupXib() {
		// only load the xib if the contentView is not loaded yet
		if contentView == nil {
			// load content view from xib
			contentView = loadViewFromXib()
			
			// if it has failed, this example needs to be rewriten
			guard contentView != nil else {
				fatalError("Can't load the view from \(String(describing: type(of: self))).xib")
			}
			
			// adjust the contentView to have the same size of the view itself
			contentView.frame = bounds
			
			// let the content view adjusts automatically for flexible size (width and height)
			contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			
			// set background color to transparent as default
			backgroundColor = UIColor.clear
			
			// add content view to the view hierarchy
			addSubview(contentView)
		}
	}
	
}
