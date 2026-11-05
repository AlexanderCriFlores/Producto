package model;

public class DocumentoVenta {
    private int idDocumento;
    private String tipoDocumento;
    private String serie;
    private String numero;
    private String fechaEmision;
    private String cliente;
    private double total;

    public DocumentoVenta() {}

    public DocumentoVenta(int idDocumento, String tipoDocumento, String serie, String numero, String fechaEmision, String cliente, double total) {
        this.idDocumento = idDocumento;
        this.tipoDocumento = tipoDocumento;
        this.serie = serie;
        this.numero = numero;
        this.fechaEmision = fechaEmision;
        this.cliente = cliente;
        this.total = total;
    }

    public int getIdDocumento() {
        return idDocumento;
    }

    public void setIdDocumento(int idDocumento) {
        this.idDocumento = idDocumento;
    }

    public String getTipoDocumento() {
        return tipoDocumento;
    }

    public void setTipoDocumento(String tipoDocumento) {
        this.tipoDocumento = tipoDocumento;
    }

    public String getSerie() {
        return serie;
    }

    public void setSerie(String serie) {
        this.serie = serie;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public String getFechaEmision() {
        return fechaEmision;
    }

    public void setFechaEmision(String fechaEmision) {
        this.fechaEmision = fechaEmision;
    }

    public String getCliente() {
        return cliente;
    }

    public void setCliente(String cliente) {
        this.cliente = cliente;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }
}