Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Sep 2008 06:20:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8EDKYRx001884
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 06:20:35 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E2BA126E74A
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 06:22:05 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 9ZSFJaukymtws2HZ for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 06:22:05 -0700 (PDT)
Date: Sun, 14 Sep 2008 09:22:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6] XFS: replace the mount inode list with radix tree
	traversals V4
Message-ID: <20080914132204.GB14266@infradead.org>
References: <1221314040-27990-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221314040-27990-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sat, Sep 13, 2008 at 11:53:54PM +1000, Dave Chinner wrote:
> o revert xfs_syncsub -> xfs_sync change in xfs_quiesce_fs and
>   rediff patch series

So no changes to the last version posted, and you still have my ACK for
it..
