Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Sep 2007 11:27:00 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8HIQsuw005220
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2007 11:26:55 -0700
Date: Mon, 17 Sep 2007 19:08:52 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] fix 32-bit compat ioctls for GETXFLAGS, SETXFLAGS, GETVERSION
Message-ID: <20070917180851.GA26874@infradead.org>
References: <46EDDCA7.5030601@sandeen.net> <46EEBB02.9050507@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EEBB02.9050507@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Sep 17, 2007 at 12:36:02PM -0500, Eric Sandeen wrote:
> Also, for both native and compat versions, just define them to
> the values as defined in fs.h

Should we just kill the XFS_ variants?

Otherwise the patch looks good.
