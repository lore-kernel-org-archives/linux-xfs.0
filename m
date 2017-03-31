Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55808 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933159AbdCaQ6H (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Mar 2017 12:58:07 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170331160224.GA27791@infradead.org>
References: <20170331160224.GA27791@infradead.org> <20170331154315.GB29622@ZenIV.linux.org.uk> <20170311065823.4415-1-ebiggers3@gmail.com> <20170320171142.GA26906@gmail.com> <20170320174422.GA9304@infradead.org> <20170331153952.GA32460@infradead.org> <21301.1490975484@warthog.procyon.org.uk>
Subject: Re: [PATCH] statx: reject unknown flags when using NULL path
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5985.1490979482.1@warthog.procyon.org.uk>
Date: Fri, 31 Mar 2017 17:58:02 +0100
Message-ID: <5986.1490979482@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, Al Viro <viro@ZenIV.linux.org.uk>, Eric Biggers <ebiggers3@gmail.com>, linux-fsdevel@vger.kernel.org, mtk.manpages@gmail.com, "Darrick J . Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

Christoph Hellwig <hch@infradead.org> wrote:

> The only thing he could do even better is to add a testcase to xfstests
> to verify this :)

I will be pushing this sort of thing to LTP.

David
