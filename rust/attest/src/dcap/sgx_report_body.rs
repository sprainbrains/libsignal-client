//
// Copyright 2022 Signal Messenger, LLC.
// SPDX-License-Identifier: AGPL-3.0-only
//

//! SGX report body, ported from Open Enclave headers in v0.17.7.

use std::convert::TryFrom;
use std::intrinsics::transmute;

use crate::endian::*;

// Inline header file references are paths from the root of the repository tree.
// https://github.com/openenclave/openenclave/tree/v0.17.7

// sgx_report.h
const SGX_CPUSVN_SIZE: usize = 16;
const SGX_HASH_SIZE: usize = 32;

#[derive(Debug)]
#[repr(C, packed)]
// sgx_report_body_t
pub(crate) struct SgxReportBody {
    //     /* (0) CPU security version */
    //     uint8_t cpusvn[SGX_CPUSVN_SIZE];
    cpusvn: [u8; SGX_CPUSVN_SIZE],

    //     /* (16) Selector for which fields are defined in SSA.MISC */
    //     uint32_t miscselect;
    _miscselect: UInt32LE,

    //     /* (20) Reserved */
    //     uint8_t reserved1[12];
    _reserved1: [u8; 12],

    //     /* (32) Enclave extended product ID */
    //     uint8_t isvextprodid[16];
    _isvextprodid: [u8; 16],

    //
    //     /* (48) Enclave attributes */
    //     sgx_attributes_t attributes;
    _sgx_attributes: [u8; 16],
    //
    //     /* (64) Enclave measurement */
    //     uint8_t mrenclave[SGX_HASH_SIZE];
    _mrenclave: [u8; SGX_HASH_SIZE],

    //
    //     /* (96) Reserved */
    //     uint8_t reserved2[32];
    _reserved2: [u8; 32],

    //
    //     /* (128) The value of the enclave's SIGNER measurement */
    //     uint8_t mrsigner[SGX_HASH_SIZE];
    _mrsigner: [u8; SGX_HASH_SIZE],

    //     /* (160) Reserved */
    //     uint8_t reserved3[32];
    _reserved3: [u8; 32],

    //     /* (192) Enclave Configuration ID*/
    //     uint8_t configid[64];
    _configid: [u8; 64],

    //     /* (256) Enclave product ID */
    //     uint16_t isvprodid;
    _isvprodid: UInt16LE,

    //     /* (258) Enclave security version */
    //     uint16_t isvsvn;
    _isvsvn: UInt16LE,

    //     /* (260) Enclave Configuration Security Version*/
    //     uint16_t configsvn;
    _configsvn: UInt16LE,

    //     /* (262) Reserved */
    //     uint8_t reserved4[42];
    _reserved4_bytes: [u8; 42],

    //     /* (304) Enclave family ID */
    //     uint8_t isvfamilyid[16];
    _isvfamilyid: [u8; 16],

    //     /* (320) User report data */
    //     sgx_report_data_t report_data;  // unsigned char field[64];
    _sgx_report_data_bytes: [u8; 64],
}

static_assertions::const_assert_eq!(384, std::mem::size_of::<SgxReportBody>());

impl TryFrom<[u8; std::mem::size_of::<SgxReportBody>()]> for SgxReportBody {
    type Error = super::Error;

    fn try_from(src: [u8; std::mem::size_of::<SgxReportBody>()]) -> super::Result<Self> {
        unsafe { Ok(transmute(src)) }
    }
}
