Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36764 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932200AbdDEQbm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 12:31:42 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOQ4uxhsv2xyUCXh08sOOYa1Lc80FKtUm5a1fmrEFhi70SR2-g@mail.gmail.com>
References: <CAOQ4uxhsv2xyUCXh08sOOYa1Lc80FKtUm5a1fmrEFhi70SR2-g@mail.gmail.com> <149139655968.12368.18434671350530288572.stgit@warthog.procyon.org.uk> <149139658242.12368.4089798272550801222.stgit@warthog.procyon.org.uk>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by chattr [ver #6]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27330.1491409899.1@warthog.procyon.org.uk>
Date: Wed, 05 Apr 2017 17:31:39 +0100
Message-ID: <27331.1491409899@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: dhowells@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

Amir Goldstein <amir73il@gmail.com> wrote:

> As you have already realized, there are some good practices in xfstests that
> grew over the years, but some tests date back to before those practices and
> some tests we just did not review well enough...

Good practices effectively don't exist if you don't document them ;-)

David
