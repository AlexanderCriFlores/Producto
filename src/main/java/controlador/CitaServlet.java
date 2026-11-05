package controlador;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Cita;
import model.DocumentoVenta;

@WebServlet("/CitaServlet")
public class CitaServlet extends HttpServlet {

    private List<Cita> obtenerListaCitas(HttpServletRequest request) {
        List<Cita> lista = (List<Cita>) request.getServletContext().getAttribute("listaCitas");
        if (lista == null) {
            lista = new ArrayList<>();
            request.getServletContext().setAttribute("listaCitas", lista);
            request.getServletContext().setAttribute("contadorId", 1);
        }
        return lista;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Cita> lista = obtenerListaCitas(request);
        String accion = request.getParameter("accion");

        if (accion != null) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (accion.equals("atender")) {
                for (Cita c : lista) {
                    if (c.getId() == id) { c.setEstado("Atendida"); break; }
                }
            } else if (accion.equals("cancelar")) {
                for (Cita c : lista) {
                    if (c.getId() == id) { c.setEstado("Cancelada"); break; }
                }
            } else if (accion.equals("eliminar")) {
                lista.removeIf(c -> c.getId() == id);
            }
        }

        response.sendRedirect("dashboard.jsp?vista=citas");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        List<Cita> lista = obtenerListaCitas(request);
        
        Integer contadorId = (Integer) request.getServletContext().getAttribute("contadorId");
        if (contadorId == null) contadorId = 1;

        String paciente = request.getParameter("paciente");
        String dni = request.getParameter("dni");
        String especialidad = request.getParameter("especialidad");
        String medico = request.getParameter("medico");
        String fecha = request.getParameter("fecha");
        String hora = request.getParameter("hora");

        Cita nuevaCita = new Cita(contadorId, paciente, dni, especialidad, medico, fecha, hora, "Pendiente");
        lista.add(nuevaCita);

        double precioConsulta = 60.00;
        if ("Cardiología".equals(especialidad)) {
            precioConsulta = 120.00;
        } else if ("Pediatría".equals(especialidad)) {
            precioConsulta = 90.00;
        }

        List<DocumentoVenta> listaDocs = (List<DocumentoVenta>) request.getServletContext().getAttribute("listaDocumentos");
        if (listaDocs == null) {
            listaDocs = new ArrayList<>();
        }
        int idDoc = listaDocs.size() + 1;
        String numeroBoleta = String.format("%06d", 100 + idDoc);
        
        DocumentoVenta nuevoDoc = new DocumentoVenta(idDoc, "Boleta", "B001", numeroBoleta, fecha, paciente, precioConsulta);
        listaDocs.add(nuevoDoc);
        
        request.getServletContext().setAttribute("contadorId", contadorId + 1);
        request.getServletContext().setAttribute("listaDocumentos", listaDocs);

        response.sendRedirect("dashboard.jsp?vista=citas");
    }
}