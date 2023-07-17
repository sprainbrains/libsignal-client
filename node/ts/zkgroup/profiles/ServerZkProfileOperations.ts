//
// Copyright 2020-2022 Signal Messenger, LLC.
// SPDX-License-Identifier: AGPL-3.0-only
//

import { randomBytes } from 'crypto';
import * as Native from '../../../Native';
import { RANDOM_LENGTH } from '../internal/Constants';

import ServerSecretParams from '../ServerSecretParams';
import GroupPublicParams from '../groups/GroupPublicParams';

import ExpiringProfileKeyCredentialResponse from './ExpiringProfileKeyCredentialResponse';
import ProfileKeyCommitment from './ProfileKeyCommitment';
import ProfileKeyCredentialPresentation from './ProfileKeyCredentialPresentation';
import ProfileKeyCredentialRequest from './ProfileKeyCredentialRequest';

import { UUIDType, fromUUID } from '../internal/UUIDUtil';

export default class ServerZkProfileOperations {
  serverSecretParams: ServerSecretParams;

  constructor(serverSecretParams: ServerSecretParams) {
    this.serverSecretParams = serverSecretParams;
  }

  issueExpiringProfileKeyCredential(
    profileKeyCredentialRequest: ProfileKeyCredentialRequest,
    uuid: UUIDType,
    profileKeyCommitment: ProfileKeyCommitment,
    expirationInSeconds: number
  ): ExpiringProfileKeyCredentialResponse {
    const random = randomBytes(RANDOM_LENGTH);

    return this.issueExpiringProfileKeyCredentialWithRandom(
      random,
      profileKeyCredentialRequest,
      uuid,
      profileKeyCommitment,
      expirationInSeconds
    );
  }

  issueExpiringProfileKeyCredentialWithRandom(
    random: Buffer,
    profileKeyCredentialRequest: ProfileKeyCredentialRequest,
    uuid: UUIDType,
    profileKeyCommitment: ProfileKeyCommitment,
    expirationInSeconds: number
  ): ExpiringProfileKeyCredentialResponse {
    return new ExpiringProfileKeyCredentialResponse(
      Native.ServerSecretParams_IssueExpiringProfileKeyCredentialDeterministic(
        this.serverSecretParams.getContents(),
        random,
        profileKeyCredentialRequest.getContents(),
        fromUUID(uuid),
        profileKeyCommitment.getContents(),
        expirationInSeconds
      )
    );
  }

  verifyProfileKeyCredentialPresentation(
    groupPublicParams: GroupPublicParams,
    profileKeyCredentialPresentation: ProfileKeyCredentialPresentation,
    now: Date = new Date()
  ): void {
    Native.ServerSecretParams_VerifyProfileKeyCredentialPresentation(
      this.serverSecretParams.getContents(),
      groupPublicParams.getContents(),
      profileKeyCredentialPresentation.getContents(),
      Math.floor(now.getTime() / 1000)
    );
  }
}
