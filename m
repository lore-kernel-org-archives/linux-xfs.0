Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36499 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751539AbdDIHrL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Apr 2017 03:47:11 -0400
MIME-Version: 1.0
In-Reply-To: <149146775556.12770.11943651470996193921.stgit@warthog.procyon.org.uk>
References: <149146774821.12770.3592235770964461857.stgit@warthog.procyon.org.uk>
 <149146775556.12770.11943651470996193921.stgit@warthog.procyon.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 9 Apr 2017 10:47:10 +0300
Message-ID: <CAOQ4uxiXF4_N9Zu_OAWzC5STYyNY7VuGRYPeg1m4WPqhyZBOtA@mail.gmail.com>
Subject: Re: [PATCH 2/4] xfstests: Add first statx test [ver #10]
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Apr 6, 2017 at 11:35 AM, David Howells <dhowells@redhat.com> wrote:
> Add a statx test script that does the following:
>

David,

Just wanted to mention that albeit 'xfs' in 'xfstests', you don't need
to send generic
xfstests patched in the future to linux-xfs list.
I don't know that xfs folks mind, but you're discriminating other-fs folks ;-)

Cheers,
Amir.
