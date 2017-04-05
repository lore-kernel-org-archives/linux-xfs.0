Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59040 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753893AbdDEMZ7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 08:25:59 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170405105226.GA22845@eguan.usersys.redhat.com>
References: <20170405105226.GA22845@eguan.usersys.redhat.com> <149132130900.18980.537296385250153410.stgit@warthog.procyon.org.uk> <149132133562.18980.13032775360715592290.stgit@warthog.procyon.org.uk>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by chattr [ver #5]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5765.1491395157.1@warthog.procyon.org.uk>
Date: Wed, 05 Apr 2017 13:25:57 +0100
Message-ID: <5766.1491395157@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: dhowells@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

Eryu Guan <eguan@redhat.com> wrote:

> And this test is expected to fail with 4.11-rc5 kernel on all
> filesystems, right?

Yes, and probably some thereafter.  Is there a way of requiring the kernel
version?

David
