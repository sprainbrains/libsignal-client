//
// Copyright 2023 Signal Messenger, LLC.
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import SignalFfi

// swiftlint:disable large_tuple
public typealias ServiceIdStorage = (
    UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
    UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8
)
// swiftlint:enable large_tuple

public func == (_ lhs: ServiceIdStorage, _ rhs: ServiceIdStorage) -> Bool {
    return lhs.0 == rhs.0 &&
        lhs.1 == rhs.1 &&
        lhs.2 == rhs.2 &&
        lhs.3 == rhs.3 &&
        lhs.4 == rhs.4 &&
        lhs.5 == rhs.5 &&
        lhs.6 == rhs.6 &&
        lhs.7 == rhs.7 &&
        lhs.8 == rhs.8 &&
        lhs.9 == rhs.9 &&
        lhs.10 == rhs.10 &&
        lhs.11 == rhs.11 &&
        lhs.12 == rhs.12 &&
        lhs.13 == rhs.13 &&
        lhs.14 == rhs.14 &&
        lhs.15 == rhs.15 &&
        lhs.16 == rhs.16
}

public func != (_ lhs: ServiceIdStorage, _ rhs: ServiceIdStorage) -> Bool {
    return !(lhs == rhs)
}

public enum ServiceIdKind: UInt8 {
    case aci = 0
    case pni = 1
}

public enum ServiceIdError: Error {
    case invalidServiceId
}

public class ServiceId {
    fileprivate var storage: ServiceIdStorage = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

    fileprivate init(fromFixedWidthBinary storage: ServiceIdStorage) {
        self.storage = storage
    }

    fileprivate init(_ kind: ServiceIdKind, _ uuid: UUID) {
        self.storage.0 = kind.rawValue
        withUnsafeMutableBytes(of: &self.storage) { storageBuffer in
            storageBuffer.storeBytes(of: uuid.uuid, toByteOffset: 1, as: uuid_t.self)
        }
    }

    public var kind: ServiceIdKind {
        return ServiceIdKind(rawValue: self.storage.0)!
    }

    public var rawUUID: UUID {
        let uuid = withUnsafeBytes(of: self.storage) { storageBuffer in
            storageBuffer.load(fromByteOffset: 1, as: uuid_t.self)
        }
        return UUID(uuid: uuid)
    }

    public var serviceIdString: String {
        failOnError {
            try withUnsafePointer(to: self.storage) { ptr in
                try invokeFnReturningString {
                    signal_service_id_service_id_string($0, ptr)
                }
            }
        }
    }

    public var serviceIdUppercaseString: String {
        return self.serviceIdString.uppercased()
    }

    public var logString: String {
        failOnError {
            try withUnsafePointer(to: self.storage) { ptr in
                try invokeFnReturningString {
                    signal_service_id_service_id_log($0, ptr)
                }
            }
        }
    }

    public var serviceIdBinary: [UInt8] {
        return failOnError {
            try withUnsafePointer(to: self.storage) { ptr in
                try invokeFnReturningArray {
                    signal_service_id_service_id_binary($0, ptr)
                }
            }
        }
    }

    public static func parseFrom(serviceIdString s: String) throws -> ServiceId {
        var bytes: ServiceIdStorage = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        try s.withCString { sPtr in
            return try checkError(
                signal_service_id_parse_from_service_id_string(&bytes, sPtr)
            )
        }
        return try parseFrom(fixedWidthBinary: bytes)
    }

    public static func parseFrom<
        Bytes: ContiguousBytes
    >(serviceIdBinary sourceBytes: Bytes) throws -> ServiceId {
        var bytes: ServiceIdStorage = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        try sourceBytes.withUnsafeBorrowedBuffer { buffer in
            try checkError(
                signal_service_id_parse_from_service_id_binary(&bytes, buffer)
            )
        }
        return try parseFrom(fixedWidthBinary: bytes)
    }

    private static func parseFrom(
        fixedWidthBinary bytes: ServiceIdStorage
    ) throws -> ServiceId {
        switch bytes.0 {
        case ServiceIdKind.aci.rawValue:
            return Aci(fromFixedWidthBinary: bytes)
        case ServiceIdKind.pni.rawValue:
            return Pni(fromFixedWidthBinary: bytes)
        default:
            throw ServiceIdError.invalidServiceId
        }
    }
}

extension ServiceId: Equatable {
    public static func == (_ lhs: ServiceId, _ rhs: ServiceId) -> Bool {
        return lhs.storage == rhs.storage
    }
}

extension ServiceId: Hashable {
    public func hash(into hasher: inout Hasher) {
        withUnsafeBytes(of: self.storage) { buffer in
            hasher.combine(bytes: buffer)
        }
    }
}

extension ServiceId: CustomDebugStringConvertible {
    public var debugDescription: String {
        return self.logString
    }
}

public class Aci: ServiceId {
    public init(fromUUID uuid: UUID) {
        super.init(.aci, uuid)
    }

    fileprivate override init(fromFixedWidthBinary bytes: ServiceIdStorage) {
        super.init(fromFixedWidthBinary: bytes)
    }
}

public class Pni: ServiceId {
    public init(fromUUID uuid: UUID) {
        super.init(.pni, uuid)
    }

    fileprivate override init(fromFixedWidthBinary bytes: ServiceIdStorage) {
        super.init(fromFixedWidthBinary: bytes)
    }
}
