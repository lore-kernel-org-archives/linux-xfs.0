Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 19:54:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S2sc57002567
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 19:54:39 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55C8A1495774
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 19:54:37 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id WCkqTTW2vyQeP51n for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 19:54:37 -0700 (PDT)
Date: Tue, 28 Oct 2008 13:54:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] remove restricted_chown parameter
Message-ID: <20081028025433.GO4985@disturbed>
References: <20081027133637.GC761@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027133637.GC761@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, Tim Shimmin <tes@sgi.com>

On Mon, Oct 27, 2008 at 09:36:37AM -0400, Christoph Hellwig wrote:
> From: Tim Shimmin <tes@sgi.com>
> 
> On Linux all filesystems are supposed to be operating under
> Posix' restricted chown. Restricted chown means it restricts
> chown to the owner unless you have CAP_FOWNER.
> 
> [hch: forward-ported to the current tree]
> 
> 
> Signed-off-by: Tim Shimmin <tes@sgi.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
