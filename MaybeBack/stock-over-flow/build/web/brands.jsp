<%-- 
    Document   : brands
    Created on : 2 de mar. de 2022, 17:51:42
    Author     : spbry
--%>

<%@page import="db.Brand"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestError = null;
    ArrayList<Brand> brands = new ArrayList<>();
    int pgNum = 0;
    if(session.getAttribute("brandPage") != null)pgNum = ((Integer)session.getAttribute("brandPage")-1)*10;
    int qtdBrand = Brand.getAll();
    String bySrc = (String) session.getAttribute("brandSearch");
    if(bySrc==null)bySrc="";
    else qtdBrand = Brand.getSearchPage(bySrc);
    Boolean isDeleted = (Boolean) session.getAttribute("checkBrands");
    if(isDeleted == null)isDeleted = false;
    String byOrd = (String) session.getAttribute("brandOrder");
   
    
    
    if((String) session.getAttribute("brandSearch")!=null){
    bySrc = (String) session.getAttribute("brandSearch");
    }
    try {
        //ADD BRAND
        if (request.getParameter("insert") != null) {
            String brandName = request.getParameter("brandName");
            String brandDesc = request.getParameter("brandDesc");
            Brand.insertBrand(brandName, brandDesc);
            response.sendRedirect(request.getRequestURI());
            
        //EDIT BRAND    
        } else if (request.getParameter("edit") != null) {
            String oldBrandName = request.getParameter("oldBrandName");
            String brandName = request.getParameter("brandName");
            String brandDesc = request.getParameter("brandDesc");
            Brand.alterBrand(oldBrandName, brandName, brandDesc);
            response.sendRedirect(request.getRequestURI());
            
        //DELETE BRAND
        } else if (request.getParameter("delete") != null) {
            String brandName = request.getParameter("brandName");
            Brand.deleteBrand(brandName);
            session.setAttribute("checkBrands",true);
            response.sendRedirect(request.getRequestURI());
        }    
        
        //PAGE BRAND
        if (request.getParameter("page") != null) {
            pgNum = Integer.parseInt(request.getParameter("page"));
            session.setAttribute("brandPage",pgNum);
            pgNum = (pgNum-1)*10;
        }
        
        //SEARCH BRAND
        if (request.getParameter("srcFilter")!= null){
            bySrc = request.getParameter("searchFor");
            qtdBrand = Brand.getSearchPage(bySrc);
            session.setAttribute("brandSearch", bySrc);
            session.removeAttribute("brandPage");
            response.sendRedirect(request.getRequestURI());
        }
        
        //ORDER BRAND
        if (request.getParameter("orderColumn")!= null){
            byOrd = request.getParameter("orderColumn");
            session.setAttribute("brandOrder", byOrd);
            response.sendRedirect(request.getRequestURI());
        }
        
        //CLEAR SEARCH BRAND
        if(request.getParameter("clearFilter") != null) {
            session.removeAttribute("brandSearch");
            bySrc = "";
            response.sendRedirect(request.getRequestURI());
        }
        
    } catch (Exception ex) {
        requestError = ex.getLocalizedMessage();
    }
    int pageBrand = (int) Math.ceil((double)qtdBrand/10);
    brands = Brand.getPageOrderBy(pgNum, byOrd, bySrc);
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Marcas</title>
        <link rel="icon" type="image/x-icon" href="images/Stock2Flow.svg">
        <%@include file="WEB-INF/jspf/bootstrap-header.jspf" %>
        <%@include file="WEB-INF/jspf/jquery-header.jspf" %>
        <%@include file="WEB-INF/jspf/datatable-header.jspf" %>
        <%@include file="WEB-INF/jspf/sweetalert-header.jspf" %>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <%if(isDeleted == true){
          session.setAttribute("checkBrands", false);%>
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
                    <h2>Marcas (<%= qtdBrand%>)
                        <% if (sessionUserRole.equals("Admin")) {%>
                        <!-- BUTTON ADD BRAND -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#add">
                            <i class="bi bi-plus-lg"></i>
                        </button>
                        <% } %>
                        <!-- FILTER INPUT -->
                        <div class="float-md-end h6">
                            <form enctype="application/x-www-form-urlencoded" method="post" class="input-group">
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
                    <!-- ADD BRAND SCREEN -->
                    <div class="modal fade" id="add" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <form enctype="application/x-www-form-urlencoded" method="post">
                                    <div class="modal-body">
                                        <!-- BRAND NAME -->
                                        <div class="mb-3">
                                            <label for="name">Nome <small><i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" title="Campo obrigatório"></i></small></label>
                                            <input type="text" class="form-control" name="brandName" id="brandName" required/>
                                        </div>
                                        <!-- BRAND DESCRIPTION -->
                                        <div class="mb-3">
                                            <label for="name">Descrição</label>
                                            <input type="text" class="form-control" name="brandDesc" id="brandDesc"/>
                                        </div>
                                    </div>
                                    <!-- BRAND SAVE AND CANCEL BUTTON -->
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                        <input type="submit" name="insert" value="Salvar" class="btn btn-primary">
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
                    <!-- BRAND MAIN TABLE -->
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead class="bg-light">
                                <tr>
                                    <th>
                                        <form method="post">
                                            Nome
                                            <input type="hidden" name="orderColumn" value="brandName">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form></th>
                                    <th>
                                        <form method="post">
                                            Descrição
                                            <input type="hidden" name="orderColumn" value="brandDesc">
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
                                   for (Brand brand : brands) { 
                                   i++; %>
                                <tr>
                                    <td><%= brand.getBrandName()%></td>
                                    <td><%= brand.getBrandDesc()%></td>
                                    <% if (sessionUserRole.equals("Admin")) {%>
                                    <td>
                                        <form name="objAlter" id="objAlter-<%= i%>" enctype="application/x-www-form-urlencoded" method="post" onsubmit="validateAlert(<%= i%>, this)">
                                            <!-- BUTTON EDIT & DELETE BRAND -->
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#edit-<%= i%>">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <input type="hidden" name="brandName" value="<%= brand.getBrandName()%>"/>
                                            <input type="hidden" name="delete" value="del"/>
                                            <button type="submit" name="delete" class="btn btn-danger btn-sm">
                                                <i class="bi bi-trash3"></i>
                                            </button>
                                        </form>
                                        <!-- EDIT BRAND SCREEN -->
                                        <div class="modal fade" id="edit-<%= i%>" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content">
                                                    <form enctype="application/x-www-form-urlencoded" method="post">
                                                        <div class="modal-body">
                                                            <!-- BRAND NAME -->
                                                            <div class="mb-3">
                                                                <label for="brandName-<%= i%>">Nome <small><i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" title="Campo obrigatório"></i></small></label>
                                                                <input type="text" class="form-control" name="brandName" id="brandName-<%= i%>" 
                                                                       value="<%= brand.getBrandName()%>"/>
                                                            </div>
                                                            <!-- BRAND DESCRIPTION -->
                                                            <div class="mb-3">
                                                                <label for="brandDesc-<%= i%>">Descrição</label>
                                                                <input type="text" class="form-control" name="brandDesc" id="brandDesc-<%= i%>" 
                                                                       value="<%= brand.getBrandDesc()%>"/>
                                                            </div>
                                                        </div>
                                                        <!-- BRAND SAVE AND CANCEL BUTTON -->
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                            <input type="hidden" name="oldBrandName" value="<%= brand.getBrandName()%>"/>
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
                    if(nxtPage > pageBrand)nxtPage = pageBrand;
                    %>
                    <nav aria-label="Page navigation example">
                        <ul class="pagination">
                            <li class="page-item">
                              <a class="page-link" href="brands.jsp?page=<%=prevPage%>" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                              </a>
                            </li>
                            <%for(int k = 1; k <= pageBrand; k++){%>
                            <li class="page-item"><a class="page-link" href="brands.jsp?page=<%=k%>"><%=k%></a></li>
                            <%}%>
                            <li class="page-item">
                                <a class="page-link" href="brands.jsp?page=<%=nxtPage%>" aria-label="Next">
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
