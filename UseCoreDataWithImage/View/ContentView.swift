//
//  ContentView.swift
//  UseCoreDataWithImage
//
//  Created by 松田拓海 on 2022/11/01.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)], animation: .spring()) var results: FetchedResults<Task>
    @Environment(\.managedObjectContext) private var viewContext
    
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom), content: {
            VStack(spacing:0){
                HStack{
                    Text("Tasks")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    Spacer(minLength: 0)
                }
                .padding()
                .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
                .background(Color.white)
                
                if results.isEmpty{
                    Spacer()
                    Text("No Tasks")
                        .font(.title)
                        .foregroundColor(.primary)
                        .fontWeight(.heavy)
                    Spacer()
                }else{
                    ScrollView(.vertical,showsIndicators: false, content:{
                        LazyVStack(alignment: .leading, spacing: 20){
                            
                            ForEach(results){task in
                                VStack(alignment: .leading, spacing: 5, content: {
                                    Text(task.content ?? "")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    Text(task.date ?? Date(),style: .date)
                                        .fontWeight(.bold)
                                    Divider()
                                })
                                .foregroundColor(.primary)
                                .contextMenu{
                                    Button(action: {
                                        viewModel.EditItem(item: task)
                                    }, label: {
                                        Text("Edit")
                                    })
                                    Button(action: {
                                        viewContext.delete(task)
                                        try! viewContext.save()
                                    }, label: {
                                        Text("Delete")
                                    })
                                }
                            }
                        }
                        .padding()
                    })
                }
            }
            Button(action: {viewModel.isNewData.toggle()}, label: {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Color.green)
                    .clipShape(Circle())
            })
            .padding()
        })
        .ignoresSafeArea(.all, edges: .top)
        .background(Color.primary.opacity(0.06).ignoresSafeArea(.all, edges: .all))
        .sheet(isPresented: $viewModel.isNewData, content: {
            NewDataSheet(viewModel: viewModel)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
