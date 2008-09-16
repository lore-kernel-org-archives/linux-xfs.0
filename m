Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 22:11:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8G5B0M8003813
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:11:02 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B71A51275A69
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:12:32 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id MuH8Nww5FycC8ACb for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:12:32 -0700 (PDT)
Date: Tue, 16 Sep 2008 15:12:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] fix up btree headers for userspace
Message-ID: <20080916051213.GU5811@disturbed>
References: <20080915004640.GB12213@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915004640.GB12213@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Sep 15, 2008 at 02:46:40AM +0200, Christoph Hellwig wrote:
> Remove two __KERNEL__ sections in xfs_bmap_btree.h and xfs_btree.h that
> prevent using the new generic btree code in xfsprogs.

looks fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
