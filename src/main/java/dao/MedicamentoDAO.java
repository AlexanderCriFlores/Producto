package dao;

import configuracion.ConexionBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Medicamento;

public class MedicamentoDAO {

    public List<Medicamento> listarMedicamentos() {
        List<Medicamento> lista = new ArrayList<>();
        String sql = "SELECT * FROM medicamento";

        try (Connection con = ConexionBD.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Medicamento med = new Medicamento();
                med.setIdMedicamento(rs.getInt("id_medicamento"));
                med.setNombre(rs.getString("nombre"));
                med.setDescripcion(rs.getString("descripcion"));
                med.setPrecio(rs.getDouble("precio"));
                med.setStock(rs.getInt("stock"));
                lista.add(med);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}