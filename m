Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 May 2008 01:57:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m458vXb3010443
	for <xfs@oss.sgi.com>; Mon, 5 May 2008 01:57:34 -0700
Date: Mon, 5 May 2008 04:58:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: ASCII CI support in xfsprogs
Message-ID: <20080505085817.GB2188@infradead.org>
References: <op.uagkf9jl3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080501131725.GB7435@infradead.org> <op.uah2w02l3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.uah2w02l3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Fri, May 02, 2008 at 10:13:38AM +1000, Barry Naujok wrote:
> Yes, I was going to do "ascii-ci=Y|N", got to keep it clear in only
> does CI for A-Z.

Fine with me.

> I was thinking of that, but libxfs is pretty out of date anyway from
> all the cleanup changes that have occured and would like to sync them
> back at some stage in the near future. The sync would bring those other
> changes in at that time (Nathan can correct me if I misunderstand the
> sync process!)

Yeah, it should bring over the files from the kernel tree.
