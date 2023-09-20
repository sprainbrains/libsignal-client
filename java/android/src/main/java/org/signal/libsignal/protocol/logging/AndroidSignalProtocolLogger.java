//
// Copyright 2014-2016 Signal Messenger, LLC.
// SPDX-License-Identifier: AGPL-3.0-only
//

package org.signal.libsignal.protocol.logging;

import android.util.Log;
import android.util.SparseIntArray;

public class AndroidSignalProtocolLogger implements SignalProtocolLogger {

  private static final SparseIntArray PRIORITY_MAP =
      new SparseIntArray(5) {
        {
          put(SignalProtocolLogger.INFO, Log.INFO);
          put(SignalProtocolLogger.ASSERT, Log.ASSERT);
          put(SignalProtocolLogger.DEBUG, Log.DEBUG);
          put(SignalProtocolLogger.VERBOSE, Log.VERBOSE);
          put(SignalProtocolLogger.WARN, Log.WARN);
        }
      };

  @Override
  public void log(int priority, String tag, String message) {
    int androidPriority = PRIORITY_MAP.get(priority, Log.WARN);
    Log.println(androidPriority, tag, message);
  }
}
