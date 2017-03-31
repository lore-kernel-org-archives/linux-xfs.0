Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38738 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751313AbdCaN6M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Mar 2017 09:58:12 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170331121342.GN22845@eguan.usersys.redhat.com>
References: <20170331121342.GN22845@eguan.usersys.redhat.com> <20170331101941.GL22845@eguan.usersys.redhat.com> <15267.1490891560@warthog.procyon.org.uk> <14231.1490961943@warthog.procyon.org.uk>
Subject: Re: [PATCH] xfstests: Add first statx test
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17196.1490968688.1@warthog.procyon.org.uk>
Date: Fri, 31 Mar 2017 14:58:08 +0100
Message-ID: <17197.1490968688@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: dhowells@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, fstests@vger.kernel.org

Eryu Guan <eguan@redhat.com> wrote:

> # create filesystem on SCRATCH_DEV and mount it at SCRATCH_MNT
> _scratch_mkfs
> _scratch_mount

This doesn't seem to be necessary; it's doing it automatically for me.

David
