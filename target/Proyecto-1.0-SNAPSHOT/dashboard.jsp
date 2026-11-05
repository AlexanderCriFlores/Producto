<%-- 
    Document   : dashboard
    Created on : 19 oct 2026, 7:53:42
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Cita" %>
<%@ page import="model.Medicamento" %>
<%@ page import="model.SolicitudServicio" %>
<%@ page import="model.DocumentoVenta" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Clínica Ricardo Palma - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: Arial, sans-serif; }
        .navbar-custom { background-color: #0d6efd; color: white; }
        .sidebar { min-height: calc(100vh - 56px); background-color: #ffffff; border-right: 1px solid #dee2e6; padding-top: 20px; }
        .sidebar .nav-link { color: #333; padding: 10px 20px; margin-bottom: 5px; border-radius: 5px; }
        .sidebar .nav-link.active, .sidebar .nav-link:hover { background-color: #e7f1ff; color: #0d6efd; font-weight: bold; }
        .card-stat { border: none; border-radius: 8px; color: white; padding: 20px; }
    </style>
</head>
<body>

    <!-- BARRA SUPERIOR -->
    <nav class="navbar navbar-dark navbar-custom px-4 py-2">
        <a class="navbar-brand fw-bold" href="#">
            <i class="fa-solid fa-hospital me-2"></i> Clínica Ricardo Palma
        </a>
        <div class="dropdown">
            <span class="text-white me-3"><i class="fa-solid fa-user-shield me-1"></i> Administrador Palma (ADMIN)</span>
            <a href="LoginServlet?action=logout" class="btn btn-light btn-sm fw-bold">Salir</a>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            
            <!-- MENÚ LATERAL (SIDEBAR) -->
            <div class="col-md-2 sidebar d-none d-md-block">
                <h6 class="text-muted px-3 text-uppercase fs-7 fw-bold mb-3">Menú Principal</h6>
                <% 
                    String vista = request.getParameter("vista");
                    if (vista == null) vista = "panel";
                %>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link <%= vista.equals("panel") ? "active" : "" %>" href="dashboard.jsp?vista=panel">
                            <i class="fa-solid fa-chart-pie me-2"></i> Panel General
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= vista.equals("citas") ? "active" : "" %>" href="dashboard.jsp?vista=citas">
                            <i class="fa-solid fa-calendar-days me-2"></i> Gestión de Citas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= vista.equals("farmacia") ? "active" : "" %>" href="GestionServlet?vista=farmacia">
                            <i class="fa-solid fa-pills me-2"></i> Farmacia (Medicamentos)
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= vista.equals("ventas") ? "active" : "" %>" href="GestionServlet?vista=ventas">
                            <i class="fa-solid fa-file-invoice-dollar me-2"></i> Documentos de Venta
                        </a>
                    </li>
                </ul>
            </div>

            <!-- CONTENIDO PRINCIPAL -->
            <div class="col-md-10 ms-sm-auto px-md-4 py-4">

                <% 
                    // Obtenemos la lista de citas del contexto para estadísticas
                    List<Cita> listaCitas = (List<Cita>) application.getAttribute("listaCitas");
                    int totalCitas = (listaCitas != null) ? listaCitas.size() : 0;
                    int atendidias = 0;
                    if (listaCitas != null) {
                        for(Cita c : listaCitas) {
                            if("Atendida".equals(c.getEstado())) atendidias++;
                        }
                    }
                %>

                <% if (vista.equals("panel")) { %>
                    <!-- PANEL GENERAL -->
                    <h3 class="fw-bold mb-4 text-dark">Panel de Control General</h3>
                    
                    <div class="row g-4 mb-4">
                        <div class="col-md-4">
                            <div class="card card-stat bg-primary shadow-sm">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-uppercase mb-1">Citas Programadas</h6>
                                        <h2 class="fw-bold mb-0"><%= totalCitas %></h2>
                                    </div>
                                    <i class="fa-solid fa-calendar fa-2x opacity-75"></i>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card card-stat bg-success shadow-sm">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-uppercase mb-1">Pacientes Atendidos</h6>
                                        <h2 class="fw-bold mb-0"><%= atendidias %></h2>
                                    </div>
                                    <i class="fa-solid fa-user-check fa-2x opacity-75"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card shadow-sm border-0 p-4">
                        <h5 class="fw-bold text-primary mb-2">Bienvenido al Sistema Médico de la Clínica Ricardo Palma</h5>
                        <p class="text-muted">Utilice el menú lateral para gestionar las citas médicas, revisar el inventario de farmacia y consultar los documentos de venta del sistema.</p>
                        <div class="mt-2">
                            <a href="dashboard.jsp?vista=citas" class="btn btn-primary me-2"><i class="fa-solid fa-calendar-days me-2"></i> Ir a Gestión de Citas</a>
                            <a href="GestionServlet?vista=farmacia" class="btn btn-outline-primary"><i class="fa-solid fa-pills me-2"></i> Ver Farmacia</a>
                        </div>
                    </div>

                <% } else if (vista.equals("citas")) { %>
                    <!-- GESTIÓN DE CITAS -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="fw-bold text-dark">Gestión de Citas Médicas</h3>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalAgendar">
                            <i class="fa-solid fa-calendar-plus me-2"></i> Agendar Nueva Cita
                        </button>
                    </div>

                    <div class="card shadow-sm border-0">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="ps-3">#</th>
                                            <th>Paciente</th>
                                            <th>DNI</th>
                                            <th>Especialidad</th>
                                            <th>Médico</th>
                                            <th>Fecha / Hora</th>
                                            <th>Estado</th>
                                            <th class="text-end pe-3">Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            if (listaCitas != null && !listaCitas.isEmpty()) {
                                                for (Cita c : listaCitas) {
                                        %>
                                        <tr>
                                            <td class="ps-3"><%= c.getId() %></td>
                                            <td class="fw-bold"><%= c.getPaciente() %></td>
                                            <td><%= c.getDni() %></td>
                                            <td><%= c.getEspecialidad() %></td>
                                            <td><%= c.getMedico() %></td>
                                            <td><%= c.getFecha() %> <%= c.getHora() %></td>
                                            <td>
                                                <% if("Pendiente".equals(c.getEstado())) { %>
                                                    <span class="badge bg-warning text-dark">Pendiente</span>
                                                <% } else if("Atendida".equals(c.getEstado())) { %>
                                                    <span class="badge bg-success">Atendida</span>
                                                <% } else { %>
                                                    <span class="badge bg-danger">Cancelada</span>
                                                <% } %>
                                            </td>
                                            <td class="text-end pe-3">
                                                <a href="CitaServlet?accion=atender&id=<%= c.getId() %>" class="btn btn-sm btn-outline-success" title="Atender"><i class="fa-solid fa-check"></i></a>
                                                <a href="CitaServlet?accion=cancelar&id=<%= c.getId() %>" class="btn btn-sm btn-outline-warning" title="Cancelar"><i class="fa-solid fa-ban"></i></a>
                                                <a href="CitaServlet?accion=eliminar&id=<%= c.getId() %>" class="btn btn-sm btn-outline-danger" title="Eliminar"><i class="fa-solid fa-trash"></i></a>
                                            </td>
                                        </tr>
                                        <%      }
                                            } else { %>
                                        <tr>
                                            <td colspan="8" class="text-center py-4 text-muted">
                                                <i class="fa-solid fa-folder-open fa-2x mb-2 d-block"></i>
                                                No hay citas registradas, utilice el botón "Agendar Nueva Cita" para agregar la primera.
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- MODAL PARA AGENDAR NUEVA CITA -->
                    <div class="modal fade" id="modalAgendar" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content border-0 shadow">
                                <div class="modal-header bg-primary text-white">
                                    <h5 class="modal-title"><i class="fa-solid fa-calendar-plus me-2"></i> Agendar Nueva Cita</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <form action="CitaServlet" method="POST">
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Nombre del Paciente</label>
                                            <input type="text" name="paciente" class="form-control" placeholder="Ej: Juan Pérez" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label fw-bold">DNI</label>
                                            <input type="text" name="dni" class="form-control" placeholder="Ej: 71234567" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Especialidad Ricardo Palma</label>
                                            <select name="especialidad" class="form-select" required>
                                                <option value="">-- Seleccione Especialidad --</option>
                                                <option value="Cardiología">Cardiología</option>
                                                <option value="Pediatría">Pediatría</option>
                                                <option value="Medicina General">Medicina General</option>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Médico Especialista</label>
                                            <select name="medico" class="form-select" required>
                                                <option value="">-- Seleccione Médico --</option>
                                                <option value="Dr. Carlos Mendoza">Dr. Carlos Mendoza</option>
                                                <option value="Dra. Ana Torres">Dra. Ana Torres</option>
                                                <option value="Dr. Luis Silva">Dr. Luis Silva</option>
                                            </select>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label fw-bold">Fecha</label>
                                                <input type="date" name="fecha" class="form-control" required>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label fw-bold">Hora</label>
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

                <% } else if (vista.equals("farmacia")) { %>
                    <!-- INVENTARIO DE FARMACIA -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="fw-bold text-dark">Inventario de Medicamentos (Farmacia)</h3>
                        <a href="GestionServlet?vista=farmacia" class="btn btn-outline-primary btn-sm"><i class="fa-solid fa-rotate me-1"></i> Actualizar Datos</a>
                    </div>

                    <div class="card shadow-sm border-0">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="ps-3">ID</th>
                                            <th>Nombre</th>
                                            <th>Descripción</th>
                                            <th>Precio (S/)</th>
                                            <th>Stock</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            List<Medicamento> listaMeds = (List<Medicamento>) request.getAttribute("medicamentos");
                                            if (listaMeds != null && !listaMeds.isEmpty()) {
                                                for (Medicamento m : listaMeds) {
                                        %>
                                        <tr>
                                            <td class="ps-3"><%= m.getIdMedicamento() %></td>
                                            <td class="fw-bold"><%= m.getNombre() %></td>
                                            <td><%= m.getDescripcion() %></td>
                                            <td>S/ <%= m.getPrecio() %></td>
                                            <td><span class="badge bg-info text-dark"><%= m.getStock() %> unidades</span></td>
                                        </tr>
                                        <%      }
                                            } else { %>
                                        <tr>
                                            <td colspan="5" class="text-center py-4 text-muted">
                                                <i class="fa-solid fa-pills fa-2x mb-2 d-block"></i>
                                                Haz clic en "Actualizar Datos" para cargar los medicamentos desde la base de datos.
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                <% } else if (vista.equals("ventas")) { %>
                    <!-- DOCUMENTOS DE VENTA -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="fw-bold text-dark">Documentos de Venta (Facturación)</h3>
                        <a href="GestionServlet?vista=ventas" class="btn btn-outline-primary btn-sm"><i class="fa-solid fa-rotate me-1"></i> Actualizar Datos</a>
                    </div>

                    <div class="card shadow-sm border-0">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="ps-3">ID</th>
                                            <th>Tipo</th>
                                            <th>Serie - Número</th>
                                            <th>Fecha Emisión</th>
                                            <th>Cliente</th>
                                            <th>Total (S/)</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            List<DocumentoVenta> listaDocs = (List<DocumentoVenta>) request.getAttribute("documentos");
                                            if (listaDocs != null && !listaDocs.isEmpty()) {
                                                for (DocumentoVenta d : listaDocs) {
                                        %>
                                        <tr>
                                            <td class="ps-3"><%= d.getIdDocumento() %></td>
                                            <td><span class="badge bg-secondary"><%= d.getTipoDocumento() %></span></td>
                                            <td><%= d.getSerie() %> - <%= d.getNumero() %></td>
                                            <td><%= d.getFechaEmision() %></td>
                                            <td class="fw-bold"><%= d.getCliente() %></td>
                                            <td class="text-success fw-bold">S/ <%= d.getTotal() %></td>
                                        </tr>
                                        <%      }
                                            } else { %>
                                        <tr>
                                            <td colspan="6" class="text-center py-4 text-muted">
                                                <i class="fa-solid fa-file-invoice fa-2x mb-2 d-block"></i>
                                                Haz clic en "Actualizar Datos" para cargar los documentos de venta.
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                <% } %>

            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>