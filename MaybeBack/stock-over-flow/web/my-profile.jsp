<%-- 
    Document   : my-profile
    Created on : 2 de mar. de 2022, 17:56:21
    Author     : spbry
--%>

<%@page import="mail.SendEmail"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestError = null;
    try {
        //CHANGE PASSWORD
        if (request.getParameter("changePassword") != null) {
            String login = (String) session.getAttribute("loggedUser.userEmail");
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmNewPassword = request.getParameter("confirmNewPassword");
            if (User.getUser(login, currentPassword) == null) {
                requestError = "Senha atual inválida!";
            } else if (!newPassword.equals(confirmNewPassword)) {
                requestError = "Confirmação de nova senha inválida!";
            } else {
                User.changePassword(login, newPassword);
                
                SendEmail pswInstance = new SendEmail();
                
                boolean pswSent = pswInstance.sendPassword(login, confirmNewPassword);
                response.sendRedirect(request.getRequestURI());
            }
        }
        
    } catch (Exception ex) {
        requestError = ex.getLocalizedMessage();
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Meu perfil</title>
        <link rel="icon" type="image/x-icon" href="images/Stock2Flow.svg">
        <%@include file="WEB-INF/jspf/bootstrap-header.jspf" %>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <div class="container-fluid mt-2">
            <% if (requestError != null) {%>
            <div class="alert alert-danger" role="alert">
                <%= requestError%>
            </div>
            <% } %>
            <% if (sessionUserEmail != null && sessionUserVerified == true) {%>
            <div class="card">
                <div class="card-body">
                    <h2>Meu perfil</h2>
                </div>
                <!-- FORM PROFILE -->
                <div class="container-fluid">
                    <form class="row g-3">
                        <div class="col-md-4">
                        <!-- PROFILE NAME -->
                            <label for="sessionUserName" class="form-label">Name</label>
                            <input type="text" class="form-control" id="sessionUserName" value="<%= sessionUserName%>" readonly>
                        </div>
                        <!-- PROFILE EMAIL -->
                        <div class="col-md-4">
                            <label for="sessionUserEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="sessionUserEmail" value="<%= sessionUserEmail%>" readonly>
                        </div>
                        <!-- PROFILE ROLE -->
                        <div class="col-md-4">
                            <label for="sessionUserRole" class="form-label">Função</label>
                            <input type="text" class="form-control" id="sessionUserRole" value="<%= sessionUserRole%>" readonly>
                        </div>
                    </form>
                    <!-- FORM CHANGE PASSWORD -->
                    <h3 class="mt-4">Alterar senha</h3>
                    <form class="row g-3" method="post">
                        <!-- PROFILE PASSWORD -->
                        <div class="col-md-4">
                            <label for="currentPassword" class="form-label">Senha atual</label>
                            <input type="password" class="form-control" name="currentPassword" id="currentPassword">
                        </div>
                        <!-- PROFILE NEW PASSWORD -->
                        <div class="col-md-4">
                            <label for="newPassword" class="form-label">Nova senha</label>
                            <input type="password" class="form-control" name="newPassword" id="newPassword" required>
                        </div>
                        <!-- PROFILE CONFIRM NEW PASSWORD -->
                        <div class="col-md-4">
                            <label for="confirmNewPassord" class="form-label">Confirmação da nova senha</label>
                            <input type="password" class="form-control" name="confirmNewPassword" id="confirmNewPassword" required>
                        </div>
                        <!-- BUTTON CONFIRM CHANGE PASSWORD -->
                        <div class="col-md-12 mb-2">
                            <button type="submit" name="changePassword" class="btn btn-lg btn-primary">Confirmar</button>
                        </div>
                    </form>
                </div>
            </div>
            <% }%>
        </div>
    </body>
</html>
