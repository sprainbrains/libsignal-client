//
// Copyright 2020-2022 Signal Messenger, LLC.
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import SignalFfi

public class ServerZkProfileOperations {

  let serverSecretParams: ServerSecretParams

  public init(serverSecretParams: ServerSecretParams) {
    self.serverSecretParams = serverSecretParams
  }

  public func issueProfileKeyCredential(profileKeyCredentialRequest: ProfileKeyCredentialRequest, uuid: UUID, profileKeyCommitment: ProfileKeyCommitment) throws -> ProfileKeyCredentialResponse {
    return try issueProfileKeyCredential(randomness: Randomness.generate(), profileKeyCredentialRequest: profileKeyCredentialRequest, uuid: uuid, profileKeyCommitment: profileKeyCommitment)
  }

  public func issueProfileKeyCredential(randomness: Randomness, profileKeyCredentialRequest: ProfileKeyCredentialRequest, uuid: UUID, profileKeyCommitment: ProfileKeyCommitment) throws -> ProfileKeyCredentialResponse {
    return try serverSecretParams.withUnsafePointerToSerialized { serverSecretParams in
      try randomness.withUnsafePointerToBytes { randomness in
        try profileKeyCredentialRequest.withUnsafePointerToSerialized { request in
          try withUnsafePointer(to: uuid.uuid) { uuid in
            try profileKeyCommitment.withUnsafePointerToSerialized { commitment in
              try invokeFnReturningSerialized {
                signal_server_secret_params_issue_profile_key_credential_deterministic($0, serverSecretParams, randomness, request, uuid, commitment)
              }
            }
          }
        }
      }
    }
  }

  public func issueExpiringProfileKeyCredential(profileKeyCredentialRequest: ProfileKeyCredentialRequest, uuid: UUID, profileKeyCommitment: ProfileKeyCommitment, expiration: UInt64) throws -> ExpiringProfileKeyCredentialResponse {
    return try issueExpiringProfileKeyCredential(randomness: Randomness.generate(), profileKeyCredentialRequest: profileKeyCredentialRequest, uuid: uuid, profileKeyCommitment: profileKeyCommitment, expiration: expiration)
  }

  public func issueExpiringProfileKeyCredential(randomness: Randomness, profileKeyCredentialRequest: ProfileKeyCredentialRequest, uuid: UUID, profileKeyCommitment: ProfileKeyCommitment, expiration: UInt64) throws -> ExpiringProfileKeyCredentialResponse {
    return try serverSecretParams.withUnsafePointerToSerialized { serverSecretParams in
      try randomness.withUnsafePointerToBytes { randomness in
        try profileKeyCredentialRequest.withUnsafePointerToSerialized { request in
          try withUnsafePointer(to: uuid.uuid) { uuid in
            try profileKeyCommitment.withUnsafePointerToSerialized { commitment in
              try invokeFnReturningSerialized {
                signal_server_secret_params_issue_expiring_profile_key_credential_deterministic($0, serverSecretParams, randomness, request, uuid, commitment, expiration)
              }
            }
          }
        }
      }
    }
  }

  @available(*, deprecated, message: "superseded by AuthCredentialWithPni + ProfileKeyCredential")
  public func issuePniCredential(profileKeyCredentialRequest: ProfileKeyCredentialRequest, aci: UUID, pni: UUID, profileKeyCommitment: ProfileKeyCommitment) throws -> PniCredentialResponse {
    return try issuePniCredential(randomness: Randomness.generate(), profileKeyCredentialRequest: profileKeyCredentialRequest, aci: aci, pni: pni, profileKeyCommitment: profileKeyCommitment)
  }

  @available(*, deprecated, message: "superseded by AuthCredentialWithPni + ProfileKeyCredential")
  public func issuePniCredential(randomness: Randomness, profileKeyCredentialRequest: ProfileKeyCredentialRequest, aci: UUID, pni: UUID, profileKeyCommitment: ProfileKeyCommitment) throws -> PniCredentialResponse {
    return try serverSecretParams.withUnsafePointerToSerialized { serverSecretParams in
      try randomness.withUnsafePointerToBytes { randomness in
        try profileKeyCredentialRequest.withUnsafePointerToSerialized { request in
          try withUnsafePointer(to: aci.uuid) { aci in
            try withUnsafePointer(to: pni.uuid) { pni in
              try profileKeyCommitment.withUnsafePointerToSerialized { commitment in
                try invokeFnReturningSerialized {
                  signal_server_secret_params_issue_pni_credential_deterministic($0, serverSecretParams, randomness, request, aci, pni, commitment)
                }
              }
            }
          }
        }
      }
    }
  }

  public func verifyProfileKeyCredentialPresentation(
    groupPublicParams: GroupPublicParams,
    profileKeyCredentialPresentation: ProfileKeyCredentialPresentation,
    now: Date = Date()
  ) throws {
    try serverSecretParams.withUnsafePointerToSerialized { serverSecretParams in
      try groupPublicParams.withUnsafePointerToSerialized { groupPublicParams in
        try profileKeyCredentialPresentation.withUnsafeBorrowedBuffer { presentation in
          try checkError(signal_server_secret_params_verify_profile_key_credential_presentation(serverSecretParams, groupPublicParams, presentation, UInt64(now.timeIntervalSince1970)))
        }
      }
    }
  }

  @available(*, deprecated, message: "superseded by AuthCredentialWithPni + ProfileKeyCredential")
  public func verifyPniCredentialPresentation(groupPublicParams: GroupPublicParams, presentation: PniCredentialPresentation) throws {
    try serverSecretParams.withUnsafePointerToSerialized { serverSecretParams in
      try groupPublicParams.withUnsafePointerToSerialized { groupPublicParams in
        try presentation.withUnsafeBorrowedBuffer { presentation in
          try checkError(signal_server_secret_params_verify_pni_credential_presentation(serverSecretParams, groupPublicParams, presentation))
        }
      }
    }
  }

}
