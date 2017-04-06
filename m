Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47876 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756499AbdDFI4D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 04:56:03 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOQ4uxg4s6AsxxYVps1s_KLh-5_FwO40pJ2gPmY9haG8bDjhug@mail.gmail.com>
References: <CAOQ4uxg4s6AsxxYVps1s_KLh-5_FwO40pJ2gPmY9haG8bDjhug@mail.gmail.com> <149140993804.27340.4198614944626347024.stgit@warthog.procyon.org.uk> <149140996132.27340.12936555593689822963.stgit@warthog.procyon.org.uk> <CAOQ4uxgsmKHZ85Qg__zhU13tb4ARLHHWzUoCEvEUE7LNYNnHnQ@mail.gmail.com> <11800.1491462484@warthog.procyon.org.uk>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by chattr [ver #7]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15455.1491468961.1@warthog.procyon.org.uk>
Date: Thu, 06 Apr 2017 09:56:01 +0100
Message-ID: <15456.1491468961@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>, eguan@redhat.com
Cc: dhowells@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

Amir Goldstein <amir73il@gmail.com> wrote:

> The typo is still in v9:
> 
> #      $CHATTR_PROG flag       stx_attributes flag

Aargh.  I missed one.  Shall I post another version with just this change?

David
