Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 22:12:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S5BrKA016265
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 22:11:53 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 977D455030B
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 22:11:52 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id lvJSRh5fhwFWJcua for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 22:11:52 -0700 (PDT)
Date: Tue, 28 Oct 2008 16:11:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/7] factor out xfs_read_agf helper
Message-ID: <20081028051142.GB17077@disturbed>
References: <20081027133903.GC1109@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027133903.GC1109@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:39:03AM -0400, Christoph Hellwig wrote:
> Add a helper to read the AGF header and perform basic verification.
> Based on hunks from a larger patch from Dave Chinner.
> 
> (First sent on Juli 23rd)
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
