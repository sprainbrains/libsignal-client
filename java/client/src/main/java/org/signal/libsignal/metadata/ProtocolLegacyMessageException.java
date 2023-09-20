//
// Copyright 2023 Signal Messenger, LLC.
// SPDX-License-Identifier: AGPL-3.0-only
//

package org.signal.libsignal.metadata;

import org.signal.libsignal.metadata.protocol.UnidentifiedSenderMessageContent;
import org.signal.libsignal.protocol.LegacyMessageException;

public class ProtocolLegacyMessageException extends ProtocolException {
  public ProtocolLegacyMessageException(
      LegacyMessageException e, String sender, int senderDeviceId) {
    super(e, sender, senderDeviceId);
  }

  ProtocolLegacyMessageException(
      LegacyMessageException e, UnidentifiedSenderMessageContent content) {
    super(e, content);
  }
}
