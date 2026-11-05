package dao;

import configuracion.ConexionBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.SolicitudServicio;

public class SolicitudServicioDAO {

    public List<SolicitudServicio> listarSolicitudes() {
        List<SolicitudServicio> lista = new ArrayList<>();
        String sql = "SELECT * FROM solicitud_servicio";

        try (Connection con = ConexionBD.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SolicitudServicio sol = new SolicitudServicio();
                sol.setIdSolicitud(rs.getInt("id_solicitud"));
                sol.setPaciente(rs.getString("paciente"));
                sol.setTipoServicio(rs.getString("tipo_servicio"));
                sol.setFechaSolicitud(rs.getString("fecha_solicitud"));
                sol.setEstado(rs.getString("estado"));
                lista.add(sol);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean registrarSolicitud(SolicitudServicio solicitud) {
        String sql = "INSERT INTO solicitud_servicio (paciente, tipo_servicio, fecha_solicitud, estado) VALUES (?, ?, ?, ?)";
        
        try (Connection con = ConexionBD.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, solicitud.getPaciente());
            ps.setString(2, solicitud.getTipoServicio());
            ps.setString(3, solicitud.getFechaSolicitud());
            ps.setString(4, solicitud.getEstado());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}