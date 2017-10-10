Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49755 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751596AbdJJEH7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2017 00:07:59 -0400
Date: Mon, 9 Oct 2017 21:07:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: handle error if xfs_btree_get_bufs fails
Message-ID: <20171010040736.GY7122@magnolia>
References: <20171010021949.GB8049@wotan.suse.de>
 <a0eaaf24-75cf-19c4-c287-2445eae6fc70@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0eaaf24-75cf-19c4-c287-2445eae6fc70@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, gfigueira@suse.com, tetsuya.inoue@suse.com

On Mon, Oct 09, 2017 at 10:07:12PM -0500, Eric Sandeen wrote:
> 
> 
> On 10/9/17 9:19 PM, Luis R. Rodriguez wrote:
> > What ever happened to this patch [0]? It was ACKed [1] 
> 
> (it was reviewed-by hch)
> 
> > but I haven't
> > seen it merged. Did it fall through the cracks?
> 
> Seems like it, possibly because I sent V2 as a re:, accidentally.

<grumble>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> -Eric
>  
> > [0] https://patchwork.kernel.org/patch/9486811/
> > [1] https://www.spinics.net/lists/linux-xfs/msg02818.html
> > 
> >   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
