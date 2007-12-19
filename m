Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 16:41:35 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBJ0fP0W006272
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 16:41:28 -0800
Date: Wed, 19 Dec 2007 11:41:26 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [GIT PULL] XFS update for 2.6.24-rc6
Message-ID: <20071219004126.GS4396912@sgi.com>
References: <20071218065911.EDC8158C4C0F@chook.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218065911.EDC8158C4C0F@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

On Tue, Dec 18, 2007 at 05:59:11PM +1100, Lachlan McIlroy wrote:
> Please pull from the for-linus branch:
>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

Linus, please don't pull this yet. A problem has been found in
the dirent fix, and we've just fixed another mknod related regression
so we've got another couple of fixes still to go in XFS for 2.6.24.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
