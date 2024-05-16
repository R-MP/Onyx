<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    
    <title>MQS</title>
    
    <link rel="shortcut icon" href="/WEB-INF/images/favicon.ico">
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
    <style><%@include file="/WEB-INF/css/style.css"%></style>
    <link href="https://fonts.googleapis.com/css2?family=Poppins&display=swap" rel="stylesheet">
    

</head>
<body>
    <header class="header_one">
    <nav class="navbar navbar-expand-lg navbar-light bg-light" id="top">
    <div class="container">
        <a class="navbar-brand" href="#home">
            
            <img src="https://cdn.discordapp.com/attachments/1240115826560860180/1240116252777644143/component.png?ex=664563c2&is=66441242&hm=a24cd07e0f431e4e784660b943878d98b7ca24bca89b34548aa60893049b8122&" alt="Logo">
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#top-menu" aria-expanded="false">
                <span class="navbar-toggler-icon"></span>
        </button>

            <div class="collapse navbar-collapse" id="top-menu">
                <ul class="navbar-nav mr-auto mx-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index.html">Página Inicial</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#about">Quem Somos</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="animais.html">Encontre Um Amigo</a>
                    </li>
                </ul>
                <div class="col-sm-3 my-1">
                    <div class="input-group">
                        <input class="form-control" type="search" placeholder="Busca" aria-label="Search" style="border-right: none;">
                        <div class="input-group-append">
                            <div class="input-group-text" style="background-color: transparent;"><button type="submit" class="fas fa-search" style="color: #856DD7"></button></div>
                        </div>
                    </div>
                </div>
                <button type="button" class="btn btn-primary btn-lg">Fale Conosco</button>
            </div>
    </div>
    </nav>
    </header>
    <div class="container">
        <section class="section" id="home">
            <img id="background" src="https://cdn.discordapp.com/attachments/1240115826560860180/1240117313034915931/background.png?ex=664564bf&is=6644133f&hm=040b33cb541b1c2dadb8049a6415f2f0a3ea1b0542b96d5a6000c68e6f6a8011&" alt="background">
            <div class="row align-items-center text-center">
                <div class="col-md-12 col-lg-12 mb-5 mb-md-0">
                    <img class="img-fluid" src="https://cdn.discordapp.com/attachments/1240115826560860180/1240116253553856542/fundo1.png?ex=664563c3&is=66441243&hm=c3db3aa1fba65c8c14c2fe1abdc275163dc012fdbeda07a112b4d96858bb35b7&" alt="">
                </div>
                <div class="col-md-12 col-lg-12 mb-5 mb-md-0">
                    <br><br>
                    <h1>Nós queremos fazer a diferença<br> <span>na causa animal</span></h1>
                    <button type="button" class="btn btn-success btn-lg" href="#">Quero Adotar</button>
                    <button type="button" class="btn btn-default btn-lg" href="#">Fale Conosco</button>
                </div>
            </div>
        </section>

        <section class="section" id="about">
            <p></p><br>
        <div class="row">
            <div id="animal-list" class="col-md-3">
                <div class="animal-box">
                    <img src="/error.jpg" alt="Minha Imagem">
                    <p>Bob</p>
                    <button class="btn btn-primary" onclick="window.location.href='bob.html'">Me conheça</button>
                </div>
            </div>
            <div class="col-md-3">
                <div class="animal-box">
                    <img src="projeto\images\animal2.jpg" alt="Animal 2">
                    <p>Mia</p>
                    <button class="btn btn-primary">Me conheça</button>
                </div>
            </div>
            <div class="col-md-3">
                <div class="animal-box">
                    <img src="projeto\images\animal3.jpg" alt="Animal 3">
                    <p>Negresco</p>
                    <button class="btn btn-primary">Me conheça</button>
                </div>
            </div>
            <div class="col-md-3">
                <div class="animal-box">
                    <img src="projeto\images\animal4.jpg" alt="Animal 4">
                    <p>Snow</p>
                    <button class="btn btn-primary">Me conheça</button>
                </div>
            </div>
        </div>
        <br>
        <div class="row">
            <div class="col-md-3">
                <div class="animal-box">
                    <img src="projeto\images\animal5.jpg" alt="Animal 5">
                    <p>Barney</p>
                    <button class="btn btn-primary">Me conheça</button>
                </div>
            </div>
            <div class="col-md-3">
                <div class="animal-box">
                    <img src="projeto\images\animal6.jpg" alt="Animal 6">
                    <p>Lasanha</p>
                    <button class="btn btn-primary">Me conheça</button>
                </div>
            </div>
            <div class="col-md-3">
                <div class="animal-box">
                    <img src="projeto\images\animal7.jpg" alt="Animal 7">
                    <p>Milk</p>
                    <button class="btn btn-primary">Me conheça</button>
                </div>
            </div>
            <div class="col-md-3">
                <div class="animal-box">
                    <img src="projeto\images\animal8.jpg" alt="Animal 8">
                    <p>Muffin</p>
                    <button class="btn btn-primary">Me conheça</button>
                </div>
            </div>
        </div>
        <br>
        <div class="text-center">
            <button type="button" class="btn btn-default btn-lg" href="#">Ver Mais</button>
        </div>
        </section>
    </div>
    <br>
    <footer class="footer-area">
        <div class="container">
            <div class="section-intro text-center pb-90px">
                <img class="logotipo" src="projeto\images\component.png" alt="Logotipo Gotech">
            </div>
            <div class="row">
                <div class="col-lg-3 col-md-6 col-sm-6">
                    <div class="single-footer-widget">
                        <h6>Entre em Contato</h6>
                        <a href="#" class="icon-contato"><i class="fa fa-phone" aria-hidden="true"></i></a>
                            520-7927<br>
                        <a href="#" class="icon-contato"><i class="fa fa-map-marker" aria-hidden="true"></i></a>
                            Praia Grande, São Paulo <br>
                        <a href="#" class="icon-contato"><i class="fa fa-envelope" aria-hidden="true"></i></a>
                            adote@email.com
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 col-sm-6">
                    <div class="single-footer-widget">
                        <h6>Nosso Site</h6>
                        <div class="row">
                            <div class="col">
                                <ul>
                                    <li><a href="#">Quem somos</a></li>
                                    <li><a href="#">Página Inicial</a></li>
                                </ul>
                            </div>									
                        </div>							
                    </div>
                </div>							
                <div class="col-lg-3 col-md-6 col-sm-6">
                    <div class="single-footer-widget">
                        <h6>Adote Um Amigo</h6>
                        <div class="row">
                            <div class="col">
                                <ul>
                                    <li><a href="#">Pesquisar Um Animal</a></li>
                                </ul>
                            </div>                  
                        </div>              
                    </div>
                </div>  
                <div class="col-lg-3  col-md-6 col-sm-6">
                    <div class="single-footer-widget mail-chimp">
                        <h6>Redes Sociais</h6>
                        <div class="col-lg-12 col-sm-12 footer-social text-center text-lg-left">
                            <a href="#" class="facebook"><i class="fab fa-facebook-f"></i></a>
                            <a href="#" class="linkedin"><i class="fab fa-linkedin"></i></a>
                            <a href="#" class="instagram"><i class="fab fa-instagram"></i></a>
                        </div>
                    </div>
                </div>						
            </div>
        </div>
    </footer>
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    <script type="text/javascript" src="projeto\js\script.js"></script>
</body>
</html>
