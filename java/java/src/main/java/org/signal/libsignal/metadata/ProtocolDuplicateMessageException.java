package org.signal.libsignal.metadata;

import org.signal.libsignal.metadata.protocol.UnidentifiedSenderMessageContent;
import org.whispersystems.libsignal.util.guava.Optional;

public class ProtocolDuplicateMessageException extends ProtocolException {
  public ProtocolDuplicateMessageException(Exception e, String sender, int senderDevice) {
    super(e, sender, senderDevice);
  }

  ProtocolDuplicateMessageException(Exception e, UnidentifiedSenderMessageContent content) {
    super(e, content);
  }
}
