Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Feb 2007 12:33:21 -0800 (PST)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l18KXAm7023671
	for <xfs@oss.sgi.com>; Thu, 8 Feb 2007 12:33:15 -0800
Date: Thu, 8 Feb 2007 21:33:09 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fix sparse warning in xfs_da_btree.c
Message-ID: <20070208203309.GA3012@lst.de>
References: <20061129154441.GA6400@lst.de> <20070207125437.GA7740@lst.de> <45CA1327.2030005@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CA1327.2030005@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Feb 07, 2007 at 05:57:59PM +0000, Lachlan McIlroy wrote:
> Christoph,
> 
> I merged this change a while ago but it looks like the take message
> didn't make it to oss.

Ah, okay - thanks for putting this in.  And we really should find
a way to make the system send out TAKE messages automatically so
that developers can't acidentally not send it out.. (and while we're
at it make sure the diff is sent out in the message aswell as for
most cvs/svn commit list setups..)
