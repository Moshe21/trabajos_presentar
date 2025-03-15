import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.InputMismatchException;

public class SistemaPQRS {
    private List<Departamento> departamentos;
    private List<Empleado> empleados;
    private List<Cliente> clientes;
    private List<PQRS> pqrsList;
    private Map<Integer, PQRS> pqrsMap;
    private Scanner scanner;

    public SistemaPQRS() {
        this.departamentos = new ArrayList<>();
        this.empleados = new ArrayList<>();
        this.clientes = new ArrayList<>();
        this.pqrsList = new ArrayList<>();
        this.pqrsMap = new HashMap<>();
        this.scanner = new Scanner(System.in);
        inicializarDatos();
    }

    private void inicializarDatos() {
        Departamento adminDept = new Departamento(1, "Administración", "Gestión administrativa del conjunto");
        Departamento mantDept = new Departamento(2, "Mantenimiento", "Mantenimiento de áreas comunes");
        Departamento segDept = new Departamento(3, "Seguridad", "Control de seguridad y vigilancia");

        departamentos.add(adminDept);
        departamentos.add(mantDept);
        departamentos.add(segDept);

        empleados.add(new Empleado(1, "Juan Pérez", "Administrador", adminDept, "adm1", "pass123"));
        empleados.add(new Empleado(2, "María López", "Técnico", mantDept, "tech1", "pass123"));
        empleados.add(new Empleado(3, "Carlos Ruiz", "Guardia", segDept, "seg1", "pass123"));

        clientes.add(new Cliente(1, "Ana Gómez", "Torre A - 101", "3001234567", "ana@email.com"));
        clientes.add(new Cliente(2, "Pedro Martínez", "Torre B - 202", "3109876543", "pedro@email.com"));
    }

    private int leerOpcion() {
        while (true) {
            try {
                if (scanner.hasNextInt()) {
                    return scanner.nextInt();
                } else {
                    System.out.println("Por favor, ingrese un número válido.");
                    scanner.next();
                }
            } catch (Exception e) {
                System.out.println("Error al leer la entrada. Por favor, intente nuevamente.");
                scanner.nextLine();
            }
        }
    }

    public void mostrarMenuPrincipal() {
        boolean continuar = true;
        while (continuar) {
            try {
                System.out.println("\n=== Sistema PQRS Conjunto Residencial TEKA ===");
                System.out.println("1. Crear nuevo PQRS");
                System.out.println("2. Consultar PQRS");
                System.out.println("3. Actualizar PQRS (Empleados)");
                System.out.println("4. Salir");
                System.out.print("Seleccione una opción: ");

                int opcion = leerOpcion();
                scanner.nextLine();

                switch (opcion) {
                    case 1:
                        crearPQRS();
                        break;
                    case 2:
                        consultarPQRS();
                        break;
                    case 3:
                        actualizarPQRS();
                        break;
                    case 4:
                        System.out.println("¡Gracias por usar el sistema!");
                        continuar = false;
                        break;
                    default:
                        System.out.println("Opción no válida");
                }
            } catch (Exception e) {
                System.out.println("Error inesperado: " + e.getMessage());
                System.out.println("Por favor, intente nuevamente.");
            }
        }
    }

