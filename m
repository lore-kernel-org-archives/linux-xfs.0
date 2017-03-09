Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41622 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752924AbdCIHp0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Mar 2017 02:45:26 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170309065908.GI14226@eguan.usersys.redhat.com>
References: <20170309065908.GI14226@eguan.usersys.redhat.com> <20170308034500.GY14226@eguan.usersys.redhat.com> <20170307050140.GA12946@infradead.org> <20170307000609.GG5280@birch.djwong.org> <10435.1488907375@warthog.procyon.org.uk> <21188.1489042008@warthog.procyon.org.uk>
Subject: Re: statx manpage
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21540.1489045522.1@warthog.procyon.org.uk>
Date: Thu, 09 Mar 2017 07:45:22 +0000
Message-ID: <21541.1489045522@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>, mtk.manpages@gmail.com, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

Eryu Guan <eguan@redhat.com> wrote:

> A normal way we take for fstests is adding new syscall support to xfs_io
> first, then writing new tests based on it, as some other new
> syscalls/utilities do, e.g. set|get_encpolicy were added to xfs_io
> in January to set|get encryption policy for ext4 encryption testing.

Please add this to the docs.

Thanks,
David
