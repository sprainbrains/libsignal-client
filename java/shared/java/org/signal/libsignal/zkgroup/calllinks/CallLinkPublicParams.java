//
// Copyright 2023 Signal Messenger, LLC.
// SPDX-License-Identifier: AGPL-3.0-only
//

package org.signal.libsignal.zkgroup.calllinks;

import org.signal.libsignal.internal.Native;
import org.signal.libsignal.zkgroup.InvalidInputException;
import org.signal.libsignal.zkgroup.internal.ByteArray;

public final class CallLinkPublicParams extends ByteArray {
  public CallLinkPublicParams(byte[] contents) throws InvalidInputException {
    super(contents);
    Native.CallLinkPublicParams_CheckValidContents(contents);
  }
}
