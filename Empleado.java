public class Empleado {
    private int id;
    private String nombre;
    private String cargo;
    private Departamento departamento;
    private String usuario;
    private String password;

    public Empleado(int id, String nombre, String cargo, Departamento departamento, String usuario, String password) {
        this.id = id;
        this.nombre = nombre;
        this.cargo = cargo;
        this.departamento = departamento;
        this.usuario = usuario;
        this.password = password;
    }

    public int getId() {
        return id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getCargo() {
        return cargo;
    }

    public void setCargo(String cargo) {
        this.cargo = cargo;
    }

    public Departamento getDepartamento() {
        return departamento;
    }

    public void setDepartamento(Departamento departamento) {
        this.departamento = departamento;
    }

    public boolean autenticar(String usuario, String password) {
        return this.usuario.equals(usuario) && this.password.equals(password);
    }

    @Override
    public String toString() {
        return "Empleado{" +
                "id=" + id +
                ", nombre='" + nombre + '\'' +
                ", cargo='" + cargo + '\'' +
                ", departamento=" + departamento.getNombre() +
                '}';
    }
}