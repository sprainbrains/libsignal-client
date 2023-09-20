//
// Copyright 2020-2021 Signal Messenger, LLC.
// SPDX-License-Identifier: AGPL-3.0-only
//

package org.signal.libsignal.zkgroup.auth;

import org.signal.libsignal.internal.Native;
import org.signal.libsignal.zkgroup.InvalidInputException;
import org.signal.libsignal.zkgroup.internal.ByteArray;

public final class AuthCredential extends ByteArray {
  public AuthCredential(byte[] contents) throws InvalidInputException {
    super(contents);
    Native.AuthCredential_CheckValidContents(contents);
  }
}
