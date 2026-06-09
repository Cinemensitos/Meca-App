import SwiftUI

struct MainTabView: View {
    @StateObject var ordenVM     = OrdenViewModel()
    @StateObject var clienteVM   = ClienteViewModel()
    @StateObject var inventarioVM = InventarioViewModel()
    @ObservedObject var mecanicoVM: MecanicoViewModel
    
    var body: some View {
        TabView {
            ListaOrdenesView(viewModel: ordenVM)
                .tabItem {
                    Label("Órdenes", systemImage: "list.clipboard")
                }
            
            ListaClientesView(viewModel: clienteVM)
                .tabItem {
                    Label("Clientes", systemImage: "person.2")
                }
            
            NuevaOrdenView(viewModel: ordenVM)
                .tabItem {
                    Label("Nueva", systemImage: "plus.circle.fill")
                }
            
            ListaInventarioView(viewModel: inventarioVM)
                .tabItem {
                    Label("Inventario", systemImage: "shippingbox")
                }
            
            PerfilView(viewModel: mecanicoVM)
                .tabItem {
                    Label("Perfil", systemImage: "person.crop.circle")
                }
        }
        .accentColor(Color("PrimaryColor"))
    }
}