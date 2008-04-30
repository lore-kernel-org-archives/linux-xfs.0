Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 03:22:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3UALqt2028684
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 03:21:57 -0700
Date: Wed, 30 Apr 2008 20:22:32 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: TAKE 979416 - Don't initialise new inode generation numbers to zero
Message-ID: <20080430102232.GL108924158@sgi.com>
References: <20080429004144.757D658C4C15@chook.melbourne.sgi.com> <48183AA5.9030804@decisionsoft.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48183AA5.9030804@decisionsoft.co.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stuart Rowan <strr-debian@decisionsoft.co.uk>
Cc: David Chinner <dgc@sgi.com>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Wed, Apr 30, 2008 at 10:23:49AM +0100, Stuart Rowan wrote:
> Is this liable to affect the stable releases, 2.6.24.y and 2.6.25.y? If so, 
> is it appropriate for forwarding to the stable team?

Yes, and I will do so once we've got .26-rc1 out the door.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
