package org.signal.libsignal.metadata;

import org.signal.libsignal.metadata.protocol.UnidentifiedSenderMessageContent;
import org.whispersystems.libsignal.util.guava.Optional;

public class ProtocolInvalidKeyIdException extends ProtocolException {
  public ProtocolInvalidKeyIdException(Exception e, String sender, int senderDevice) {
    super(e, sender, senderDevice);
  }

  ProtocolInvalidKeyIdException(Exception e, UnidentifiedSenderMessageContent content) {
    super(e, content);
  }
}
