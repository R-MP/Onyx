<%-- 
    Document   : movements
    Created on : 2 de mar. de 2022, 19:53:47
    Author     : spbry
--%>

<%@page import="java.net.URLDecoder"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="javax.script.ScriptEngine"%>
<%@page import="javax.script.ScriptEngineManager"%>
<%@page import="javax.script.ScriptException"%>
<%@page import="java.io.Reader"%>
<%@page import="db.Provider"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="db.Movement"%>
<%@page import="db.Product"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestError = null;
    ArrayList<Movement> movements = new ArrayList<>();
    int pgNum = 0;
    if(session.getAttribute("movPage") != null)pgNum = ((Integer)session.getAttribute("movPage")-1)*10;
    int qtdMov = Movement.getAll();
    String bySrc = (String) session.getAttribute("movSearch");
    if(bySrc==null)bySrc="";
    else qtdMov = Movement.getSearchPage(bySrc);
    String byOrd = (String) session.getAttribute("movOrder");
    if(byOrd==null)byOrd="movId";
    Boolean isDeleted = (Boolean) session.getAttribute("checkMovements");
    if(isDeleted == null)isDeleted = false;
    
    
    try {
        //ADD MOVEMENT
        if (request.getParameter("insert") != null) {
            int movProd = Integer.parseInt(request.getParameter("movProd"));
            String movOp = (String) session.getAttribute("loggedUser.userName");
            String movProv = request.getParameter("movProv");
            String movType = request.getParameter("movType");
            int movQnt = Integer.parseInt(request.getParameter("movQnt"));
            Double movValue = Double.parseDouble(request.getParameter("movValue"));
            String movDesc = request.getParameter("movDesc");
            if (movType.equals("Entrada")) movQnt = Math.abs(movQnt);
            else if (movType.equals("  Saída")) movQnt = -movQnt;  
            Movement.insertMovement(movProd, movOp, movProv, movType, movQnt, movValue, movDesc);
            response.sendRedirect(request.getRequestURI());
            
        //EDIT MOVEMENT
        } else if (request.getParameter("edit") != null) {
            int movId = Integer.parseInt(request.getParameter("movId"));
            int movProd = Integer.parseInt(request.getParameter("movProd"));
            String movProv = request.getParameter("movProv");
            String movType = request.getParameter("movType");
            int movQnt = Integer.parseInt(request.getParameter("movQnt"));
            Double movValue = Double.parseDouble(request.getParameter("movValue"));
            String movDesc = request.getParameter("movDesc");
            if (movType.equals("Entrada")) movQnt = Math.abs(movQnt);
            else if (movType.equals("  Saída")) movQnt = -(Math.abs(movQnt)); 
            
            Movement.alterMovement(movId, movProd, movProv, movType, movQnt, movValue, movDesc);
            response.sendRedirect(request.getRequestURI());
        
        //DELETE MOVEMENT
        } else if (request.getParameter("delete") != null) {
            int movId = Integer.parseInt(request.getParameter("movId"));
            Movement.deleteMovement(movId);
            session.setAttribute("checkMovements",true);
            response.sendRedirect(request.getRequestURI());
            
        //GENERATE REPORT
        } else if (request.getParameter("report") != null) {
            movements = Movement.getMovements();
            Movement.generateReport(movements, response);
            response.sendRedirect(request.getRequestURI());
        }
        
        //PAGE MOVEMENT
        if (request.getParameter("page") != null) {
            pgNum = Integer.parseInt(request.getParameter("page"));
            session.setAttribute("movPage",pgNum);
            pgNum = (pgNum-1)*10;
        }
        
        //SEARCH MOVEMENT
        if (request.getParameter("srcFilter")!= null){
            bySrc = request.getParameter("searchFor");
            qtdMov = Movement.getSearchPage(bySrc);
            session.setAttribute("movSearch", bySrc);
            session.removeAttribute("movPage");
            response.sendRedirect(request.getRequestURI());
        }
        
        //ORDER MOVEMENT
        if (request.getParameter("orderColumn")!= null){
            byOrd = request.getParameter("orderColumn");
            session.setAttribute("movOrder", byOrd);
            response.sendRedirect(request.getRequestURI());
        }
        
        //CLEAR SEARCH MOVEMENT
        if(request.getParameter("clearFilter") != null) {
            session.removeAttribute("movSearch");
            bySrc = "";
            response.sendRedirect(request.getRequestURI());
        }
        
    } catch (Exception ex) {
        requestError = ex.getLocalizedMessage();
    }
    int pageMov = (int) Math.ceil((double)qtdMov/10);
    movements = Movement.getPageOrderBy(pgNum, byOrd, bySrc);
    
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
       
        <title>Movimentações</title>
        <link rel="icon" type="image/x-icon" href="images/Stock2Flow.svg">
        <%@include file="WEB-INF/jspf/bootstrap-header.jspf" %>
        <%@include file="WEB-INF/jspf/jquery-header.jspf" %>
        <%@include file="WEB-INF/jspf/sweetalert-header.jspf" %>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <h1><%%></h1>
        <%if(isDeleted == true){
          session.setAttribute("checkMovements", false);
        %>
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
                    <h2>Movimentações (<%=qtdMov%>)
                        <!-- BUTTON ADD MOVEMENTS -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#add">
                            <i class="bi bi-plus-lg"></i>
                        </button>
                        <% if (sessionUserRole.equals("Admin")) {%>
                        <!-- BUTTON GENERATE REPORT -->
                        <form method="post" class="d-inline">
                            <button type="submit" name="report" class="btn btn-primary">
                                <i class="bi bi-filetype-pdf"></i>
                            </button>
                        </form>
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
                    <!-- ADD MOVEMENT SCREEN -->
                    <div class="modal fade" id="add" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <form name="newMovement" id="movForm" enctype="application/x-www-form-urlencoded" method="post">
                                    <div class="modal-body">
                                        
                                        <!-- MOVEMENT PRODUCT -->
                                        <div class="mb-3">
                                            <label for="movProd">Produto <small><i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" title="Campo obrigatório"></i></small></label>
                                            <select class="form-control" name="movProd" id="movProd">
                                                <%  
                                                    ArrayList<Integer> prodIds = Product.getProdIds();
                                                    if(prodIds.size() > 0){
                                                    for (int j = 0; j < prodIds.size(); j++) {%>
                                                <option value="<%=prodIds.get(j)%>"><%=Product.getProdNameById(prodIds.get(j))%></option>
                                                <%}}else{%>
                                                <option value="errorCode:notSelected" disabled selected hidden>Sem produtos cadastrados</option>
                                                <%}%>
                                                <option value="errorCode:notSelected" disabled selected hidden>---</option>
                                            </select>
                                        </div>
                                        <!-- MOVEMENT PROVIDER -->
                                        <div class="mb-3">
                                            <label for="movProv">Fornecedor <small><i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" title="Campo obrigatório"></i></small></label>
                                            <select class="form-control" name="movProv" id="movProv">
                                                <%
                                                    ArrayList<String> provNames = Provider.getProvNames();
                                                    if(provNames.size() > 0){
                                                    for (int k = 0; k < provNames.size(); k++) {%>
                                                <option value="<%=provNames.get(k)%>"><%=provNames.get(k)%></option>
                                                <%}}else{%>
                                                <option value="errorCode:notSelected" disabled selected hidden>Sem fornecedores disponíveis</option>
                                                <%}%>
                                                <option value="errorCode:notSelected" disabled selected hidden>---</option>
                                            </select>
                                        </div>
                                        <!-- MOVEMENT TYPE -->
                                        <div class="mb-3">
                                            <label for="movType">Tipo de Movimentação <small><i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" title="Campo obrigatório"></i></small></label>
                                            <select class="form-control" name="movType" id="movType">
                                                <%String codType = URLDecoder.decode(" Saída", StandardCharsets.UTF_8);%>
                                                <option value="<%=codType%>">  Saída</option>
                                                <option value="Entrada">Entrada</option>
                                                <option value="errorCode:notSelected" disabled selected hidden>---</option>
                                            </select>
                                        </div>
                                        <!-- MOVEMENT QUANTITY -->
                                        <div class="mb-3">
                                            <label for="movQnt">Quantidade <small><i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" title="Campo obrigatório"></i></small></label>
                                            <input type="number" step=any min="0" class="form-control" name="movQnt" id="movQnt" required/>
                                        </div>
                                        <!-- MOVEMENT VALUE -->
                                        <div class="mb-3">
                                            <label for="movValue">Valor <small><i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" title="Campo obrigatório"></i></small></label>
                                            <input type="number" step=any class="form-control" name="movValue" id="movValue"/>
                                        </div>
                                        <!-- MOVEMENT DESCRIPTION -->
                                        <div class="mb-3">
                                            <label for="movDesc">Descrição</label>
                                            <input type="text" class="form-control" name="movDesc" id="movDesc"/>
                                        </div>
                                        <div id="errorShow" style="color:red;" class="mb-3"></div>
                                    </div>
                                    <!-- MOVEMENT SAVE AND CANCEL BUTTON -->
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
                    <!-- MOVEMENT MAIN TABLE -->
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead class="bg-light">
                                <tr>
                                    <th>
                                        <form method="post">
                                            ID 
                                            <input type="hidden" name="orderColumn" value="movId">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <th>
                                        <form method="post">
                                            Horário | Data
                                            <input type="hidden" name="orderColumn" value="movDate">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <th>
                                        <form method="post">
                                            Tipo de Movimentação
                                            <input type="hidden" name="orderColumn" value="movType">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <th>
                                        <form method="post">
                                            Produto
                                            <input type="hidden" name="orderColumn" value="movName">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <th>
                                        <form method="post">
                                            Operador
                                            <input type="hidden" name="orderColumn" value="movOp">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <th>
                                        <form method="post">
                                            Fornecedor
                                            <input type="hidden" name="orderColumn" value="movProv">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <th>
                                        <form method="post">
                                            Quantidade
                                            <input type="hidden" name="orderColumn" value="movQnt">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <th>
                                        <form method="post">
                                            Valor
                                            <input type="hidden" name="orderColumn" value="movValue">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <th>
                                        <form method="post">
                                            Descrição
                                            <input type="hidden" name="orderColumn" value="movDesc">
                                            <button type="submit" class="btn btn-sm btn-link">
                                                <i class="bi bi-caret-down-fill"></i>
                                            </button>
                                        </form>
                                    </th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <% int i = 0; 
                                   for (Movement movement : movements) { 
                                   i++; %>
                                <tr>
                                    <td><%= movement.getMovId()%></td>
                                    <td><%= movement.getMovDate()%></td>
                                    <td><%= movement.getMovType()%></td>
                                    <td><%= movement.getMovName()%></td>
                                    <td><%= movement.getMovOp()%></td>
                                    <td><%= movement.getMovProv()%></td>
                                    <%if (movement.getMovQnt() > 0) {%> <td style="color:green;"><%= movement.getMovQnt()%></td>
                                    <%}else if (movement.getMovQnt() < 0) {%> <td style="color:red;"><%= movement.getMovQnt()%></td>
                                    <%}else {%> <td style="color:blue;"><%= movement.getMovQnt()%></td><%}%>
                                    <td><%= movement.getMovValue()%></td>
                                    <td><%= movement.getMovDesc()%></td>
                                    <td>
                                        <form name="objAlter" id="objAlter-<%= i%>" enctype="application/x-www-form-urlencoded" method="post" onsubmit="validateAlert(<%= i%>, this)">
                                        <!-- BUTTON EDIT & DELETE MOVEMENT -->
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#edit-<%= i%>">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <input type="hidden" name="movId" value="<%= movement.getMovId()%>"/>
                                            <input type="hidden" name="delete" value="del"/>
                                            <button type="submit" name="delete" class="btn btn-danger btn-sm" value="del">
                                                <i class="bi bi-trash3"></i>
                                            </button>
                                        </form>
                                        <!-- EDIT MOVEMENT SCREEN -->
                                        <div class="modal fade" id="edit-<%= i%>" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content">
                                                    <form enctype="application/x-www-form-urlencoded" method="post">
                                                        <div class="modal-body">
                                                            <!-- MOVEMENT ID -->
                                                            <div class="mb-3">
                                                                <label for="movId-<%= i%>">ID</label>
                                                                <input type="text" class="form-control" name="movId" id="movId-<%= i%>" 
                                                                       value="<%= movement.getMovId()%>" disabled/>
                                                            </div>
                                                            <!-- MOVEMENT TIME/DATE -->
                                                            <div class="mb-3">
                                                                <label for="movDate-<%= i%>">Horário | Data</label>
                                                                <input type="text" class="form-control" name="movDate" id="movDate-<%= i%>" 
                                                                       value="<%= movement.getMovDate()%>" disabled/>
                                                            </div>
                                                            <!-- MOVEMENT PRODUCT -->
                                                            <div class="mb-3">
                                                                <label for="movProd-<%= i%>">Produto <small><i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" title="Campo obrigatório"></i></small></label>
                                                                <select class="form-control" name="movProd" id="movProd-<%= i%>">
                                                                    <% ArrayList<Integer> prodIdsEdit = Product.getProdIds();
                                                                    if(prodIdsEdit.size() > 0){
                                                                        for (int l = 0; l < prodIdsEdit.size(); l++) {
                                                                            if (prodIdsEdit.get(l).equals(movement.getMovProd())) {%>
                                                                                <option value="<%=prodIdsEdit.get(l)%>" selected><%=Product.getProdNameById(prodIdsEdit.get(l))%></option>
                                                                            <% } else {%>
                                                                                <option value="<%=prodIdsEdit.get(l)%>"><%=Product.getProdNameById(prodIdsEdit.get(l))%></option>
                                                                    <%}}}else{%>
                                                                                <option value="notFound">Seus produtos aparecerão aqui</option>
                                                                    <%}%>
                                                                </select>
                                                            </div>
                                                            <!-- MOVEMENT OPERATOR -->
                                                            <div class="mb-3">
                                                                <label for="movOp-<%= i%>">Operador</label>
                                                                <input type="text" class="form-control" name="movOp" id="movOp-<%= i%>" 
                                                                       value="<%= movement.getMovOp()%>" disabled/>
                                                            </div>
                                                            <!-- MOVEMENT PROVIDER -->
                                                            <div class="mb-3">
                                                                <label for="movProv-<%= i%>">Fornecedor <small><i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" title="Campo obrigatório"></i></small></label>
                                                                <select class="form-control" name="movProv" id="movProv-<%= i%>">
                                                                    <% ArrayList<String> provNamesEdit = Provider.getProvNames();
                                                                        for (int m = 0; m < provNamesEdit.size(); m++) {
                                                                            if (provNamesEdit.get(m).equals(movement.getMovProv())) {%>
                                                                                <option value="<%=provNamesEdit.get(m)%>" selected><%=provNamesEdit.get(m)%></option>
                                                                            <%} else {%>
                                                                                <option value="<%=provNamesEdit.get(m)%>"><%=provNamesEdit.get(m)%></option>
                                                                        <%}}%>
                                                                </select>
                                                            </div>
                                                            <!-- MOVEMENT TYPE -->
                                                            <div class="mb-3">
                                                                <label for="movType-<%= i%>">Tipo de Movimentação <small><i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" title="Campo obrigatório"></i></small></label>
                                                                <select class="form-control" name="movType" id="movType-<%= i%>">
                                                                    <% if (movement.getMovType().equals("  Saída")) { %>
                                                                    <option value="Saída" selected>Saída</option>
                                                                    <option value="Entrada">Entrada</option>
                                                                    <% } else { %>
                                                                    <option value="Saída"> Saída</option>
                                                                    <option value="Entrada" selected>Entrada</option>
                                                                    <% }%>
                                                                </select>
                                                            </div>
                                                            <!-- MOVEMENT QUANTITY -->
                                                            <div class="mb-3">
                                                                <label for="movQnt-<%= i%>">Quantidade <small><i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" title="Campo obrigatório"></i></small></label>
                                                                <input type="number" min="0" class="form-control" name="movQnt" id="movQnt-<%= i%>" 
                                                                       value="<%= Math.abs(movement.getMovQnt())%>" required/>
                                                            </div>
                                                            <!-- MOVEMENT VALUE -->
                                                            <div class="mb-3">
                                                                <label for="movValue-<%= i%>">Valor <small><i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" title="Campo obrigatório"></i></small></label>
                                                                <input type="number" min="0" step="0.01" class="form-control" name="movValue" id="movValue-<%= i%>" 
                                                                       value="<%= movement.getMovValue()%>" required/>
                                                            </div>
                                                            <!-- MOVEMENT AVG VALUE -->
                                                            <div class="mb-3">
                                                                <label for="movAvgValue-<%= i%>">Valor médio</label>
                                                                <input type="number" class="form-control" name="movAvgValue" id="movAvgValue-<%= i%>" 
                                                                       value="<%= Product.getAvg(movement.getMovProd())%>" disabled/>
                                                            </div>
                                                            <!-- MOVEMENT DESCRIPTION -->
                                                            <div class="mb-3">
                                                                <label for="movDesc-<%= i%>">Descrição</label>
                                                                <input type="text" class="form-control" name="movDesc" id="movDesc-<%= i%>" 
                                                                       value="<%= movement.getMovDesc()%>"/>
                                                            </div>
                                                        </div>
                                                        <!-- MOVEMENT SAVE AND CANCEL BUTTON -->
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                            <input type="hidden" name="movId" value="<%= movement.getMovId()%>"/>
                                                            <input type="submit" name="edit" value="Salvar" class="btn btn-primary">
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
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
                    if(nxtPage > pageMov)nxtPage = pageMov;
                    %>
                    <nav aria-label="Page navigation example">
                        <ul class="pagination">
                            <li class="page-item">
                              <a class="page-link" href="movements.jsp?page=<%=prevPage%>" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                              </a>
                            </li>
                            <%for(int k = 1; k <= pageMov; k++){%>
                            <li class="page-item"><a class="page-link" href="movements.jsp?page=<%=k%>"><%=k%></a></li>
                            <%}%>
                            <li class="page-item">
                                <a class="page-link" href="movements.jsp?page=<%=nxtPage%>" aria-label="Next">
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
        <!--VALIDATE FORM-->
        <script>
            $('#movForm').submit(validateForm);
            
            function validateForm(){
                var prodMv = document.forms["newMovement"]["movProd"].value;
                var provMv = document.forms["newMovement"]["movProv"].value;
                var typeMv = document.forms["newMovement"]["movType"].value;
                var qntMv = document.forms["newMovement"]["movQnt"].value;
                var valueMv = document.forms["newMovement"]["movValue"].value;
                
                const allProd = <%=Product.getProdIds()%>;
                
                var prodVerify = <%=Product.getProds()%>;
                
                    if (prodMv === "errorCode:notSelected"){
                        $("#errorShow").text("Produto não escolhido!");
                        return false;
                    }else if (provMv === "errorCode:notSelected"){
                        $("#errorShow").text("Fornecedor não escolhido!");
                        return false;
                    }else if (typeMv === "errorCode:notSelected"){
                        $("#errorShow").text("Tipo de movimentação não escolhido!");
                        return false;
                    }else if(qntMv % 1 != 0){
                        $("#errorShow").text("A quantidade precisa ser um valor inteiro!");
                        return false;
                    }else if(valueMv < 0){
                        $("#errorShow").text("Coloque um valor positivo!");
                        return false;
                    }else if(typeMv==="Saída" && qntMv > ){ //Movement.getQntById(prodMv)
                        $("#errorShow").text("Quantidade em estoque insuficiente!");
                        return false;
                    }else{
                        return true;
                    }
            }
        </script>
    </body>
</html>
