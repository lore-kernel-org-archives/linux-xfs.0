Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Feb 2008 22:39:45 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m176dYY7029619
	for <xfs@oss.sgi.com>; Wed, 6 Feb 2008 22:39:37 -0800
Date: Thu, 7 Feb 2008 01:39:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: unpushed 4-month-old mods?
Message-ID: <20080207063929.GA31513@infradead.org>
References: <47A694F3.9010307@sandeen.net> <20080204044611.GF155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204044611.GF155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Mon, Feb 04, 2008 at 03:46:11PM +1100, David Chinner wrote:
> On Sun, Feb 03, 2008 at 10:30:43PM -0600, Eric Sandeen wrote:
> > At least these three mods which I did back in September to get Fedora 8
> > / 2.6.23 into shape on 4k stacks, and a bugfix, are still not pushed to
> > kernel.org, and are missing in 2.6.24...
> > 
> > Is there any reason for the holdup?  Makes me wonder what else isn't
> > pushed...
> 
> The holdup is that we drew a line in the sand for the 2.6.24 before
> 2.6.23 was released. We did this because of the massive amount of invasive
> change we already had queued up for 2.6.24.  All those mods that got
> held up will be pushed into 2.6.25 release.

For which it's getting about time.  The merge window started about with
LCA, so by the tradition 2 weeks rule it'll close by the end of the
week..
