Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Aug 2008 18:42:52 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7M1glN1025664
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 18:42:49 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E83F71A2A9CC
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 18:44:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id uTp8s4eZyxABohZO for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 18:44:08 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KWLhA-0005hM-2U
	for xfs@oss.sgi.com; Fri, 22 Aug 2008 01:44:08 +0000
Date: Thu, 21 Aug 2008 21:44:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/28] XFS: sync and reclaim rework
Message-ID: <20080822014407.GA21740@infradead.org>
References: <1219151804-30749-1-git-send-email-david@fromorbit.com> <20080819235920.GK24344@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819235920.GK24344@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wed, Aug 20, 2008 at 09:59:20AM +1000, Dave Chinner wrote:
> On Tue, Aug 19, 2008 at 11:16:16PM +1000, Dave Chinner wrote:
> > 
> > Multiple patch sets, all in one patch bomb against a current
> > git tree. This includes all outstanding patches I have previously
> > sent that are not committed plus a bunch more...
> 
> A bunch of ppl (including me) have not seen the entire patchset
> come through the list yet [*], so I've tarred up the patch set and
> attached it below.

Thanks, the patches looks good to me modulo the consmetic comments
pointed out on IRC.  They also survive xfsqs ontop of my btree patches.
