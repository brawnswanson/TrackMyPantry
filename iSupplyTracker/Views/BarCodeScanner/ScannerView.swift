//
//  ScannerView.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 24.03.22.
//
//IMP: Someday woul dlike to be able to add a picture of the scanned item to the info
//TODO: Add geo reader to toolbar
//TODO: Put labels on toolbar buttons
//TODO: Change everything to menus instead of pickers
//TODO: Change "no Location" to "select location"
//TODO: Change to 1 menu that has all options in it and just include indicators on screen instead of buttons

import SwiftUI

struct ScannerView: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) private var items: FetchedResults<ItemInfo>
    @FetchRequest(sortDescriptors: []) private var lots: FetchedResults<Lot>
    @FetchRequest(sortDescriptors: []) private var locations: FetchedResults<StorageLocation>
    @FetchRequest(sortDescriptors: []) private var fetchSelectedLocation: FetchedResults<StorageLocation>
    
    //MARK: barCode and scanningRestart are bindings for the UIScannerView Coordinator
    @State private var barCode: String?
    @State private var scanningRestart: Bool? = nil
    
    //MARK: Once we have a valid barcode, this variable is updated, which opens the ItemEditView sheet
    @State private var scannedBarCode: BarCode?
    @State private var itemToEdit: ItemInfo?
    @State private var selectedLocation: StorageLocation?
    
    @State private var bulkScanQuantitySheetPresented = false
    @State private var locationsSheetPresented = false
    
    @State private var addOnScan = true
    
    @State private var bulkScanQuantity = 1
    @State private var bulkScanConfirm = true
    
    @State private var overrideExpirationDate: Date? = nil
    @State private var expirationDateSelectionPresented = false
    
    var body: some View  {
        ZStack {
#if targetEnvironment(simulator)
            Button(action: { processScanResult(barCodeString: "12345678")}, label: { Text("Simulate scan")})
#else
            ScannerViewController(barCode: $barCode, scanningRestart: $scanningRestart)
            
#endif
            VStack {
                HStack {
                    Button(action: { locationsSheetPresented.toggle() }, label: { HStack {
                        Image(systemName: "mappin")
                        Text("\(selectedLocation?.name ?? "No location")")
                    }})
                    Spacer()
                    Button(action: { expirationDateSelectionPresented.toggle() }, label: { Image(systemName: "hourglass.badge.plus")
                            .imageScale(.large)})
                    Spacer()
                    Picker("", selection: $addOnScan, content: {
                        Image(systemName: "plus").tag(true)
                        Image(systemName: "minus").tag(false)
                    }).pickerStyle(.segmented)
                        .frame(width: 100)
                    Spacer()
                    Menu(content: {
                        Picker("", selection: $bulkScanQuantity, content: {
                            ForEach(1..<11) { i in
                                Text("\(i)").tag(i)
                            }
                        })
                    }, label: {
                        HStack {
                            Image(systemName: "multiply.circle.fill")
                            Text("\(bulkScanQuantity)")
                        }
                    })
                }
                .padding()
                Spacer()
            }
            .padding()
            
        }
        .onChange(of: barCode, perform: { newCode in processScanResult(barCodeString: newCode)})
        .sheet(item: $itemToEdit, onDismiss: { resetView() }, content: { item in ItemEditView(currentItem: item)})
        .sheet(item: $scannedBarCode, onDismiss: {
            if let createdItem = items.first {
                updateInventoryOnScan(item: createdItem)
            }
            resetView() }, content: { code in ItemEditView(barCode: code)})
        .sheet(isPresented: $locationsSheetPresented, content: { LocationSelectionView(selectedLocation: $selectedLocation)})
        .sheet(isPresented: $expirationDateSelectionPresented, content: { NavigationView {
            ExpirationDateSelectionView(expDate: $overrideExpirationDate)
        }})
        .navigationBarHidden(true)
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScannerView()
                .preferredColorScheme(.dark)
        }
    }
}

extension ScannerView {
    
    func processScanResult(barCodeString: String?) {
        guard let validBarCodeString = barCodeString else { return }
        let validScannedBarCode = BarCode(code: validBarCodeString)
        //MARK: If not an existing item, open new item sheet
        guard let existingItemInInventory = getCurrentItem(code: validScannedBarCode) else {
            scannedBarCode = validScannedBarCode
            return
        }
        updateInventoryOnScan(item: existingItemInInventory)
    }
    
    func getCurrentItem(code: BarCode) -> ItemInfo? {
        items.nsPredicate = NSPredicate(format: "barCode == %@", code.code)
        guard let foundItem = items.first else { return nil}
        return foundItem
    }
    
    func resetView() {
        barCode = nil
        scannedBarCode = nil
        scanningRestart = true
        itemToEdit = nil
        bulkScanQuantity = 1
        overrideExpirationDate = nil
    }
    
    func resetViewWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {resetView()})
    }
    
    func updateInventoryOnScan(item: ItemInfo) {
        var keyDictionary: [String:Any] = ["dateScanned":Date(), "item":item]
        keyDictionary["location"] = selectedLocation
        if let expDate = overrideExpirationDate {
            keyDictionary["expirationDate"] = expDate
        }
        else {
            keyDictionary["expirationDate"] = Date(timeIntervalSinceNow: item.shelfLifeInMonths * 365 / 12 * 24 * 60 * 60)
        }
        for _ in 1...bulkScanQuantity {
            switch addOnScan {
            case true:
                let _ = CoreDataCoordinator.sharedCoreData.createEntity(entity: Lot.entity(), keyedValues: keyDictionary)
            case false:
                if let loc = selectedLocation {
                    lots.nsPredicate = NSPredicate(format: "item == %@ AND location == %@", item, loc)
                }
                else {
                    lots.nsPredicate = NSPredicate(format: "item == %@ AND location == nil", item)
                }
                if let lotToDelete = lots.first { CoreDataCoordinator.sharedCoreData.deleteEntity(objectToDelete: lotToDelete) }
            }
        }
        resetViewWithDelay()
    }
}
