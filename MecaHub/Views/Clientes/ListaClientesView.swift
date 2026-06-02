import SwiftUI

struct ListaClientesView: View {
    @StateObject var viewModel: ClienteViewModel
    @State private var busqueda: String = ""
    @State private var showNuevo = false
    
    var clientesFiltrados: [Cliente] {
        if busqueda.isEmpty { return viewModel.clientes }
        return viewModel.clientes.filter {
            $0.nombre.localizedCaseInsensitiveContains(busqueda)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Buscar cliente...", text: $busqueda)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.top, 8)
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Cargando clientes...")
                    Spacer()
                } else {
                    ScrollView {
                        Text("\(clientesFiltrados.count) clientes registrados")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 8)
                        
                        LazyVStack(spacing: 10) {
                            ForEach(clientesFiltrados) { cliente in
                                NavigationLink {
                                    PerfilClienteView(cliente: cliente, viewModel: viewModel)
                                } label: {
                                    ClientCard(cliente: cliente)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Clientes")
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
                NuevoClienteView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.getAll()
            }
        }
    }
}