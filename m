Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 May 2008 06:25:09 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4MDOqfB003859
	for <xfs@oss.sgi.com>; Thu, 22 May 2008 06:24:53 -0700
Date: Thu, 22 May 2008 09:25:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] xfsqa test to check log size scaling
Message-ID: <20080522132542.GC4972@infradead.org>
References: <20080522061257.GR173056135@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522061257.GR173056135@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, May 22, 2008 at 04:12:57PM +1000, David Chinner wrote:
> XFS-QA test to check that log size scaling works correctly
> for old and new maximum log sizes.

Am I missing somethign or would this fail if the partitions used for
xfsqa are smaller than 256GB?  I don't even have that much total storage
on my laptop :)
