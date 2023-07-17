//
// Copyright 2023 Signal Messenger, LLC.
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import SignalFfi

public class CallLinkSecretParams: ByteArray {

  public static func deriveFromRootKey<RootKey: ContiguousBytes>(_ rootKey: RootKey) -> CallLinkSecretParams {
    return failOnError {
      try rootKey.withUnsafeBorrowedBuffer { rootKey in
        try invokeFnReturningVariableLengthSerialized {
          signal_call_link_secret_params_derive_from_root_key($0, rootKey)
        }
      }
    }
  }

  public required init(contents: [UInt8]) throws {
    try super.init(contents, checkValid: signal_call_link_secret_params_check_valid_contents)
  }

  public func getPublicParams() -> CallLinkPublicParams {
    return failOnError {
      try withUnsafeBorrowedBuffer { contents in
        try invokeFnReturningVariableLengthSerialized {
          signal_call_link_secret_params_get_public_params($0, contents)
        }
      }
    }
  }

  public func decryptUserId(_ ciphertext: UuidCiphertext) throws -> UUID {
    return try withUnsafeBorrowedBuffer { contents in
      try ciphertext.withUnsafePointerToSerialized { ciphertext in
        try invokeFnReturningUuid {
          signal_call_link_secret_params_decrypt_user_id($0, contents, ciphertext)
        }
      }
    }
  }

}
