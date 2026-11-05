package dao;

import configuracion.ConexionBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.DocumentoVenta;

public class DocumentoVentaDAO {

    public List<DocumentoVenta> listarDocumentos() {
        List<DocumentoVenta> lista = new ArrayList<>();
        String sql = "SELECT * FROM documento_venta";

        try (Connection con = ConexionBD.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                DocumentoVenta doc = new DocumentoVenta();
                doc.setIdDocumento(rs.getInt("id_documento"));
                doc.setTipoDocumento(rs.getString("tipo_documento"));
                doc.setSerie(rs.getString("serie"));
                doc.setNumero(rs.getString("numero"));
                doc.setFechaEmision(rs.getString("fecha_emision"));
                doc.setCliente(rs.getString("cliente"));
                doc.setTotal(rs.getDouble("total"));
                lista.add(doc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean registrarDocumento(DocumentoVenta doc) {
        String sql = "INSERT INTO documento_venta (tipo_documento, serie, numero, fecha_emision, cliente, total) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection con = ConexionBD.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, doc.getTipoDocumento());
            ps.setString(2, doc.getSerie());
            ps.setString(3, doc.getNumero());
            ps.setString(4, doc.getFechaEmision());
            ps.setString(5, doc.getCliente());
            ps.setDouble(6, doc.getTotal());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}