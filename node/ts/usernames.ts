//
// Copyright 2023 Signal Messenger, LLC.
// SPDX-License-Identifier: AGPL-3.0-only
//

import { randomBytes } from 'crypto';
import { RANDOM_LENGTH } from './zkgroup/internal/Constants';
import * as Native from '../Native';

export function generateCandidates(
  nickname: string,
  minNicknameLength: number,
  maxNicknameLength: number
): string[] {
  return Native.Username_CandidatesFrom(
    nickname,
    minNicknameLength,
    maxNicknameLength
  ).split(',');
}

export function hash(username: string): Buffer {
  return Native.Username_Hash(username);
}

export function generateProof(username: string): Buffer {
  const random = randomBytes(RANDOM_LENGTH);
  return generateProofWithRandom(username, random);
}

export function generateProofWithRandom(
  username: string,
  random: Buffer
): Buffer {
  return Native.Username_Proof(username, random);
}

// Only for testing. Will throw on failure.
export function verifyProof(proof: Buffer, hash: Buffer): void {
  Native.Username_Verify(proof, hash);
}
