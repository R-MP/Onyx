<%-- 
    Document   : providers
    Created on : 2 de mar. de 2022, 19:05:37
    Author     : spbry
--%>

<%@page import="db.Provider"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestError = null;
    ArrayList<Provider> providers = new ArrayList<>();
    int pgNum = 0;
    if(session.getAttribute("provPage") != null)pgNum = ((Integer)session.getAttribute("provPage")-1)*10;
    int qtdProv = Provider.getAll();
    String bySrc = (String) session.getAttribute("provSearch");
    if(bySrc==null)bySrc="";
    else qtdProv = Provider.getSearchPage(bySrc);
    String byOrd = (String) session.getAttribute("provOrder");
    Boolean isDeleted = (Boolean) session.getAttribute("checkProviders");
    if(isDeleted == null)isDeleted = false;
    if((String) session.getAttribute("provSearch")!=null){
    bySrc = (String) session.getAttribute("provSearch");
    }
    try {
    
        //ADD PROVIDER
        if (request.getParameter("insert") != null) {
            String provName = request.getParameter("provName");
            String provLocation = request.getParameter("provLocation");
            String provTelephone = request.getParameter("provTelephone");
            String provMail = request.getParameter("provMail");
            Provider.insertProvider(provName, provLocation, provTelephone, provMail);
            response.sendRedirect(request.getRequestURI());
            
        //EDIT PROVIDER
        } else if (request.getParameter("edit") != null) {
            String oldProvName = request.getParameter("oldProvName");
            String provName = request.getParameter("provName");
            String provLocation = request.getParameter("provLocation");
            String provTelephone = request.getParameter("provTelephone");
            String provMail = request.getParameter("provMail");
            Provider.alterProvider(oldProvName, provName, provLocation, provTelephone, provMail);
            response.sendRedirect(request.getRequestURI());
            
        //DELETE PROVIDER
        } else if (request.getParameter("delete") != null) {
            String provName = request.getParameter("provName");
            Provider.deleteProvider(provName);
            session.setAttribute("checkProviders",true);
            response.sendRedirect(request.getRequestURI());
        }
        
        //PAGE PROCIDER
        if (request.getParameter("page") != null) {
            pgNum = Integer.parseInt(request.getParameter("page"));
            session.setAttribute("provPage",pgNum);
            pgNum = (pgNum-1)*10;
        }
        
        //SEARCH PROVIDER
        if (request.getParameter("srcFilter")!= null){
            bySrc = request.getParameter("searchFor");
            qtdProv = Provider.getSearchPage(bySrc);
            session.setAttribute("provSearch", bySrc);
            session.removeAttribute("movPage");
            response.sendRedirect(request.getRequestURI());
        }
        
        //ORDER PROVIDER
        if (request.getParameter("orderColumn")!= null){
            byOrd = request.getParameter("orderColumn");
            session.setAttribute("provOrder", byOrd);
            response.sendRedirect(request.getRequestURI());
        }
        
        //CLEAR SEARCH PROVIDER
        if(request.getParameter("clearFilter") != null) {
            session.removeAttribute("provSearch");
            bySrc = "";
            response.sendRedirect(request.getRequestURI());
        }
        
    } catch (Exception ex) {
        requestError = ex.getLocalizedMessage();
    }
    int pageProv = (int) Math.ceil((double)qtdProv/10);
    providers = Provider.getPageOrderBy(pgNum, byOrd, bySrc);
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Fornecedores</title>
        <link rel="icon" type="image/x-icon" href="images/Stock2Flow.svg">
        <%@include file="WEB-INF/jspf/bootstrap-header.jspf" %>
        <%@include file="WEB-INF/jspf/jquery-header.jspf" %>
        <%@include file="WEB-INF/jspf/datatable-header.jspf" %>
        <%@include file="WEB-INF/jspf/sweetalert-header.jspf" %>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <%if(isDeleted == true){
          session.setAttribute("checkProviders", false);%>
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
                    <h2>Fornecedores (<%= qtdProv%>)
                        <% if (sessionUserRole.equals("Admin")) {%>
                        <!-- BUTTON ADD PROVIDER -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#add">
                            <i class="bi bi-plus-lg"></i>
                        </button>
                        <% } %>
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
                    <!-- ADD PROVIDER SCREEN -->
                    <div class="modal fade" id="add" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <form enctype="application/x-www-form-urlencoded" method="post">
                                    <div class="modal-body">
                                        <!-- PROVIDER NAME -->
                                        <div class="mb-3">
                                            <label for="provName">Nome  <small><i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" title="Campo obrigatório"></i></small></label>
                                            <input type="text" class="form-control" name="provName" id="provName" required/>
                                        </div>
                                        <!-- PROVIDER LOCATION -->
                                        <div class="mb-3">
                                            <label for="provLocation">Endereço</label>
                                            <input type="text" class="form-control" name="provLocation" id="provLocation"/>
                                        </div>
                                        <!-- PROVIDER TELEPHONE -->
                                        <div class="mb-3">
                                            <label for="provTelephone">Telefone</label>
                                            <input type="tel" class="form-control" name="provTelephone" id="provTelephone"/>
                                        </div>
                                        <!-- PROVIDER EMAIL -->
                                        <div class="mb-3">
                                            <label for="provMail">E-mail</label>
                                            <input type="email" class="form-control" name="provMail" id="provMail"/>
                                        </div>
                                    </div>
                                    <!-- PROVIDER SAVE AND CANCEL BUTTON -->
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
                    <!-- PROVIDER MAIN TABLE -->
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead class="bg-light">
                                <tr>
                                    <th>
                                        <form method="post">
                                            Nome 
                                            <input type="hidden" name="orderColumn" value="provName">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <th>
                                        <form method="post">
                                            Endereço
                                            <input type="hidden" name="orderColumn" value="provLocation">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <th>
                                        <form method="post">
                                            Telefone 
                                            <input type="hidden" name="orderColumn" value="provTelephone">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <th>
                                        <form method="post">
                                            Email 
                                            <input type="hidden" name="orderColumn" value="provMail">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form></th>
                                    <th>Produtos (Estoque)</th>
                                        <% if (sessionUserRole.equals("Admin")) {%><th></th><% } %>
                                </tr>
                            </thead>
                            <tbody>
                                <% int i = 0; 
                                   for (Provider provider : providers) { 
                                   i++; %>
                                <tr>
                                    <td><%= provider.getProvName()%></td>
                                    <td><%= provider.getProvLocation()%></td>
                                    <td><%= provider.getProvTelephone()%></td>
                                    <td><%= provider.getProvMail()%></td>
                                    <td><%= Provider.getProvQnt(provider.getProvName())%></td>
                                    <% if (sessionUserRole.equals("Admin")) {%>
                                    <td>
                                        <form name="objAlter" id="objAlter-<%= i%>" enctype="application/x-www-form-urlencoded" method="post" onsubmit="validateAlert(<%= i%>, this)">
                                            <!-- BUTTON EDIT & DELETE PROVIDER -->
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#edit-<%= i%>">
                                                <i class="bi bi-pencil-square"></i></button>
                                            <input type="hidden" name="provName" value="<%= provider.getProvName()%>"/>
                                            <input type="hidden" name="delete" value="del"/>
                                            <button type="submit" name="delete" class="btn btn-danger btn-sm">
                                                <i class="bi bi-trash3"></i></button>
                                        </form>
                                        <!-- EDIT PROVIDER SCREEN -->
                                        <div class="modal fade" id="edit-<%= i%>" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content">
                                                    <form enctype="application/x-www-form-urlencoded" method="post">
                                                        <div class="modal-body">
                                                            <!-- PROVIDER NAME -->
                                                            <div class="mb-3">
                                                                <label for="provName-<%= i%>">Nome  <small><i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" title="Campo obrigatório"></i></small></label>
                                                                <input type="text" class="form-control" name="provName" id="provName-<%= i%>" 
                                                                       value="<%= provider.getProvName()%>" required/>
                                                            </div>
                                                            <!-- PROVIDER LOCATION -->
                                                            <div class="mb-3">
                                                                <label for="provLocation-<%= i%>">Endereço</label>
                                                                <input type="text" class="form-control" name="provLocation" id="provLocation-<%= i%>" 
                                                                       value="<%= provider.getProvLocation()%>"/>
                                                            </div>
                                                            <!-- PROVIDER TELEPHONE -->
                                                            <div class="mb-3">
                                                                <label for="provTelephone-<%= i%>">Telefone</label>
                                                                <input type="tel" class="form-control" name="provTelephone" id="provTelephone-<%= i%>" 
                                                                       value="<%= provider.getProvTelephone()%>"/>
                                                            </div>
                                                            <!-- PROVIDER EMAIL -->
                                                            <div class="mb-3">
                                                                <label for="provMail-<%= i%>">E-mail</label>
                                                                <input type="email" class="form-control" name="provMail" id="provMail-<%= i%>" 
                                                                       value="<%= provider.getProvMail()%>"/>
                                                            </div>
                                                            <!-- PROVIDER STOCK QUANTITY -->
                                                            <div class="mb-3">
                                                                <label for="provQnt-<%= i%>">Produto (Estoque)</label>
                                                                <input type="text" class="form-control" name="provQnt" id="provQnt-<%= i%>" 
                                                                       value="<%= Provider.getProvQnt(provider.getProvName())%>" disabled/>
                                                            </div>
                                                        </div>
                                                        <!-- PROVIDER SAVE AND CANCEL BUTTON -->
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                            <input type="hidden" name="oldProvName" value="<%= provider.getProvName()%>"/>
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
                    if(nxtPage > pageProv)nxtPage = pageProv;
                    %>
                    <nav aria-label="Page navigation example">
                        <ul class="pagination">
                            <li class="page-item">
                              <a class="page-link" href="providers.jsp?page=<%=prevPage%>" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                              </a>
                            </li>
                            <%for(int k = 1; k <= pageProv; k++){%>
                            <li class="page-item"><a class="page-link" href="providers.jsp?page=<%=k%>"><%=k%></a></li>
                            <%}%>
                            <li class="page-item">
                                <a class="page-link" href="providers.jsp?page=<%=nxtPage%>" aria-label="Next">
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
