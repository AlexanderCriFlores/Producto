package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.DocumentoVenta;
import model.Medicamento;
import model.SolicitudServicio;

@WebServlet(name = "GestionServlet", urlPatterns = {"/GestionServlet"})
public class GestionServlet extends HttpServlet {

    private void inicializarDatos(HttpServletRequest request) {
        List<Medicamento> listaMedicamentos = (List<Medicamento>) request.getServletContext().getAttribute("listaMedicamentos");
        if (listaMedicamentos == null) {
            listaMedicamentos = new ArrayList<>();
            listaMedicamentos.add(new Medicamento(1, "Paracetamol 500mg", "Analgésico y antipirético", 1.50, 100));
            listaMedicamentos.add(new Medicamento(2, "Ibuprofeno 400mg", "Antiinflamatorio no esteroideo", 2.20, 80));
            listaMedicamentos.add(new Medicamento(3, "Amoxicilina 500mg", "Antibiótico bactericida", 3.50, 100));
            listaMedicamentos.add(new Medicamento(4, "Azitromicina 500mg", "Antibiótico macrólido", 6.5, 45));
            request.getServletContext().setAttribute("listaMedicamentos", listaMedicamentos);
        }

        List<SolicitudServicio> listaSolicitudes = (List<SolicitudServicio>) request.getServletContext().getAttribute("listaSolicitudes");
        if (listaSolicitudes == null) {
            listaSolicitudes = new ArrayList<>();
            request.getServletContext().setAttribute("listaSolicitudes", listaSolicitudes);
        }

        List<DocumentoVenta> listaDocumentos = (List<DocumentoVenta>) request.getServletContext().getAttribute("listaDocumentos");
        if (listaDocumentos == null) {
            listaDocumentos = new ArrayList<>();
            request.getServletContext().setAttribute("listaDocumentos", listaDocumentos);
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        inicializarDatos(request);

        List<Medicamento> listaMedicamentos = (List<Medicamento>) request.getServletContext().getAttribute("listaMedicamentos");
        List<SolicitudServicio> listaSolicitudes = (List<SolicitudServicio>) request.getServletContext().getAttribute("listaSolicitudes");
        List<DocumentoVenta> listaDocumentos = (List<DocumentoVenta>) request.getServletContext().getAttribute("listaDocumentos");

        request.setAttribute("medicamentos", listaMedicamentos);
        request.setAttribute("solicitudes", listaSolicitudes);
        request.setAttribute("documentos", listaDocumentos);

        String vista = request.getParameter("vista");
        if (vista == null || vista.isEmpty()) {
            vista = "farmacia";
        }

        request.getRequestDispatcher("dashboard.jsp?vista=" + vista).forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}