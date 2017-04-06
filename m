Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:32816 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752059AbdDFIUY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2017 04:20:24 -0400
MIME-Version: 1.0
In-Reply-To: <11800.1491462484@warthog.procyon.org.uk>
References: <149140993804.27340.4198614944626347024.stgit@warthog.procyon.org.uk>
 <149140996132.27340.12936555593689822963.stgit@warthog.procyon.org.uk>
 <CAOQ4uxgsmKHZ85Qg__zhU13tb4ARLHHWzUoCEvEUE7LNYNnHnQ@mail.gmail.com> <11800.1491462484@warthog.procyon.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 6 Apr 2017 11:20:23 +0300
Message-ID: <CAOQ4uxg4s6AsxxYVps1s_KLh-5_FwO40pJ2gPmY9haG8bDjhug@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by chattr
 [ver #7]
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Apr 6, 2017 at 10:08 AM, David Howells <dhowells@redhat.com> wrote:
> Amir Goldstein <amir73il@gmail.com> wrote:
>
>> I think you have an unintentional search&replace typo below.
>> I don't mind though.
>> Eryu is usually generous in offering to fix these sort of things at
>> commit time ;-)
>
> I've fixed that and pushed a new version with the test scripts renumbered.
>

The typo is still in v9:

#      $CHATTR_PROG flag       stx_attributes flag
