//
//  ScheduleItem.swift
//  Cafe
//
//  Created by Dani on 10/2/24.
//

import Foundation
import Darwin
import Combine

fileprivate func processExitCallback(fd: CFFileDescriptor?, options: CFOptionFlags, info: UnsafeMutableRawPointer?) {
    guard let info else {
        return
    }
    
    let subjectInfo = info.assumingMemoryBound(to: ScheduleItem.SubjectInfo.self).pointee
    guard subjectInfo.isActive else {
        return
    }
    
    subjectInfo.subject.send(())
    info.deallocate()
}

struct ScheduleItem: Identifiable {
    let id: UUID
    private(set) var name: String?
    
    let activation: Activation
    let objective: Objective
    
    private(set) var isActive: Bool = false
    private var _subject: UnsafeMutablePointer<SubjectInfo>?
    private var _timer: Timer?
    
    init(activation: Activation, objective: Objective) {
        self.id = UUID()
        self.activation = activation
        self.objective = objective
    }
    
    mutating func activate() -> PassthroughSubject<(), Never>? {
        guard !isActive else {
            return nil
        }
        
        var result: PassthroughSubject<(), Never>?
        switch objective {
        case .pid(let pid):
            result = activate(by: pid)
        case .date(let date):
            result = activate(by: date)
        }
        
        if result != nil {
            isActive = true
        }
        
        return result
    }
    
    mutating func deactivate() {
        guard isActive else {
            return
        }
        
        if _subject?.pointee.isActive ?? false {
            _subject?.deallocate()
        }
        _subject = nil
        _timer?.invalidate()
        _timer = nil
        isActive = false
    }
    
    private mutating func activate(by pid: UInt32) -> PassthroughSubject<(), Never>? {
        // Step 1: Get process name
        let info_ptr = UnsafeMutablePointer<proc_bsdinfo>.allocate(capacity: 1)
        defer { info_ptr.deallocate() }
        
        guard proc_pidinfo(Int32(pid),
                           PROC_PIDTBSDINFO,
                           0,
                           info_ptr,
                           Int32(MemoryLayout<proc_bsdinfo>.size)) == Int32(MemoryLayout<proc_bsdinfo>.size) else {
            print("Invalid PID: \(pid)")
            return nil
        }
        
        let info = info_ptr.pointee
        let name = withUnsafePointer(to: info.pbi_name) { pointer in
            pointer.withMemoryRebound(to: CChar.self, capacity: MemoryLayout.size(ofValue: pointer)) { char in
                String(cString: char)
            }
        }
        self.name = name
        
        // Step 2: Create the kevent
        let kq = kqueue()
        var changes = kevent()
        changes.ident = UInt(pid)
        changes.filter = Int16(EVFILT_PROC)
        changes.flags = UInt16(EV_ADD | EV_RECEIPT)
        changes.fflags = NOTE_EXIT
        changes.data = 0
        changes.udata = nil
        
        var eventlist = changes
        
        kevent(kq, &changes, 1, &eventlist, 1, nil)
        
        // Step 3: Wrap the kqueue in a CFFileDescriptor
        self._subject = UnsafeMutablePointer<SubjectInfo>.allocate(capacity: 1)
        _subject?.pointee = SubjectInfo(subject: .init())
        var context = CFFileDescriptorContext(version: 0, info: _subject, retain: nil, release: nil, copyDescription: nil)
        let fd = CFFileDescriptorCreate(nil, kq, true, processExitCallback, &context)
        
        // Step 4: Create a CFRunLoopSource from CFFileDescriptor & add it to the current RunLoop
        let source = CFFileDescriptorCreateRunLoopSource(nil, fd, 0)
        CFRunLoopAddSource(RunLoop.current.getCFRunLoop(), source, CFRunLoopMode.defaultMode)
        CFFileDescriptorEnableCallBacks(fd, kCFFileDescriptorReadCallBack)
        
        return _subject!.pointee.subject
    }
    
    private mutating func activate(by date: Date) -> PassthroughSubject<(), Never> {
        let subject = PassthroughSubject<(), Never>()
        _timer = Timer(fire: date, interval: 0, repeats: false) { _ in
            subject.send(())
        }
        RunLoop.main.add(_timer!, forMode: .common)
        return subject
    }
}

extension ScheduleItem {
    enum Objective: Hashable, Equatable {
        case pid(UInt32)
        case date(Date)
    }
    
    enum Activation: Hashable, Equatable {
        case activate
        case deactivate
    }
    
    struct SubjectInfo {
        let isActive: Bool = true
        var subject: PassthroughSubject<(), Never>
    }
}

extension ScheduleItem: Equatable {
    static func ==(lhs: ScheduleItem, rhs: ScheduleItem) -> Bool {
        lhs.id == rhs.id
    }
}

extension ScheduleItem: Hashable {}
