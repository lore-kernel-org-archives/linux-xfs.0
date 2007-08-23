Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:45:36 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJjU4p009173
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:45:34 -0700
Date: Thu, 23 Aug 2007 15:45:27 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Subject: Re: [PATCH 4/17] kill the v_flag member in struct bhv_vnode
Message-ID: <20070823194527.GA8431@filer.fsl.cs.sunysb.edu>
References: <20070823193807.GE8050@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823193807.GE8050@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, Aug 23, 2007 at 09:38:07PM +0200, Christoph Hellwig wrote:
> 
> All flags previous handled at the vnode level are not in the xfs_inode
                                                    ^^^
typo :)

> where we already have a flags mechanisms and free bits for flags
> previously in the vnode.

Yeah, didn't notice anything else...

Jeff.

-- 
The box said "Windows XP or better required". So I installed Linux.
