//
//  CardapioViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 215//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class CardapioViewController: UIViewController, UIScrollViewDelegate {
	
//	@IBOutlet weak var scrollView: UIScrollView!
//	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		print("carregou CardapioViewController!")
		// Inicialmente, vou pegar somente um dia (22/05/2017).
		CardapioHandler.getCardapio(date: "2017-05-22") {
			(cardapio) in
			
			guard let cardapio = cardapio else {
				print("problema com o cardapio!")
				return
			}
			
			print("Cardapio Almoço: ", cardapio["Almoço"]!)
			
//			CGRect(origin: self.view.frame.origin, size: self.view.frame.size)
			
			let refeicao1 = RefeicaoView(frame: CGRect(origin: self.view.frame.origin, size: self.view.frame.size), cardapio: cardapio["Almoço"]! as! [String: Any]) as UIView
			
			let refeicao2 = RefeicaoView(frame: CGRect(origin: self.view.frame.origin, size: self.view.frame.size), cardapio: cardapio["Jantar"]! as! [String: Any]) as UIView
			
			let pages: [UIView?] = [refeicao1, refeicao2]
			
			// Inicializa o page control
			self.pageControl.currentPage = 0
			self.pageControl.numberOfPages = pages.count
			
			// Adicionar as páginas no scrollview
			for page in pages {
				
				// Calcula um novo frame para a página deslocando em X o tamanho de uma página
				// para colocar as views lado a lado
				page?.frame = (page?.frame.offsetBy(dx: self.scrollView.contentSize.width, dy: 0))!
				
				page?.frame = CGRect(x:page!.frame.origin.x, y:0, width:self.scrollView.frame.width,height: self.scrollView.frame.height)
				
				// FIXME: bug relacionado a altura de cada view que mostra uma faixa preta em cima.
				
				// adiciona a página na scrollview
				self.scrollView.addSubview(page!)
				
				// calcula o tamanho do conteúdo da scrollview
				self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width + self.view.frame.width, height: (page?.frame.height)!)
			}
			
		}
		
		
		
		

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
