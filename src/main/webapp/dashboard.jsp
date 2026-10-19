<%-- 
    Document   : dashboard
    Created on : 19 oct 2026, 7:53:42
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Cita"%>
<%@page import="model.Usuario"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Se obtiene o inicializa la lista de citas totalmente VACÍA
    List<Cita> listaCitas = (List<Cita>) application.getAttribute("listaCitas");
    if (listaCitas == null) {
        listaCitas = new ArrayList<>();
        application.setAttribute("listaCitas", listaCitas);
        application.setAttribute("contadorId", 1);
    }

    int citasProgramadas = 0;
    int pacientesAtendidos = 0;
    for (Cita c : listaCitas) {
        if ("Pendiente".equalsIgnoreCase(c.getEstado())) citasProgramadas++;
        if ("Atendida".equalsIgnoreCase(c.getEstado())) pacientesAtendidos++;
    }

    String vista = request.getParameter("vista");
    if (vista == null) vista = "panel";
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Clínica Ricardo Palma - Sistema de Gestión</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .navbar-custom { background-color: #0d6efd; }
        .sidebar { min-height: calc(100vh - 56px); background-color: #ffffff; border-right: 1px solid #dee2e6; }
        .sidebar .nav-link { color: #333; font-weight: 500; border-radius: 6px; margin-bottom: 4px; }
        .sidebar .nav-link.active { background-color: #e7f1ff; color: #0d6efd; }
        .card-stat { border-radius: 12px; border: none; }
    </style>
</head>
<body>

    <!-- Header Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom px-4">
        <a class="navbar-brand fw-bold" href="dashboard.jsp?vista=panel">
            <i class="bi bi-hospital me-2"></i>Clínica Ricardo Palma
        </a>
        <div class="ms-auto d-flex align-items-center text-white">
            <i class="bi bi-person-circle me-2"></i>
            <span class="me-3"><%= usuario.getNombre() %> (<%= usuario.getRol() %>)</span>
            <a href="LoginServlet?action=logout" class="btn btn-sm btn-outline-light">
                <i class="bi bi-box-arrow-right me-1"></i>Salir
            </a>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            
            <!-- Sidebar Navigation -->
            <nav class="col-md-3 col-lg-2 sidebar p-3">
                <h6 class="text-uppercase text-muted fw-bold small mb-3">Menú Principal</h6>
                <ul class="nav nav-pills flex-column">
                    <li class="nav-item">
                        <a class="nav-link <%= "panel".equals(vista) ? "active" : "" %>" href="dashboard.jsp?vista=panel">
                            <i class="bi bi-house-door me-2"></i>Panel General
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= "citas".equals(vista) ? "active" : "" %>" href="dashboard.jsp?vista=citas">
                            <i class="bi bi-calendar-check me-2"></i>Gestión de Citas
                        </a>
                    </li>
                </ul>
            </nav>

            <!-- Main Content Area -->
            <main class="col-md-9 col-lg-10 p-4">

                <% if ("panel".equals(vista)) { %>
                    <!-- PANEL GENERAL -->
                    <h2 class="fw-bold mb-4">Panel de Control General</h2>
                    <div class="row g-3">
                        <div class="col-md-6 col-lg-4">
                            <div class="card card-stat bg-primary text-white p-3 shadow-sm">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="card-title text-uppercase mb-1">Citas Programadas</h6>
                                        <h1 class="display-4 fw-bold mb-0"><%= citasProgramadas %></h1>
                                    </div>
                                    <i class="bi bi-calendar-event display-4 opacity-50"></i>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <div class="card card-stat bg-success text-white p-3 shadow-sm">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="card-title text-uppercase mb-1">Pacientes Atendidos</h6>
                                        <h1 class="display-4 fw-bold mb-0"><%= pacientesAtendidos %></h1>
                                    </div>
                                    <i class="bi bi-person-check display-4 opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card mt-4 shadow-sm border-0">
                        <div class="card-body">
                            <h5 class="card-title fw-bold">Bienvenido al Sistema Médico de la Clínica Ricardo Palma</h5>
                            <p class="card-text text-muted">Utilice el menú lateral para gestionar las citas médicas de las distintas especialidades, verificar disponibilidad y actualizar el estado de atención de los pacientes.</p>
                            <a href="dashboard.jsp?vista=citas" class="btn btn-primary"><i class="bi bi-plus-circle me-1"></i> Ir a Gestión de Citas</a>
                        </div>
                    </div>

                <% } else if ("citas".equals(vista)) { %>
                    <!-- MÓDULO DE GESTIÓN DE CITAS -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold mb-0">Gestión de Citas Médicas</h2>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalNuevaCita">
                            <i class="bi bi-calendar-plus me-1"></i>Agendar Nueva Cita
                        </button>
                    </div>

                    <!-- Tabla de Citas -->
                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>#</th>
                                            <th>Paciente</th>
                                            <th>DNI</th>
                                            <th>Especialidad</th>
                                            <th>Médico</th>
                                            <th>Fecha / Hora</th>
                                            <th>Estado</th>
                                            <th class="text-center">Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (listaCitas.isEmpty()) { %>
                                            <tr>
                                                <td colspan="8" class="text-center py-4 text-muted">
                                                    <i class="bi bi-inbox display-6 d-block mb-2"></i>
                                                    No hay citas registradas. Utilice el botón <strong>"Agendar Nueva Cita"</strong> para agregar la primera.
                                                </td>
                                            </tr>
                                        <% } else { 
                                            for (Cita c : listaCitas) { %>
                                            <tr>
                                                <td><strong>#<%= c.getId() %></strong></td>
                                                <td><%= c.getPaciente() %></td>
                                                <td><%= c.getDni() %></td>
                                                <td><span class="badge bg-info text-dark"><%= c.getEspecialidad() %></span></td>
                                                <td><%= c.getMedico() %></td>
                                                <td><%= c.getFecha() %> - <%= c.getHora() %></td>
                                                <td>
                                                    <% if ("Pendiente".equalsIgnoreCase(c.getEstado())) { %>
                                                        <span class="badge bg-warning text-dark">Pendiente</span>
                                                    <% } else if ("Atendida".equalsIgnoreCase(c.getEstado())) { %>
                                                        <span class="badge bg-success">Atendida</span>
                                                    <% } else { %>
                                                        <span class="badge bg-secondary">Cancelada</span>
                                                    <% } %>
                                                </td>
                                                <td class="text-center">
                                                    <% if ("Pendiente".equalsIgnoreCase(c.getEstado())) { %>
                                                        <a href="CitaServlet?accion=atender&id=<%= c.getId() %>" class="btn btn-sm btn-outline-success me-1" title="Marcar Atendida">
                                                            <i class="bi bi-check-circle"></i>
                                                        </a>
                                                        <a href="CitaServlet?accion=cancelar&id=<%= c.getId() %>" class="btn btn-sm btn-outline-warning me-1" title="Cancelar Cita">
                                                            <i class="bi bi-x-circle"></i>
                                                        </a>
                                                    <% } %>
                                                    <a href="CitaServlet?accion=eliminar&id=<%= c.getId() %>" class="btn btn-sm btn-outline-danger" title="Eliminar" onclick="return confirm('¿Seguro de eliminar la cita?');">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        <%  } 
                                           } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Modal Agendar Nueva Cita -->
                    <div class="modal fade" id="modalNuevaCita" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <form action="CitaServlet" method="POST">
                                    <div class="modal-header bg-primary text-white">
                                        <h5 class="modal-title fw-bold"><i class="bi bi-calendar-plus me-2"></i>Agendar Nueva Cita</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label class="form-label">Nombre del Paciente</label>
                                            <input type="text" name="paciente" class="form-control" placeholder="Ej: Juan Pérez" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">DNI</label>
                                            <input type="text" name="dni" class="form-control" placeholder="Ej: 71234567" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Especialidad Ricardo Palma</label>
                                            <select name="especialidad" class="form-select" required>
                                                <option value="" selected disabled>-- Seleccione Especialidad --</option>
                                                <option value="Cardiología">Cardiología</option>
                                                <option value="Pediatría">Pediatría</option>
                                                <option value="Medicina General">Medicina General</option>
                                                <option value="Traumatología">Traumatología</option>
                                                <option value="Dermatología">Dermatología</option>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Médico Especialista</label>
                                            <select name="medico" class="form-select" required>
                                                <option value="" selected disabled>-- Seleccione Médico --</option>
                                                <option value="Dr. Carlos Mendoza">Dr. Carlos Mendoza (Cardiología)</option>
                                                <option value="Dra. Ana Torres">Dra. Ana Torres (Pediatría)</option>
                                                <option value="Dr. Luis Silva">Dr. Luis Silva (Medicina General)</option>
                                                <option value="Dr. Roberto Gómez">Dr. Roberto Gómez (Traumatología)</option>
                                                <option value="Dra. Lucía Vargas">Dra. Lucía Vargas (Dermatología)</option>
                                            </select>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Fecha</label>
                                                <input type="date" name="fecha" class="form-control" required>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Hora</label>
                                                <input type="time" name="hora" class="form-control" required>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                        <button type="submit" class="btn btn-primary">Agendar Cita</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                <% } %>

            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>