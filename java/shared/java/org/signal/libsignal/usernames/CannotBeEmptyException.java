//
// Copyright 2023 Signal Messenger, LLC.
// SPDX-License-Identifier: AGPL-3.0-only
//

package org.signal.libsignal.usernames;

public final class CannotBeEmptyException extends BaseUsernameException {
  public CannotBeEmptyException(String message) {
    super(message);
  }
}
