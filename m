Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 May 2008 12:09:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4PJ9pOv023588
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 12:09:51 -0700
Date: Sun, 25 May 2008 21:10:33 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: TAKE streamline init/exit path
Message-ID: <20080525191033.GA14139@lst.de>
References: <20080518130511.GA28501@lst.de> <nccprrg32vr.fsf@sgi.com> <20080521060103.GA25003@lst.de> <nccej7w2l9c.fsf@sgi.com> <20080521072425.GA29889@lst.de> <ncc7ido2i1g.fsf_-_@sgi.com> <20080522155616.GA7682@lst.de> <op.ubkzio0b3jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ubkzio0b3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, Niv Sardi <xaiki@sgi.com>, xfs@oss.sgi.com

On Fri, May 23, 2008 at 10:26:38AM +1000, Barry Naujok wrote:
> >Well, mangrove was the sles10 NAS tree if I remember correctly.  And it
> >indeed hasn't made it to either the CVS or git tree on oss.sgi.com yet.
> 
> That's the name of the workarea (and why it's called that... I have
> no idea!!)
> 
> But, the mod did go to the correct location:
> 
> Modid:  xfs-linux-melb:xfs-kern:31210a
> 
> But there is a few hour gap going from Melbourne to the US repository
> and then to oss.

Neither this nor your kmem_free commit have made it yet the CVS tree on
oss.sgi.com.  I guess the push is broken again for some reason.