    private void crearPQRS() {
        try {
            System.out.println("\n=== Crear nuevo PQRS ===");

            System.out.println("Seleccione el cliente:");
            for (Cliente cliente : clientes) {
                System.out.println(cliente.getId() + ". " + cliente.getNombre() + " - " + cliente.getApartamento());
            }

            int clienteId = leerOpcion();
            scanner.nextLine();

            Cliente clienteSeleccionado = clientes.stream()
                    .filter(c -> c.getId() == clienteId)
                    .findFirst()
                    .orElse(null);

            if (clienteSeleccionado == null) {
                System.out.println("Cliente no encontrado");
                return;
            }

            System.out.println("\nTipo de PQRS:");
            System.out.println("1. PETICION");
            System.out.println("2. QUEJA");
            System.out.println("3. RECLAMO");
            System.out.println("4. SUGERENCIA");

            int tipoOpcion = leerOpcion();
            scanner.nextLine();

            String tipo = switch (tipoOpcion) {
                case 1 -> PQRS.TIPO_PETICION;
                case 2 -> PQRS.TIPO_QUEJA;
                case 3 -> PQRS.TIPO_RECLAMO;
                case 4 -> PQRS.TIPO_SUGERENCIA;
                default -> PQRS.TIPO_PETICION;
            };

            System.out.println("\nDescripción del PQRS:");
            String descripcion = scanner.nextLine();

            System.out.println("\nSeleccione el departamento:");
            for (Departamento dept : departamentos) {
                System.out.println(dept.getId() + ". " + dept.getNombre());
            }

            int deptId = leerOpcion();
            scanner.nextLine();

            Departamento departamentoSeleccionado = departamentos.stream()
                    .filter(d -> d.getId() == deptId)
                    .findFirst()
                    .orElse(null);

            if (departamentoSeleccionado == null) {
                System.out.println("Departamento no encontrado");
                return;
            }

            PQRS nuevoPQRS = new PQRS(pqrsList.size() + 1, clienteSeleccionado, tipo, descripcion, departamentoSeleccionado);
            pqrsList.add(nuevoPQRS);
            pqrsMap.put(nuevoPQRS.getNumeroTicket(), nuevoPQRS);

            System.out.println("\nPQRS creado exitosamente. Número de ticket: " + nuevoPQRS.getNumeroTicket());
        } catch (Exception e) {
            System.out.println("Error al crear PQRS: " + e.getMessage());
        }
    }

    private void consultarPQRS() {
        try {
            System.out.println("\n=== Consultar PQRS ===");
            System.out.println("Ingrese el número de ticket:");

            int numeroTicket = leerOpcion();
            scanner.nextLine();

            PQRS pqrs = pqrsMap.get(numeroTicket);
            if (pqrs != null) {
                System.out.println("\nDetalles del PQRS:");
                System.out.println(pqrs);

                System.out.println("\nFormato JSON:");
                System.out.println(pqrs.toJSON());
            } else {
                System.out.println("PQRS no encontrado");
            }
        } catch (Exception e) {
            System.out.println("Error al consultar PQRS: " + e.getMessage());
        }
    }

    private void actualizarPQRS() {
        try {
            System.out.println("\n=== Actualizar PQRS (Empleados) ===");
            System.out.println("Usuario:");
            String usuario = scanner.nextLine();
            System.out.println("Contraseña:");
            String password = scanner.nextLine();

            Empleado empleado = empleados.stream()
                    .filter(e -> e.autenticar(usuario, password))
                    .findFirst()
                    .orElse(null);

            if (empleado == null) {
                System.out.println("Credenciales inválidas");
                return;
            }

            System.out.println("\nIngrese el número de ticket a actualizar:");
            int numeroTicket = leerOpcion();
            scanner.nextLine();

            PQRS pqrs = pqrsMap.get(numeroTicket);
            if (pqrs == null) {
                System.out.println("PQRS no encontrado");
                return;
            }

            System.out.println("\nPQRS actual:");
            System.out.println(pqrs);

            System.out.println("\nSeleccione el nuevo estado:");
            System.out.println("1. EN_PROCESO");
            System.out.println("2. RESUELTO");
            System.out.println("3. CERRADO");

            int estadoOpcion = leerOpcion();
            scanner.nextLine();

            String nuevoEstado = switch (estadoOpcion) {
                case 1 -> PQRS.ESTADO_EN_PROCESO;
                case 2 -> PQRS.ESTADO_RESUELTO;
                case 3 -> PQRS.ESTADO_CERRADO;
                default -> pqrs.getEstado();
            };

            System.out.println("\nIngrese la respuesta o actualización:");
            String respuesta = scanner.nextLine();

            pqrs.setEstado(nuevoEstado);
            pqrs.setEmpleadoAsignado(empleado);
            pqrs.setRespuesta(respuesta);

            System.out.println("\nPQRS actualizado exitosamente");
        } catch (Exception e) {
            System.out.println("Error al actualizar PQRS: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        SistemaPQRS sistema = new SistemaPQRS();
        sistema.mostrarMenuPrincipal();
    }
}