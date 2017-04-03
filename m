Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35930 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751635AbdDCLyJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Apr 2017 07:54:09 -0400
MIME-Version: 1.0
In-Reply-To: <24083.1491220005@warthog.procyon.org.uk>
References: <149121523070.22344.187602366514567082.stgit@warthog.procyon.org.uk>
 <149121524183.22344.1748203777026246762.stgit@warthog.procyon.org.uk>
 <CAOQ4uxhBgQ6q5GMe=G14Swvxto+y2_rZucZzK521Z4mCryOrZg@mail.gmail.com>
 <23054.1491218325@warthog.procyon.org.uk> <CAOQ4uxg73bQzakiUoQnvLxOztO4z-1ro+LZcDKsMCbOXA0g-3g@mail.gmail.com>
 <24083.1491220005@warthog.procyon.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Apr 2017 14:54:08 +0300
Message-ID: <CAOQ4uxiRsS5YiMbyEj_31xVtONVYGzrGJaiEBvj3DqzSBfeoSg@mail.gmail.com>
Subject: Re: [PATCH 2/4] xfstests: Add first statx test
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Mon, Apr 3, 2017 at 2:46 PM, David Howells <dhowells@redhat.com> wrote:
> Amir Goldstein <amir73il@gmail.com> wrote:
>
>> How about handling the errors with "|| echo stat_test failed"
>> and sticking to standard wrt status?
>
> Sure.
>

Thanks. You forgot to fix status in test 421.
