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

	// TODO: colocar valores default em cada um. (e.g. "-" case ele esteja vazio).
	@IBOutlet var pratos: [UILabel]!
    public static let NUM_PRATOS_PRINCIPAIS = 3
	@IBOutlet weak var salada: UILabel!
	@IBOutlet weak var suco: UILabel!
	@IBOutlet weak var data: UILabel!
	@IBOutlet weak var refeicao: UILabel!
	@IBOutlet weak var arrozFeijao: UILabel!
	@IBOutlet weak var sobremesa: UILabel!
    @IBOutlet weak var observacoes: UILabel!

	
	override func awakeFromNib() {
		super.awakeFromNib()
		setupXib()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupXib()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupXib()
	}

    
//    // Initializer utilizado para instanciar uma RefeicaoView programaticamente e usar no Scroll View.
//    public convenience init(frame: CGRect, refeicao: Refeicao, date: Date, cardapio: [String: Any]) {
//		self.init(frame: frame)
//        
//		setupXib()
//		
//        
//        // TODO: consertar capitalize do cardapio no CardapioParser
//        // TODO: exibir data e dia da semana.
//        self.refeicao.text = refeicao.rawValue
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        let dateString = dateFormatter.string(from: date)
//        
//        self.data.text = dateString
//        
//        
//        
//		
//		self.arrozFeijao.text = (cardapio[JSONKeys.arrozFeijao.rawValue] as! String)
//		self.salada.text = (cardapio[JSONKeys.salada.rawValue] as! String)
//		self.suco.text = (cardapio[JSONKeys.suco.rawValue] as! String)
//		self.sobremesa.text = (cardapio[JSONKeys.sobremesa.rawValue] as! String)
//		
//		let pratos = cardapio[JSONKeys.pratoPrincipal.rawValue]  as! [String]
//        
//        // FIXME: problema com o tamanho do vetor pratos. Ele parece ter mais que 3 elementos as vezes.
//        
//		for i in 0..<(min(RefeicaoView.NUM_PRATOS_PRINCIPAIS, pratos.count)) {
//            self.pratos[i].text = pratos[i]
//		}
//        
//        // TODO: imprimir observacoes.
//        self.observacoes.text = (cardapio[JSONKeys.observacoes.rawValue] as! String)
//		
//	}
    
    public convenience init(frame: CGRect, data: Date, refeicao: Refeicao, cardapioDia: CardapioDia) {
        self.init(frame: frame)
        
        setupXib()
        
        self.refeicao.text = refeicao.rawValue
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: data)
        
        self.data.text = dateString
        
        self.arrozFeijao.text = cardapioDia[refeicao].arrozFeijao
        self.salada.text = cardapioDia[refeicao].salada
        self.sobremesa.text = cardapioDia[refeicao].sobremesa
        
        self.observacoes.text = cardapioDia[refeicao].observacoes
        
        for i in 0..<(min(RefeicaoView.NUM_PRATOS_PRINCIPAIS, cardapioDia[refeicao].pratoPrincipal.count)) {
            self.pratos[i].text = cardapioDia[refeicao].pratoPrincipal[i]
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
