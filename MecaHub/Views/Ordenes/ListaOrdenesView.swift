import SwiftUI

struct ListaOrdenesView: View {
    @StateObject var viewModel: OrdenViewModel
    @State private var busqueda: String = ""
    
    let filtros = ["todos", "recibido", "diagnostico", "reparacion", "listo", "entregado"]
    let filtrosLabel = ["Todos", "Recibido", "Diagnóstico", "Reparación", "Listo", "Entregado"]
    
    var ordenesBuscadas: [Orden] {
        if busqueda.isEmpty {
            return viewModel.ordenesFiltradas
        }
        return viewModel.ordenesFiltradas.filter {
            $0.clienteNombre?.localizedCaseInsensitiveContains(busqueda) == true ||
            $0.vehiculoDesc?.localizedCaseInsensitiveContains(busqueda) == true
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // SearchField
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Buscar orden...", text: $busqueda)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.top, 8)
                
                // FilterPills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(0..<filtros.count, id: \.self) { i in
                            FilterPill(
                                titulo: filtrosLabel[i],
                                isActive: viewModel.filtroEstado == filtros[i]
                            ) {
                                viewModel.filtroEstado = filtros[i]
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                // Lista
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Cargando órdenes...")
                    Spacer()
                } else if ordenesBuscadas.isEmpty {
                    Spacer()
                    Text("No hay órdenes")
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    ScrollView {
                        Text("\(ordenesBuscadas.count) órdenes")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 4)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(ordenesBuscadas) { orden in
                                NavigationLink {
                                    DetalleOrdenView(orden: orden, viewModel: viewModel)
                                } label: {
                                    OrderCard(orden: orden)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Órdenes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        NuevaOrdenView(viewModel: viewModel)
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color("PrimaryColor"))
                    }
                }
            }
            .onAppear {
                viewModel.getAll()
            }
        }
    }
}