//
//  CardapioViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 215//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

struct TipoCardapio {
    static let normal: [Refeicao] = [.almoco, .jantar]
    static let vegetariano: [Refeicao] = [.almocoVegetariano, .jantarVegetariano]
    static let todos: [Refeicao] = [.almoco, .almocoVegetariano, .jantar, .jantarVegetariano]
}

class CardapioViewController: UIViewController, UIScrollViewDelegate {
	

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var pageControl: UIPageControl!
	
	// TODO: metodo que pega os cardapios somente da semana atual.
	// TODO: metodo que retorna cardapio só dos normais ou só dos vegetarianos.
	// TODO: talvez seja melhor fazer pedido de cardapio normal ou vegetariano separado??

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
		
        scrollView.isPagingEnabled = true
        scrollView.isDirectionalLockEnabled = true
        
        // FIXME: acho que o pageControl nao aparece porque nos colocamos subviews em cima dele... Entao acho que ele fica escondido no eixo z.
        // OBS: coloquei o pageControl todo vermelho para facilitar a solucao disso (fica mais facil de ver ele)... depois eu mudo a cor.
        
        // FIXME: make me async?
        loadNextDays(refeicoes: TipoCardapio.todos)
        

		
		

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
    
    
    func loadNextDays(refeicoes: [Refeicao]) {
        let pages: [UIView?] = [UIView?]()
        
        let SCROLL_VIEW_HEIGHT = self.scrollView.frame.height
        
        
        
        // Inicializa o page control
        self.pageControl.currentPage = 0
        self.pageControl.numberOfPages = pages.count
        
        // Adicionar as páginas no scrollview
        
        
        let dates = CardapioRequest.getDates(next: 7)
        
        
        for d in dates {
            CardapioRequest.getCardapio(date: d) {
                (cardapioData) in
                
                guard let cardapio = cardapioData, cardapio.keys.count == 4 else { // confere se tem as 4 refeicoes
                    print("CardapioRequest nao retornou dados pro dia \(d)!")
                    return
                }
                
//                print(cardapio)
                
                let pageFrameSize = CGSize(width: self.scrollView.frame.width, height: SCROLL_VIEW_HEIGHT)

                
                var pages = [UIView]()
                
                for r in refeicoes {
                    let refeicaoView = RefeicaoView(frame: CGRect(origin: self.scrollView.frame.origin, size: pageFrameSize), refeicao: r, cardapio: cardapio[r.rawValue]! as! [String: Any]) as UIView
                    pages.append(refeicaoView)
                }
                
                for page in pages{
                    
                    // Calcula um novo frame para a página deslocando em X o tamanho de uma página
                    // para colocar as views lado a lado
                    page.frame = (page.frame.offsetBy(dx: self.scrollView.contentSize.width, dy: 0))
                    
                    page.frame = CGRect(x:page.frame.origin.x, y:0, width:self.scrollView.frame.width,height: SCROLL_VIEW_HEIGHT)
                    
                    // FIXME: bug relacionado a altura de cada view que mostra uma faixa preta em cima.
                    
                    // adiciona a página na scrollview
                    self.scrollView.addSubview(page)
                    
                    // calcula o tamanho do conteúdo da scrollview
                    self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width + self.view.frame.width, height: SCROLL_VIEW_HEIGHT)
                }
                
            }
        }

    }

}
