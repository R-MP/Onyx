<%-- 
    Document   : products
    Created on : 2 de mar. de 2022, 19:54:10
    Author     : spbry
--%>

<%@page import="db.Brand"%>
<%@page import="db.Movement"%>
<%@page import="db.Product"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestError = null;
    ArrayList<Product> products = new ArrayList<>();
    int pgNum = 0;
    if(session.getAttribute("prodPage") != null)pgNum = ((Integer)session.getAttribute("prodPage")-1)*10;
    int qtdProd = Product.getAll();
    String bySrc = (String) session.getAttribute("prodSearch");
    if(bySrc==null)bySrc="";
    else qtdProd = Product.getSearchPage(bySrc);
    String byOrd = (String) session.getAttribute("prodOrder");
    Boolean isDeleted = (Boolean) session.getAttribute("checkProducts");
    if(isDeleted == null)isDeleted = false;
    if((String) session.getAttribute("prodSearch")!=null){
    bySrc = (String) session.getAttribute("prodSearch");
    }
    try {
        //ADD PRODUCT
        if (request.getParameter("insert") != null) {
            String prodName = request.getParameter("prodName");
            String prodBrand = request.getParameter("prodBrand");
            String prodMaterial = request.getParameter("prodMaterial");
            String prodSize = request.getParameter("prodSize");
            Product.insertProd(prodName, prodBrand, prodMaterial, prodSize);
            response.sendRedirect(request.getRequestURI());
            
        //EDIT PRODUCT
        } else if (request.getParameter("edit") != null) {
            Integer prodId = Integer.parseInt(request.getParameter("prodId"));
            String prodName = request.getParameter("prodName");
            String prodBrand = request.getParameter("prodBrand");
            String prodMaterial = request.getParameter("prodMaterial");
            String prodSize = request.getParameter("prodSize");
            Product.alterProd(prodId, prodName, prodBrand, prodMaterial, prodSize);
            response.sendRedirect(request.getRequestURI());
            
        //DELETE PRODUCT
        } else if (request.getParameter("delete") != null) {
            Integer prodId = Integer.parseInt(request.getParameter("prodId"));
            Product.deleteProd(prodId);
            session.setAttribute("checkProducts",true);
            response.sendRedirect(request.getRequestURI());
        }
        
        //PAGE PRODUCT
        if (request.getParameter("page") != null) {
            pgNum = Integer.parseInt(request.getParameter("page"));
            session.setAttribute("prodPage",pgNum);
            pgNum = (pgNum-1)*10;
        }
        
        //SEARCH PRODUCT
        if (request.getParameter("srcFilter")!= null){
            bySrc = request.getParameter("searchFor");
            qtdProd = Product.getSearchPage(bySrc);
            session.setAttribute("prodSearch", bySrc);
            session.removeAttribute("prodPage");
            response.sendRedirect(request.getRequestURI());
        }
        
        //ORDER PRODUCT
        if (request.getParameter("orderColumn")!= null){
            byOrd = request.getParameter("orderColumn");
            session.setAttribute("prodOrder", byOrd);
            response.sendRedirect(request.getRequestURI());
        }
        
        //CLEAR SEARCH PRODUCT
        if(request.getParameter("clearFilter") != null) {
            session.removeAttribute("prodSearch");
            bySrc = "";
        }
        
    } catch (Exception ex) {
        requestError = ex.getLocalizedMessage();
    }
    
    int pageProd = (int) Math.ceil((double)qtdProd/10);
    products = Product.getPageOrderBy(pgNum, byOrd, bySrc);
    
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Produtos</title>
        <link rel="icon" type="image/x-icon" href="images/Stock2Flow.svg">
        <%@include file="WEB-INF/jspf/bootstrap-header.jspf" %>
        <%@include file="WEB-INF/jspf/jquery-header.jspf" %>
        <%@include file="WEB-INF/jspf/datatable-header.jspf" %>
        <%@include file="WEB-INF/jspf/sweetalert-header.jspf" %>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <%if(isDeleted == true){
          session.setAttribute("checkProducts", false);%>
        <script>
            Swal.fire(
                'Deletado!',
                'Seu registro foi deletado com sucesso.',
                'success'
                );
        </script>
        <%}%>
        <div class="container-fluid mt-2">
            <% if (sessionUserEmail != null && sessionUserVerified == true) {%>
            <div class="card">
                <div class="card-body">
                    <h2>Produtos (<%= qtdProd%>)
                        <% if (sessionUserRole.equals("Admin")) {%>
                        <!-- BUTTON ADD PRODUCT -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#add">
                            <i class="bi bi-plus-lg"></i>
                        </button>
                        <% } %>
                        <!-- FILTER INPUT -->
                        <div class="float-md-end h6">
                            <form method="post" enctype="application/x-www-form-urlencoded" class="input-group">
                                <input type="text" name="searchFor" id="searchFor" class="form-control" value="<%= bySrc %>"/>
                                <button type="submit" name="srcFilter" class="btn btn-primary">
                                    <i class="bi bi-search"></i>
                                </button>
                                <% if(bySrc != "") { %>
                                <button type="submit" name="clearFilter" class="btn btn-secondary">
                                    <i class="bi bi-x-lg"></i>
                                </button>
                                <% } %>
                            </form>
                        </div>
                    </h2>
                    <!-- ADD PRODUCT SCREEN -->
                    <div class="modal fade" id="add" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <form enctype="application/x-www-form-urlencoded" method="post">
                                    <div class="modal-body">
                                        <!-- PRODUCT NAME -->
                                        <div class="mb-3">
                                            <label for="prodName">Nome <small><i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" title="Campo obrigatório"></i></small></label>
                                            <input type="text" class="form-control" name="prodName" id="prodName" required/>
                                        </div>
                                        <!-- PRODUCT BRAND -->
                                        <div class="mb-3">
                                            <label for="prodBrand">Marca <small><i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" title="Campo obrigatório"></i></small></label>
                                            <select class="form-control" name="prodBrand" id="prodBrand">
                                                <%  ArrayList<String> brandNames = Brand.getBrandNames();
                                                    for (int j = 0; j < brandNames.size(); j++) {%>
                                                <option value="<%=brandNames.get(j)%>"><%=brandNames.get(j)%></option>
                                                <%}%>
                                            </select>
                                        </div>
                                        <!-- PRODUCT MATERIAL -->
                                        <div class="mb-3">
                                            <label for="prodMaterial">Material</label>
                                            <input type="text" class="form-control" name="prodMaterial" id="prodMaterial"/>
                                        </div>
                                        <!-- PRODUCT SIZE -->
                                        <div class="mb-3">
                                            <label for="prodSize">Tamanho</label>
                                            <input type="text" class="form-control" name="prodSize" id="prodSize"/>
                                        </div>
                                    </div>
                                    <!-- PRODUCT SAVE AND CANCEL BUTTON -->
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                        <input type="submit" name="insert" value="Adicionar" class="btn btn-primary">
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <!-- SHOW ERROR CODE -->
                    <% if (requestError != null) {%>
                    <div class="alert alert-danger" role="alert">
                        <%= requestError%>
                    </div>
                    <% } %>
                    <!-- PRODUCT MAIN TABLE -->
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead class="bg-light">
                                <tr>
                                    <th>
                                        <form method="post">
                                            ID
                                            <input type="hidden" name="orderColumn" value="prodId">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <th>
                                        <form method="post">
                                            Nome
                                            <input type="hidden" name="orderColumn" value="prodDesc">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <th>
                                        <form method="post">
                                            Marca
                                            <input type="hidden" name="orderColumn" value="prodBrand">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <th>
                                        <form method="post">
                                            Material
                                            <input type="hidden" name="orderColumn" value="prodMaterial">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <th>
                                        <form method="post">
                                            Tamanho
                                            <input type="hidden" name="orderColumn" value="prodSize">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <th>
                                        <form method="post">
                                            Valor Médio
                                            <input type="hidden" name="orderColumn" value="prodAvg">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <th>
                                        <form method="post">
                                            Quantidade
                                            <input type="hidden" name="orderColumn" value="prodQnt">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <% if (sessionUserRole.equals("Admin")) {%><th></th><% } %>
                                </tr>
                            </thead>
                            <tbody>
                                <% int i = 0;
                                   for (Product product : products) {
                                   i++; %>
                                <tr>
                                    <td><%= product.getProdId()%></td>
                                    <td><%= product.getProdName()%></td>     
                                    <td><%= product.getProdBrand()%></td>
                                    <td><%= product.getProdMaterial()%></td>
                                    <td><%= product.getProdSize()%></td>
                                    <td><%= product.getProdAvg()%></td>
                                    <td><%= product.getProdQnt()%></td>
                                    <% if (sessionUserRole.equals("Admin")) {%>
                                    <td>
                                        <form name="objAlter" enctype="application/x-www-form-urlencoded" id="objAlter-<%= i%>" method="post" onsubmit="validateAlert(<%= i%>, this)">
                                            <!-- BUTTON EDIT & DELETE PRODUCT -->
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#edit-<%= i%>">
                                                <i class="bi bi-pencil-square"></i></button>
                                            <input type="hidden" name="prodId" value="<%= product.getProdId()%>"/>
                                            <input type="hidden" name="delete" value="del"/>
                                            <button type="submit" name="delete" class="btn btn-danger btn-sm">
                                                <i class="bi bi-trash3"></i></button>
                                        </form>
                                        <!-- EDIT PRODUCT SCREEN -->
                                        <div class="modal fade" id="edit-<%= i%>" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content">
                                                    <form enctype="application/x-www-form-urlencoded" method="post">
                                                        <div class="modal-body">
                                                            <!-- PRODUCT ID -->
                                                            <div class="mb-3">
                                                                <label for="prodId-<%= i%>">ID</label>
                                                                <input type="text" class="form-control" name="prodId" id="prodId-<%= i%>" 
                                                                       value="<%= product.getProdId()%>" disabled/>
                                                            </div>
                                                            <!-- PRODUCT NAME -->
                                                            <div class="mb-3">
                                                                <label for="prodName-<%= i%>">Nome <small><i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" title="Campo obrigatório"></i></small></label>
                                                                <input type="text" class="form-control" name="prodName" id="prodName-<%= i%>" 
                                                                       value="<%= product.getProdName()%>" required/>
                                                            </div>
                                                            <!-- PRODUCT BRAND -->
                                                            <div class="mb-3">
                                                                <label for="prodBrand-<%= i%>">Marca <small><i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" title="Campo obrigatório"></i></small></label>
                                                                <select class="form-control" name="prodBrand" id="prodBrand-<%= i%>">
                                                                    <% ArrayList<String> brandNamesEdit = Brand.getBrandNames();
                                                                        for (int k = 0; k < brandNamesEdit.size(); k++) {
                                                                            if (brandNamesEdit.get(k).equals(product.getProdBrand())) {%>
                                                                                <option value="<%=brandNamesEdit.get(k)%>" selected><%=brandNamesEdit.get(k)%></option>
                                                                            <%} else {%>
                                                                                <option value="<%=brandNamesEdit.get(k)%>"><%=brandNamesEdit.get(k)%></option>
                                                                        <%}}%>
                                                                </select>
                                                            </div>
                                                            <!-- PRODUCT MATERIAL -->
                                                            <div class="mb-3">
                                                                <label for="prodMaterial-<%= i%>">Material</label>
                                                                <input type="text" class="form-control" name="prodMaterial" id="prodMaterial-<%= i%>" 
                                                                       value="<%= product.getProdMaterial()%>"/>
                                                            </div>
                                                            <!-- PRODUCT SIZE -->
                                                            <div class="mb-3">
                                                                <label for="prodSize-<%= i%>">Tamanho</label>
                                                                <input type="text" class="form-control" name="prodSize" id="prodSize-<%= i%>" 
                                                                       value="<%= product.getProdSize()%>"/>
                                                            </div>
                                                            <!-- PRODUCT AVG VALUE -->
                                                            <div class="mb-3">
                                                                <label for="prodAvg-<%= i%>">Valor Médio</label>
                                                                <input type="number" class="form-control" name="prodAvgValue" id="prodAvgValue-<%= i%>" 
                                                                       value="<%= product.getProdAvg()%>" disabled/>
                                                            </div>
                                                            <!-- PRODUCT QUANTITY -->
                                                            <div class="mb-3">
                                                                <label for="movQnt-<%= i%>">Quantidade</label>
                                                                <input type="number" class="form-control" name="movQuantity" id="movQuantity-<%= i%>" 
                                                                       value="<%= product.getProdQnt()%>" disabled/>
                                                            </div>
                                                        </div>
                                                        <!-- PRODUCT SAVE AND CANCEL BUTTON -->
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                            <input type="hidden" name="prodId" value="<%= product.getProdId()%>"/>
                                                            <input type="submit" name="edit" value="Salvar" class="btn btn-primary">
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <% } %>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <!-- NAVEGATION BUTTONS -->
                    <% 
                    int actualPage = 1;
                    if(request.getParameter("page")!=null){
                    actualPage = Integer.parseInt(request.getParameter("page"));
                    }
                   
                    int prevPage = actualPage - 1;
                    int nxtPage = actualPage + 1;
                    
                    if(prevPage < 1)prevPage = 1;
                    if(nxtPage > pageProd)nxtPage = pageProd;
                    %>
                    <nav aria-label="Page navigation example">
                        <ul class="pagination">
                            <li class="page-item">
                              <a class="page-link" href="products.jsp?page=<%=prevPage%>" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                              </a>
                            </li>
                            <%for(int k = 1; k <= pageProd; k++){%>
                            <li class="page-item"><a class="page-link" href="products.jsp?page=<%=k%>"><%=k%></a></li>
                            <%}%>
                            <li class="page-item">
                                <a class="page-link" href="products.jsp?page=<%=nxtPage%>" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
            <% }%>
        </div>
        <!-- TOOLTIP -->
        <script>
            $(function () {
            $('[data-toggle="tooltip"]').tooltip()})
        </script>
        <!-- CONFIRM DELETE -->
        <script src="scripts/confirmDel.js"></script>
    </body>
</html>
