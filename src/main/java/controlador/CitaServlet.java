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

@WebServlet("/CitaServlet")
public class CitaServlet extends HttpServlet {

    private List<Cita> obtenerListaCitas(HttpServletRequest request) {
        List<Cita> lista = (List<Cita>) request.getServletContext().getAttribute("listaCitas");
        if (lista == null) {
            lista = new ArrayList<>();
            lista.add(new Cita(1, "Juan Pérez", "71234567", "Cardiología", "Dr. Carlos Mendoza", "2026-10-25", "09:00", "Pendiente"));
            lista.add(new Cita(2, "María López", "45678912", "Pediatría", "Dra. Ana Torres", "2026-10-20", "10:30", "Atendida"));
            lista.add(new Cita(3, "Roberto Gómez", "12345678", "Medicina General", "Dr. Luis Silva", "2026-10-21", "11:00", "Atendida"));
            request.getServletContext().setAttribute("listaCitas", lista);
            request.getServletContext().setAttribute("contadorId", 4);
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

        Cita nuevaCita = new Cita(contadorId++, paciente, dni, especialidad, medico, fecha, hora, "Pendiente");
        lista.add(nuevaCita);

        request.getServletContext().setAttribute("contadorId", contadorId);

        response.sendRedirect("dashboard.jsp?vista=citas");
    }
}