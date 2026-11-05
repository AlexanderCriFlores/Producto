package model;

public class SolicitudServicio {
    private int idSolicitud;
    private String paciente;
    private String tipoServicio;
    private String fechaSolicitud;
    private String estado;

    public SolicitudServicio() {}

    public SolicitudServicio(int idSolicitud, String paciente, String tipoServicio, String fechaSolicitud, String estado) {
        this.idSolicitud = idSolicitud;
        this.paciente = paciente;
        this.tipoServicio = tipoServicio;
        this.fechaSolicitud = fechaSolicitud;
        this.estado = estado;
    }

    public int getIdSolicitud() {
        return idSolicitud;
    }

    public void setIdSolicitud(int idSolicitud) {
        this.idSolicitud = idSolicitud;
    }

    public String getPaciente() {
        return paciente;
    }

    public void setPaciente(String paciente) {
        this.paciente = paciente;
    }

    public String getTipoServicio() {
        return tipoServicio;
    }

    public void setTipoServicio(String tipoServicio) {
        this.tipoServicio = tipoServicio;
    }

    public String getFechaSolicitud() {
        return fechaSolicitud;
    }

    public void setFechaSolicitud(String fechaSolicitud) {
        this.fechaSolicitud = fechaSolicitud;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}