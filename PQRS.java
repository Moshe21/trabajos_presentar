public class PQRS {
    public static final String TIPO_PETICION = "PETICION";
    public static final String TIPO_QUEJA = "QUEJA";
    public static final String TIPO_RECLAMO = "RECLAMO";
    public static final String TIPO_SUGERENCIA = "SUGERENCIA";

    public static final String ESTADO_ABIERTO = "ABIERTO";
    public static final String ESTADO_EN_PROCESO = "EN_PROCESO";
    public static final String ESTADO_RESUELTO = "RESUELTO";
    public static final String ESTADO_CERRADO = "CERRADO";

    private int numeroTicket;
    private Cliente cliente;
    private String tipo;
    private String descripcion;
    private String estado;
    private Departamento departamento;
    private Empleado empleadoAsignado;
    private String fechaCreacion;
    private String fechaActualizacion;
    private String respuesta;

    public PQRS(int numeroTicket, Cliente cliente, String tipo, String descripcion, Departamento departamento) {
        if (!tipo.equals(TIPO_PETICION) && !tipo.equals(TIPO_QUEJA) && 
            !tipo.equals(TIPO_RECLAMO) && !tipo.equals(TIPO_SUGERENCIA)) {
            throw new IllegalArgumentException("Tipo de PQRS no válido");
        }

        this.numeroTicket = numeroTicket;
        this.cliente = cliente;
        this.tipo = tipo;
        this.descripcion = descripcion;
        this.estado = ESTADO_ABIERTO;
        this.departamento = departamento;
        this.fechaCreacion = java.time.LocalDate.now().toString();
        this.fechaActualizacion = this.fechaCreacion;
    }

    public int getNumeroTicket() { return numeroTicket; }
    public Cliente getCliente() { return cliente; }
    public String getTipo() { return tipo; }
    public String getDescripcion() { return descripcion; }
    public String getEstado() { return estado; }
    public Departamento getDepartamento() { return departamento; }
    public Empleado getEmpleadoAsignado() { return empleadoAsignado; }
    public String getFechaCreacion() { return fechaCreacion; }
    public String getFechaActualizacion() { return fechaActualizacion; }
    public String getRespuesta() { return respuesta; }

    public void setEstado(String estado) {
        if (!estado.equals(ESTADO_ABIERTO) && !estado.equals(ESTADO_EN_PROCESO) && 
            !estado.equals(ESTADO_RESUELTO) && !estado.equals(ESTADO_CERRADO)) {
            throw new IllegalArgumentException("Estado no válido");
        }
        this.estado = estado;
        this.fechaActualizacion = java.time.LocalDate.now().toString();
    }

    public void setDepartamento(Departamento departamento) {
        if (departamento == null) {
            throw new IllegalArgumentException("El departamento no puede ser null");
        }
        this.departamento = departamento;
        this.fechaActualizacion = java.time.LocalDate.now().toString();
    }

    public void setEmpleadoAsignado(Empleado empleadoAsignado) {
        this.empleadoAsignado = empleadoAsignado;
        this.fechaActualizacion = java.time.LocalDate.now().toString();
    }

    public void setRespuesta(String respuesta) {
        if (respuesta == null || respuesta.trim().isEmpty()) {
            throw new IllegalArgumentException("La respuesta no puede estar vacía");
        }
        this.respuesta = respuesta;
        this.fechaActualizacion = java.time.LocalDate.now().toString();
    }

    @Override
    public String toString() {
        return String.format("""
            PQRS {
                Número de Ticket: %d
                Cliente: %s
                Tipo: %s
                Estado: %s
                Departamento: %s
                Empleado Asignado: %s
                Fecha Creación: %s
                Última Actualización: %s
                Descripción: %s
                %s
            }""",
            numeroTicket,
            cliente.getNombre(),
            tipo,
            estado,
            departamento.getNombre(),
            (empleadoAsignado != null ? empleadoAsignado.getNombre() : "Sin asignar"),
            fechaCreacion,
            fechaActualizacion,
            descripcion,
            (respuesta != null ? "Respuesta: " + respuesta : "Sin respuesta")
        );
    }

    public String toJSON() {
        return String.format("""
            {
                "pqrs": {
                    "metadata": {
                        "numeroTicket": %d,
                        "tipo": "%s",
                        "estado": "%s",
                        "fechaCreacion": "%s",
                        "fechaActualizacion": "%s"
                    },
                    "contenido": {
                        "descripcion": "%s",
                        "respuesta": %s
                    },
                    "asignacion": {
                        "departamento": {
                            "id": %d,
                            "nombre": "%s"
                        },
                        "empleadoAsignado": %s
                    },
                    "cliente": {
                        "id": %d,
                        "nombre": "%s",
                        "apartamento": "%s",
                        "contacto": {
                            "telefono": "%s",
                            "email": "%s"
                        }
                    }
                }
            }""",
            numeroTicket,
            tipo,
            estado,
            fechaCreacion,
            fechaActualizacion,
            descripcion.replace("\"", "\\\""),
            respuesta != null ? "\"" + respuesta.replace("\"", "\\\"") + "\"" : "null",
            departamento.getId(),
            departamento.getNombre(),
            empleadoAsignado != null ? 
                String.format("""
                    {
                        "id": %d,
                        "nombre": "%s",
                        "cargo": "%s"
                    }""", 
                    empleadoAsignado.getId(),
                    empleadoAsignado.getNombre(),
                    empleadoAsignado.getCargo()) : "null",
            cliente.getId(),
            cliente.getNombre(),
            cliente.getApartamento(),
            cliente.getTelefono(),
            cliente.getEmail()
        );
    }
}