Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755947AbdDFHIH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 03:08:07 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOQ4uxgsmKHZ85Qg__zhU13tb4ARLHHWzUoCEvEUE7LNYNnHnQ@mail.gmail.com>
References: <CAOQ4uxgsmKHZ85Qg__zhU13tb4ARLHHWzUoCEvEUE7LNYNnHnQ@mail.gmail.com> <149140993804.27340.4198614944626347024.stgit@warthog.procyon.org.uk> <149140996132.27340.12936555593689822963.stgit@warthog.procyon.org.uk>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by chattr [ver #7]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11799.1491462484.1@warthog.procyon.org.uk>
Date: Thu, 06 Apr 2017 08:08:04 +0100
Message-ID: <11800.1491462484@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: dhowells@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

Amir Goldstein <amir73il@gmail.com> wrote:

> I think you have an unintentional search&replace typo below.
> I don't mind though.
> Eryu is usually generous in offering to fix these sort of things at
> commit time ;-)

I've fixed that and pushed a new version with the test scripts renumbered.

David
