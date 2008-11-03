Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Nov 2008 17:28:25 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA31SBoh020795
	for <xfs@oss.sgi.com>; Sun, 2 Nov 2008 17:28:11 -0800
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74DD81BDB77B
	for <xfs@oss.sgi.com>; Sun,  2 Nov 2008 17:28:12 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id j5vrDLh7jeUaU9nQ for <xfs@oss.sgi.com>; Sun, 02 Nov 2008 17:28:12 -0800 (PST)
Date: Mon, 3 Nov 2008 12:28:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] kill the XFS_IMAP_BULKSTAT flag
Message-ID: <20081103012811.GQ19509@disturbed>
References: <20081027134129.GF3183@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027134129.GF3183@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:41:29AM -0400, Christoph Hellwig wrote:
> Just pass down the XFS_IGET_* flags all the way down to xfs_imap instead
> of translating them mid-way.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
