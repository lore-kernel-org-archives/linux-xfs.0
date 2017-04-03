Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60982 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750777AbdDCLrB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Apr 2017 07:47:01 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOQ4uxg73bQzakiUoQnvLxOztO4z-1ro+LZcDKsMCbOXA0g-3g@mail.gmail.com>
References: <CAOQ4uxg73bQzakiUoQnvLxOztO4z-1ro+LZcDKsMCbOXA0g-3g@mail.gmail.com> <149121523070.22344.187602366514567082.stgit@warthog.procyon.org.uk> <149121524183.22344.1748203777026246762.stgit@warthog.procyon.org.uk> <CAOQ4uxhBgQ6q5GMe=G14Swvxto+y2_rZucZzK521Z4mCryOrZg@mail.gmail.com> <23054.1491218325@warthog.procyon.org.uk>
Subject: Re: [PATCH 2/4] xfstests: Add first statx test
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24082.1491220005.1@warthog.procyon.org.uk>
Date: Mon, 03 Apr 2017 12:46:45 +0100
Message-ID: <24083.1491220005@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: dhowells@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

Amir Goldstein <amir73il@gmail.com> wrote:

> How about handling the errors with "|| echo stat_test failed"
> and sticking to standard wrt status?

Sure.

David
