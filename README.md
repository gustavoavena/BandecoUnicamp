#  Bandex

### Português:

O Bandex foi desenvolvido para melhorar a experiência da comunidade da UNICAMP nos restaurantes universitários.
O usuário consegue rapidamente acessar o cardápio sem desbloquear o celular, utilizando o Widget.

Funcionalidades:
- Design simples, baseado nos conceitos do Human Interface Guidelines da Apple.
- Widget extension: permite que o usuário acesse o cardápio da próxima refeição sem desbloquear o celular.
- Configuração de dieta: essa configuração determina o cardápio que será exibido no Widget e, futuramente, qual cardápio será informado nas notificações.
- iMessage Stickers
- Share extension

Funcionalidades em desenvolvimento:
- Notificações personalizadas
- Integração com calendário


O Bandex foi desenvolvido em conjunto com um API implementado com Flask, para manter uma arquitetura mais organizada que facilita o desenvolvimento para outras plataformas no futuro. Esse API obtém o cardápio dos Restaurantes diretamente com a Prefeitura da UNICAMP e faz uma "limpeza" das informações ( corrige letras maiúsculas, observações desorganizadas ).
Repositorio: https://github.com/gustavoavena/CardapioParser


### English:

Bandex was developed to improve the UNICAMP community's experience in the university dining halls. The user can quickly access the available menu through a pleasant design, developed based on principles from Apple's Human Interface Guidelines for iOS.

Features:
- Simple and functional design, based on principles from Apple's Human Interface Guidelines for iOS.
- Widget extension: quickly access the next meal's menu without unlocking your iPhone.
- Dietary preferences: allows the user to choose which menu will be displayed in the widget and, in the future, in the notifications.
- iMessage Stickers
- Share extension

In development:
- Custom notifications
- Calendar integration


Bandex was developed along with an API written in Python, to keep an organized architecture that will ease the development for other platforms in the future. This API obtains the available dining halls menus directly from UNICAMP and parses the information (correctly capitalizes text, corrects punctuation)  to make it available to the client app.


