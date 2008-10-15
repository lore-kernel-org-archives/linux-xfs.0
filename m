Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 19:50:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F2oaZ9013204
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 19:50:36 -0700
Date: Tue, 14 Oct 2008 22:52:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 988141 - Fix build error - use VFS_I() to access linux
	inode from xfs inode
Message-ID: <20081015025218.GB7864@infradead.org>
References: <20081015021055.6B76358FA1E9@chook.melbourne.sgi.com> <20081015022106.GA22939@infradead.org> <48F5654E.3080900@sgi.com> <20081015024014.GA21790@infradead.org> <48F56864.7030004@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F56864.7030004@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Wed, Oct 15, 2008 at 01:49:56PM +1000, Lachlan McIlroy wrote:
> We really appreciate you using the cvs tree and keeping all the non-
> mainline stuff up to date and working.  If you like I'll credit you for
> the patch when I push it to OSS.

I don't care much about the credit.  It's just annoying that the thing
first broke and had to be fixed and wasted your time just because
patches get lost all the time.
