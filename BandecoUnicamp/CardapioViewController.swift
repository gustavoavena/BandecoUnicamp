//
//  CardapioViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 215//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import Dispatch

struct TipoCardapio {
    static let normal: [TipoRefeicao] = [.almoco, .jantar]
    static let vegetariano: [TipoRefeicao] = [.almocoVegetariano, .jantarVegetariano]
    static let todos: [TipoRefeicao] = [.almoco, .almocoVegetariano, .jantar, .jantarVegetariano]
}

class CardapioViewController: UIViewController, UIScrollViewDelegate {
	

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var pageControl: UIPageControl!
    
    /* 0 -> Tradicional
     1 -> Vegetariano */
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
	
    var pagesNormal = [UIView]()
    var pagesVegetariano = [UIView]()


	// TODO: metodo que pega os cardapios somente da semana atual.
	// TODO: metodo que retorna cardapio só dos normais ou só dos vegetarianos.
	// TODO: talvez seja melhor fazer pedido de cardapio normal ou vegetariano separado??

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
		
        scrollView.isPagingEnabled = true
        scrollView.isDirectionalLockEnabled = true
        let SCROLL_VIEW_HEIGHT = scrollView.frame.height

        // FIXME: acho que o pageControl nao aparece porque nos colocamos subviews em cima dele... Entao acho que ele fica escondido no eixo z.
        // OBS: coloquei o pageControl todo vermelho para facilitar a solucao disso (fica mais facil de ver ele)... depois eu mudo a cor.
        
        // TODO: chamar metodo que recebera vetor de Cardapio para todas as datas. Exibir as que o usuario quiser.
        

        
        CardapioServices.getCardapiosBatch(for: CardapioServices.getDates(next: 5)) {
            (cardapios) in
            
            // Inicializa o page control
            self.pageControl.currentPage = 0
            
            
            for cardapioDia in cardapios {
                let pageFrameSize = CGSize(width: self.scrollView.frame.width, height: SCROLL_VIEW_HEIGHT)
                
                var pageFrame = CGRect(origin: self.scrollView.frame.origin, size: pageFrameSize)
                let cardapioViewNormal = CardapioView(frame: pageFrame, data: cardapioDia.data, almoco: cardapioDia.almoco, jantar: cardapioDia.jantar)
                self.pagesNormal.append(cardapioViewNormal)
            
            
                pageFrame = CGRect(origin: self.scrollView.frame.origin, size: pageFrameSize)
                let cardapioViewVegetariano = CardapioView(frame: pageFrame, data: cardapioDia.data, almoco: cardapioDia.almocoVegetariano, jantar: cardapioDia.jantarVegetariano)
                self.pagesVegetariano.append(cardapioViewVegetariano)
                
            }
            
            self.reloadScrollView()
            
            //Tanto faz se será do tamanho de pagesNormal ou pagesVegetariano
            self.pageControl.numberOfPages = self.pagesNormal.count
        }
    }
    
    @IBAction func changeSegmentedControl(_ sender: Any) {
        let pageNumber = self.pageControl.currentPage
        // scrollView.contentOffset.x / self.view.frame.width
        let offsetX = scrollView.contentOffset.x
//        let width = self.view.frame.width
        reloadScrollView()
        self.pageControl.currentPage = pageNumber
        scrollView.contentOffset.x = offsetX
        
    }
    
    func reloadScrollView(){
        let SCROLL_VIEW_HEIGHT = scrollView.frame.height

        for view in scrollView.subviews{
            if let refView = view as? RefeicaoView {
                refView.removeFromSuperview()
            }
        }
        
        
        self.scrollView.contentSize = CGSize(width:0,height:0)
        
        var pages: [UIView] = [UIView]()
        
        if(self.typeSegmentedControl.selectedSegmentIndex == 0) {
            pages = self.pagesNormal
        } else {
            pages = self.pagesVegetariano
        }
        
        
        
        for page in pages{
            // Calcula um novo frame para a página deslocando em X o tamanho de uma página
            // para colocar as views lado a lado
            page.frame = (scrollView.frame.offsetBy(dx: self.scrollView.contentSize.width, dy: 0))
            
            page.frame = CGRect(x:page.frame.origin.x, y:0, width:self.view.frame.width,height: SCROLL_VIEW_HEIGHT)
            
            // FIXME: bug relacionado a altura de cada view que mostra uma faixa preta em cima.
            
            
            // adiciona a página na scrollview
            self.scrollView.addSubview(page)
            
            // calcula o tamanho do conteúdo da scrollview
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width + self.view.frame.width, height: SCROLL_VIEW_HEIGHT)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         self.view.bringSubview(toFront: self.pageControl)
    }
    
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		// calcula o numero da página baseado no quanto o scrollview está deslocado em X
		let page = floor(scrollView.contentOffset.x / self.view.frame.width)
		
		// Para atualizar o current page é necessário converter o float para Int
		pageControl.currentPage = Int(page)
	}


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
}
