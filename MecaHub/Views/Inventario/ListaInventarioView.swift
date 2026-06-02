import SwiftUI

struct ListaInventarioView: View {
    @StateObject var viewModel: InventarioViewModel
    @State private var busqueda: String = ""
    @State private var showNuevo = false
    
    let filtros = ["todos", "disponible", "bajo", "critico"]
    let filtrosLabel = ["Todos", "Disponible", "Bajo", "Crítico"]
    
    var piezasBuscadas: [Pieza] {
        if busqueda.isEmpty { return viewModel.piezasFiltradas }
        return viewModel.piezasFiltradas.filter {
            $0.nombre.localizedCaseInsensitiveContains(busqueda) ||
            ($0.categoria?.localizedCaseInsensitiveContains(busqueda) == true)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Buscar refacción...", text: $busqueda)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.top, 8)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(0..<filtros.count, id: \.self) { i in
                            FilterPill(
                                titulo: filtrosLabel[i],
                                isActive: viewModel.filtroStock == filtros[i]
                            ) {
                                viewModel.filtroStock = filtros[i]
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Cargando inventario...")
                    Spacer()
                } else {
                    ScrollView {
                        Text("\(piezasBuscadas.count) refacciones")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 4)
                        
                        LazyVStack(spacing: 10) {
                            ForEach(piezasBuscadas) { pieza in
                                NavigationLink {
                                    DetallePiezaView(pieza: pieza, viewModel: viewModel)
                                } label: {
                                    PartCard(pieza: pieza)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Inventario")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNuevo = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color("PrimaryColor"))
                    }
                }
            }
            .sheet(isPresented: $showNuevo) {
                NuevaPiezaView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.getAll()
            }
        }
    }
}