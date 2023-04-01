//
// Copyright 2020-2022 Signal Messenger, LLC.
// SPDX-License-Identifier: AGPL-3.0-only
//

//! Interfaces in [traits] and reference implementations in [inmem] for various mutable stores.

#![warn(missing_docs)]

mod inmem;
mod traits;

pub use inmem::{
    InMemIdentityKeyStore, InMemPreKeyStore, InMemSenderKeyStore, InMemSessionStore,
    InMemSignalProtocolStore, InMemSignedPreKeyStore,
};
pub use traits::{
    Context, Direction, IdentityKeyStore, PreKeyStore, ProtocolStore, SenderKeyStore, SessionStore,
    SignedPreKeyStore,
};
