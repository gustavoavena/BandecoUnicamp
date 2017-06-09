//
//  CardapioView.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 08/06/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit


@IBDesignable
class CardapioView: UIView {

    fileprivate var contentView: UIView!
    
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var almoco: RefeicaoView!
    @IBOutlet weak var jantar: RefeicaoView!
    @IBOutlet weak var obsAlmoco: UILabel!
    @IBOutlet weak var obsJantar: UILabel!
    
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

    
    
    //## 1 - UNCOMMENT: XIB Appears
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupXib()
    }
    
    public convenience init(frame: CGRect, data: Date, almoco: Refeicao, jantar: Refeicao) {
        self.init(frame: frame)
        
        setupXib()
        
        // TODO: formatar data corretamente: "Quarta, 7 de Junho"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.data.text = dateFormatter.string(from: data)
        
        
        self.almoco = RefeicaoView(frame: self.almoco.frame, refeicao: almoco)
        
        self.jantar = RefeicaoView(frame: self.jantar.frame, refeicao: jantar)
        
        self.obsAlmoco.text = almoco.observacoes
        self.obsJantar.text = jantar.observacoes

    }
    


}




//MARK: Xib functions
extension CardapioView {
    
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
