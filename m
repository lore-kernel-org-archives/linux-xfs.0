Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Feb 2007 14:08:47 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l15M8e3c009160
	for <xfs@oss.sgi.com>; Mon, 5 Feb 2007 14:08:42 -0800
Date: Mon, 5 Feb 2007 21:09:13 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: freezing sometimes leaves the log dirty
Message-ID: <20070205210913.GA6062@infradead.org>
References: <20070130220326.GM33919298@melbourne.sgi.com> <20070202114623.GA23187@infradead.org> <20070202140706.GX33919298@melbourne.sgi.com> <20070205210245.GP44411608@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205210245.GP44411608@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Tue, Feb 06, 2007 at 08:02:45AM +1100, David Chinner wrote:
> On Sat, Feb 03, 2007 at 01:07:06AM +1100, David Chinner wrote:
> > Patch below cleans all this up and also fixes the 2.4 tree as well.
> 
> Can I get an ack from someone on this?
> 

Looks good to me.
