//
// Copyright 2023 Signal Messenger, LLC.
// SPDX-License-Identifier: AGPL-3.0-only
//

package org.signal.libsignal.metadata;

public class InvalidMetadataVersionException extends Exception {
  public InvalidMetadataVersionException(String s) {
    super(s);
  }
}
